from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from core.config import settings
from api.routes import astrology
from api.routes.auth import router as auth_router
from api.routes.users import router as users_router
from api.routes.content import router as content_router
from api.routes.compatibility import router as compatibility_router

app = FastAPI(
    title="Astro App API",
    version="2.0.0",
    description="10M-scale Astrology Backend — Auth, Charts, Daily Readings, Compatibility"
)

# Setup CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Routers ---
API_PREFIX = "/api/v1"

app.include_router(auth_router, prefix=API_PREFIX)
app.include_router(users_router, prefix=API_PREFIX)
app.include_router(content_router, prefix=API_PREFIX)
app.include_router(compatibility_router, prefix=API_PREFIX)
app.include_router(astrology.router, prefix=API_PREFIX)  # legacy chart endpoint


@app.get("/health")
async def health_check():
    return {
        "status": "ok",
        "version": "2.0.0",
        "environment": settings.ENVIRONMENT,
        "services": ["auth", "users", "content", "compatibility", "astrology"]
    }


@app.get("/")
async def root():
    return {"message": "Astro API is running", "docs": "/docs"}
