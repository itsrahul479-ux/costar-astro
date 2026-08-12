-- ============================================================
-- ASTRO APP — Database Schema for 10M Users
-- Run this in Supabase SQL Editor
-- ============================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- USERS
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT,
  name TEXT,
  provider TEXT DEFAULT 'email',  -- 'email', 'google', 'apple'
  avatar_url TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);
CREATE INDEX IF NOT EXISTS idx_users_provider ON users(provider);

-- ============================================================
-- BIRTH PROFILES
-- ============================================================
CREATE TABLE IF NOT EXISTS birth_profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  birth_date DATE NOT NULL,
  birth_time TIME,
  birth_city TEXT,
  latitude FLOAT,
  longitude FLOAT,
  timezone TEXT DEFAULT 'Asia/Kolkata',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE INDEX IF NOT EXISTS idx_birth_profiles_user_id ON birth_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_birth_profiles_birth_date ON birth_profiles(birth_date);

-- ============================================================
-- NATAL CHARTS (cached calculations — never recalculate)
-- ============================================================
CREATE TABLE IF NOT EXISTS natal_charts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE,
  chart_data JSONB NOT NULL,     -- full planets, houses, aspects
  sun_sign TEXT,
  moon_sign TEXT,
  rising_sign TEXT,
  calculated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE INDEX IF NOT EXISTS idx_natal_charts_user_id ON natal_charts(user_id);
CREATE INDEX IF NOT EXISTS idx_natal_charts_sun_sign ON natal_charts(sun_sign);

-- ============================================================
-- DAILY READINGS (pre-generated, 1 per user per day)
-- ============================================================
CREATE TABLE IF NOT EXISTS daily_readings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  reading_text TEXT,
  planet_summary JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, date)
);

CREATE INDEX IF NOT EXISTS idx_daily_readings_user_date ON daily_readings(user_id, date);
CREATE INDEX IF NOT EXISTS idx_daily_readings_date ON daily_readings(date);

-- ============================================================
-- FRIENDSHIPS
-- ============================================================
CREATE TABLE IF NOT EXISTS friendships (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  friend_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  status TEXT DEFAULT 'pending',   -- pending, accepted, blocked
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, friend_user_id)
);

CREATE INDEX IF NOT EXISTS idx_friendships_user_id ON friendships(user_id);
CREATE INDEX IF NOT EXISTS idx_friendships_friend_id ON friendships(friend_user_id);
CREATE INDEX IF NOT EXISTS idx_friendships_status ON friendships(status);

-- ============================================================
-- COMPATIBILITY REPORTS (cached by pair_hash)
-- ============================================================
CREATE TABLE IF NOT EXISTS compatibility_reports (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id_a UUID REFERENCES users(id),
  user_id_b UUID REFERENCES users(id),
  pair_hash TEXT UNIQUE NOT NULL,  -- MD5 of sorted(user_id_a + user_id_b)
  score INTEGER,                    -- 0-100
  report_data JSONB,
  sun_sign_a TEXT,
  sun_sign_b TEXT,
  compatible BOOLEAN,
  calculated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_compatibility_pair ON compatibility_reports(pair_hash);
CREATE INDEX IF NOT EXISTS idx_compatibility_user_a ON compatibility_reports(user_id_a);
CREATE INDEX IF NOT EXISTS idx_compatibility_user_b ON compatibility_reports(user_id_b);

-- ============================================================
-- SUBSCRIPTIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS subscriptions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE,
  plan TEXT DEFAULT 'free',        -- free, pro, premium
  status TEXT DEFAULT 'active',    -- active, cancelled, expired
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_status ON subscriptions(status);
CREATE INDEX IF NOT EXISTS idx_subscriptions_plan ON subscriptions(plan);

-- ============================================================
-- Helper: auto-update updated_at timestamp
-- ============================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_birth_profiles_updated_at BEFORE UPDATE ON birth_profiles
  FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON subscriptions
  FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- ============================================================
-- Row Level Security (RLS) — Enable for production
-- ============================================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE birth_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE natal_charts ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_readings ENABLE ROW LEVEL SECURITY;
ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;
ALTER TABLE compatibility_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

-- Users can only read/write their own data
CREATE POLICY "Users can view own profile" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can manage own birth profile" ON birth_profiles FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can view own chart" ON natal_charts FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can view own readings" ON daily_readings FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can manage friendships" ON friendships FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can view own subscription" ON subscriptions FOR SELECT USING (auth.uid() = user_id);
