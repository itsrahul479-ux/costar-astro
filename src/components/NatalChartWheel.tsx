import React, { useRef, useEffect, useState } from 'react';
import { NatalChart, PlanetPosition, ZodiacSign } from '../types/astrology';
import { ZODIAC_SIGNS, ZODIAC_SYMBOLS } from '../services/astrologyEngine';

interface NatalChartWheelProps {
  chart: NatalChart;
  size?: number;
  onPlanetSelect?: (planet: PlanetPosition) => void;
}

export const NatalChartWheel: React.FC<NatalChartWheelProps> = ({
  chart,
  size = 380,
  onPlanetSelect
}) => {
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const [hoveredPlanet, setHoveredPlanet] = useState<PlanetPosition | null>(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const dpr = window.devicePixelRatio || 1;
    canvas.width = size * dpr;
    canvas.height = size * dpr;
    ctx.scale(dpr, dpr);

    const center = size / 2;
    const outerRadius = size * 0.44;
    const innerRadius = size * 0.33;
    const houseRadius = size * 0.23;
    const aspectRadius = size * 0.20;

    // Clear Canvas
    ctx.clearRect(0, 0, size, size);

    // Style tokens
    const isDark = true;
    const lineColor = isDark ? '#333333' : '#e0e0e0';
    const strongLineColor = isDark ? '#666666' : '#999999';
    const textColor = isDark ? '#ffffff' : '#000000';
    const mutedTextColor = isDark ? '#888888' : '#666666';

    // 1. Draw Outer Concentric Rings
    ctx.strokeStyle = strongLineColor;
    ctx.lineWidth = 1.5;

    ctx.beginPath();
    ctx.arc(center, center, outerRadius, 0, Math.PI * 2);
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(center, center, innerRadius, 0, Math.PI * 2);
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(center, center, houseRadius, 0, Math.PI * 2);
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(center, center, aspectRadius, 0, Math.PI * 2);
    ctx.stroke();

    // 2. Draw 12 Zodiac Segments (30 deg each)
    const ascSignIndex = ZODIAC_SIGNS.indexOf(chart.risingSign);
    const rotationOffset = -ascSignIndex * (Math.PI / 6); // Ascendant on left (9 o'clock)

    for (let i = 0; i < 12; i++) {
      const signAngle = rotationOffset + i * (Math.PI / 6);
      
      // Divider line
      ctx.strokeStyle = lineColor;
      ctx.lineWidth = 1;
      ctx.beginPath();
      ctx.moveTo(center + Math.cos(signAngle) * innerRadius, center + Math.sin(signAngle) * innerRadius);
      ctx.lineTo(center + Math.cos(signAngle) * outerRadius, center + Math.sin(signAngle) * outerRadius);
      ctx.stroke();

      // House Spokes
      ctx.beginPath();
      ctx.moveTo(center + Math.cos(signAngle) * aspectRadius, center + Math.sin(signAngle) * aspectRadius);
      ctx.lineTo(center + Math.cos(signAngle) * innerRadius, center + Math.sin(signAngle) * innerRadius);
      ctx.stroke();

      // Zodiac Glyph text
      const signIndex = i;
      const signName = ZODIAC_SIGNS[signIndex];
      const glyph = ZODIAC_SYMBOLS[signName as ZodiacSign];
      const midAngle = signAngle + (Math.PI / 12);
      const glyphR = (outerRadius + innerRadius) / 2;

      ctx.fillStyle = textColor;
      ctx.font = '16px serif';
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';
      ctx.fillText(glyph, center + Math.cos(midAngle) * glyphR, center + Math.sin(midAngle) * glyphR);

      // House Number
      const houseR = (innerRadius + houseRadius) / 2;
      ctx.fillStyle = mutedTextColor;
      ctx.font = '10px sans-serif';
      ctx.fillText(`${i + 1}`, center + Math.cos(midAngle) * houseR, center + Math.sin(midAngle) * houseR);
    }

    // 3. Draw Aspect Lines connecting planets
    chart.aspects.forEach((asp) => {
      const p1 = chart.planets.find((p) => p.name === asp.planet1);
      const p2 = chart.planets.find((p) => p.name === asp.planet2);
      if (!p1 || !p2) return;

      const p1Angle = rotationOffset + (ZODIAC_SIGNS.indexOf(p1.sign) + p1.degree / 30) * (Math.PI / 6);
      const p2Angle = rotationOffset + (ZODIAC_SIGNS.indexOf(p2.sign) + p2.degree / 30) * (Math.PI / 6);

      const x1 = center + Math.cos(p1Angle) * aspectRadius;
      const y1 = center + Math.sin(p1Angle) * aspectRadius;
      const x2 = center + Math.cos(p2Angle) * aspectRadius;
      const y2 = center + Math.sin(p2Angle) * aspectRadius;

      ctx.beginPath();
      ctx.moveTo(x1, y1);
      ctx.lineTo(x2, y2);

      if (asp.type === 'Trine' || asp.type === 'Sextile') {
        ctx.strokeStyle = '#ffffff';
        ctx.setLineDash([2, 2]);
      } else {
        ctx.strokeStyle = '#666666';
        ctx.setLineDash([]);
      }
      ctx.lineWidth = 1;
      ctx.stroke();
      ctx.setLineDash([]);
    });

    // 4. Draw Planetary Nodes
    chart.planets.forEach((planet) => {
      const signIdx = ZODIAC_SIGNS.indexOf(planet.sign);
      const angle = rotationOffset + (signIdx + planet.degree / 30) * (Math.PI / 6);

      const pr = houseRadius;
      const px = center + Math.cos(angle) * pr;
      const py = center + Math.sin(angle) * pr;

      const isHovered = hoveredPlanet?.name === planet.name;

      // Draw planet node circle
      ctx.beginPath();
      ctx.arc(px, py, isHovered ? 14 : 10, 0, Math.PI * 2);
      ctx.fillStyle = isHovered ? '#ffffff' : '#121212';
      ctx.fill();
      ctx.strokeStyle = '#ffffff';
      ctx.lineWidth = isHovered ? 2 : 1;
      ctx.stroke();

      // Planet Symbol Glyph
      ctx.fillStyle = isHovered ? '#000000' : '#ffffff';
      ctx.font = '12px serif';
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';
      ctx.fillText(planet.symbol, px, py);
    });

    // 5. Center Horizon Line (Ascendant to Descendant)
    ctx.strokeStyle = '#ffffff';
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.moveTo(center - houseRadius, center);
    ctx.lineTo(center + houseRadius, center);
    ctx.stroke();

    // ASC label on the left
    ctx.fillStyle = '#ffffff';
    ctx.font = '9px sans-serif';
    ctx.fillText('ASC', center - outerRadius - 12, center);

  }, [chart, size, hoveredPlanet]);

  const handleMouseMove = (e: React.MouseEvent<HTMLCanvasElement>) => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const rect = canvas.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;

    const center = size / 2;
    const houseRadius = size * 0.23;

    const ascSignIndex = ZODIAC_SIGNS.indexOf(chart.risingSign);
    const rotationOffset = -ascSignIndex * (Math.PI / 6);

    let found: PlanetPosition | null = null;

    for (const planet of chart.planets) {
      const signIdx = ZODIAC_SIGNS.indexOf(planet.sign);
      const angle = rotationOffset + (signIdx + planet.degree / 30) * (Math.PI / 6);
      const px = center + Math.cos(angle) * houseRadius;
      const py = center + Math.sin(angle) * houseRadius;

      const dist = Math.hypot(x - px, y - py);
      if (dist <= 15) {
        found = planet;
        break;
      }
    }

    setHoveredPlanet(found);
  };

  const handleClick = () => {
    if (hoveredPlanet && onPlanetSelect) {
      onPlanetSelect(hoveredPlanet);
    }
  };

  return (
    <div className="relative inline-block text-center">
      <canvas
        ref={canvasRef}
        style={{ width: size, height: size }}
        onMouseMove={handleMouseMove}
        onMouseLeave={() => setHoveredPlanet(null)}
        onClick={handleClick}
        className="cursor-pointer mx-auto"
      />
      {hoveredPlanet && (
        <div className="absolute top-2 left-1/2 -translate-x-1/2 bg-black border border-neutral-700 px-3 py-1.5 text-xs font-mono shadow-xl rounded pointer-events-none z-10">
          <span className="font-bold text-white">{hoveredPlanet.name}</span> in{' '}
          <span className="text-white">{hoveredPlanet.sign}</span> ({hoveredPlanet.degree}°) • House {hoveredPlanet.house}
        </div>
      )}
    </div>
  );
};
