import { useEffect, useRef, useState } from 'react';
import { createPortal } from 'react-dom';
import { Paint } from './theme.jsx';

// Every PNG/JPG/WEBP dropped into src/assets/figma/<project>/ is picked up at build time.
const FILES = import.meta.glob('./assets/figma/*/*.{png,jpg,jpeg,webp,PNG,JPG,JPEG,WEBP}', {
  eager: true,
  query: '?url',
  import: 'default',
});
const framesFor = (folder) =>
  Object.keys(FILES)
    .filter((k) => k.startsWith(`./assets/figma/${folder}/`))
    .sort()
    .map((k) => FILES[k]);

const rrect = (ctx, x, y, w, h, r) => {
  ctx.beginPath();
  ctx.roundRect(x, y, w, h, r);
  ctx.fill();
};

/** Abstract court lines — decorative, not a preview of the file. */
export function courtPaint(ctx, w, h) {
  ctx.fillStyle = '#1F7A4D';
  ctx.fillRect(0, 0, w, h);
  ctx.strokeStyle = 'rgba(255,255,255,.85)';
  ctx.lineWidth = 3;
  const l = w * 0.08, tp = h * 0.1, rw = w * 0.84, rh = h * 0.8;
  const cx = l + rw / 2, cy = tp + rh / 2;
  ctx.strokeRect(l, tp, rw, rh);
  ctx.beginPath();
  ctx.moveTo(cx, tp);
  ctx.lineTo(cx, tp + rh);
  ctx.stroke();
  ctx.beginPath();
  ctx.arc(cx, cy, h * 0.14, 0, Math.PI * 2);
  ctx.stroke();
  ctx.strokeRect(l, cy - h * 0.2, w * 0.14, h * 0.4);
  ctx.strokeRect(l + rw - w * 0.14, cy - h * 0.2, w * 0.14, h * 0.4);
  ctx.fillStyle = '#FFD83D';
  ctx.beginPath();
  ctx.arc(cx, cy, 7, 0, Math.PI * 2);
  ctx.fill();
}

/** Abstract streaming-UI motif — decorative, not a preview of the file. */
export function rangaPaint(ctx, w, h) {
  const bg = ctx.createLinearGradient(0, 0, w, h);
  bg.addColorStop(0, '#3B1D5A');
  bg.addColorStop(1, '#B8432F');
  ctx.fillStyle = bg;
  ctx.fillRect(0, 0, w, h);
  const gx = w * 0.5, gy = h * 0.42, gr = h * 0.3;
  const glow = ctx.createRadialGradient(gx, gy, 0, gx, gy, gr);
  glow.addColorStop(0, 'rgba(255,179,107,.9)');
  glow.addColorStop(1, 'rgba(255,179,107,0)');
  ctx.fillStyle = glow;
  ctx.beginPath();
  ctx.arc(gx, gy, gr, 0, Math.PI * 2);
  ctx.fill();
  // play button
  ctx.fillStyle = 'rgba(255,255,255,.95)';
  ctx.beginPath();
  ctx.arc(gx, gy, 38, 0, Math.PI * 2);
  ctx.fill();
  ctx.fillStyle = '#3B1D5A';
  ctx.beginPath();
  ctx.moveTo(gx - 10, gy - 16);
  ctx.lineTo(gx + 18, gy);
  ctx.lineTo(gx - 10, gy + 16);
  ctx.closePath();
  ctx.fill();
  // content rail
  for (let i = 0; i < 5; i++) {
    ctx.fillStyle = `rgba(255,255,255,${0.14 + i * 0.03})`;
    rrect(ctx, w * 0.06 + i * w * 0.19, h * 0.72, w * 0.16, h * 0.2, 10);
  }
}

/** Abstract CRM-dashboard motif — decorative, not a preview of the file. */
export function meridianPaint(ctx, w, h) {
  const bg = ctx.createLinearGradient(0, 0, w, h);
  bg.addColorStop(0, '#0B2A4A');
  bg.addColorStop(1, '#1B5FA8');
  ctx.fillStyle = bg;
  ctx.fillRect(0, 0, w, h);
  const card = 'rgba(255,255,255,.1)';
  const pad = w * 0.07;
  // sidebar
  ctx.fillStyle = card;
  rrect(ctx, pad, pad, w * 0.16, h - pad * 2, 14);
  // KPI cards
  const kx = pad + w * 0.2;
  const kw = (w - kx - pad - 24) / 3;
  for (let i = 0; i < 3; i++) rrect(ctx, kx + i * (kw + 12), pad, kw, h * 0.2, 12);
  // pipeline bars
  const by = pad + h * 0.26;
  const bh = h - by - pad;
  const bw = (w - kx - pad) / 7;
  const hs = [0.45, 0.7, 0.55, 0.9, 0.65, 0.8, 0.5];
  hs.forEach((v, i) => {
    ctx.fillStyle = i === 3 ? 'rgba(249,148,59,.95)' : 'rgba(255,255,255,.22)';
    rrect(ctx, kx + i * bw + 4, by + bh * (1 - v), bw - 8, bh * v, 8);
  });
}

/**
 * Shows every image in the project's figma folder as a draggable rail of
 * real design frames; falls back to the decorative painter until images exist.
 */
export function FigmaArt({ folder, fallback, height = 380 }) {
  const files = framesFor(folder);
  const [zoom, setZoom] = useState(null);
  const rail = useRef(null);
  const drag = useRef(null);

  if (files.length === 0) {
    return (
      <div style={{ width: '100%', aspectRatio: '1.5', borderRadius: 28, overflow: 'hidden' }}>
        <Paint paint={fallback} />
      </div>
    );
  }

  const down = (e) => {
    drag.current = { x: e.clientX, left: rail.current.scrollLeft, moved: false };
    rail.current.setPointerCapture(e.pointerId);
  };
  const move = (e) => {
    const d = drag.current;
    if (!d) return;
    const dx = e.clientX - d.x;
    if (Math.abs(dx) > 4) d.moved = true;
    rail.current.scrollLeft = d.left - dx;
  };
  const up = () => {
    setTimeout(() => { drag.current = null; }, 0);
  };

  return (
    <>
      <div
        ref={rail}
        className="rail"
        style={{ height }}
        onPointerDown={down}
        onPointerMove={move}
        onPointerUp={up}
        onPointerCancel={up}
      >
        {files.map((src) => (
          <img
            key={src}
            src={src}
            alt=""
            draggable={false}
            style={{ height, width: 'auto', borderRadius: 20, cursor: 'pointer', flexShrink: 0 }}
            onClick={() => { if (!drag.current?.moved) setZoom(src); }}
          />
        ))}
      </div>
      {zoom && <ImageDialog src={zoom} onClose={() => setZoom(null)} />}
    </>
  );
}

/** Dialog with a pan/zoom image (Flutter InteractiveViewer: 0.8x–2.5x). */
function ImageDialog({ src, onClose }) {
  const [s, setS] = useState(1);
  const [p, setP] = useState({ x: 0, y: 0 });
  const pan = useRef(null);
  useEffect(() => {
    const key = (e) => { if (e.key === 'Escape') onClose(); };
    window.addEventListener('keydown', key);
    return () => window.removeEventListener('keydown', key);
  }, [onClose]);
  return createPortal(
    <div className="dialog" onClick={onClose}>
      <img
        src={src}
        alt=""
        draggable={false}
        onClick={(e) => e.stopPropagation()}
        onWheel={(e) => setS((v) => Math.min(2.5, Math.max(0.8, v * (e.deltaY < 0 ? 1.1 : 0.9))))}
        onPointerDown={(e) => { pan.current = { x: e.clientX - p.x, y: e.clientY - p.y }; e.currentTarget.setPointerCapture(e.pointerId); }}
        onPointerMove={(e) => { if (pan.current) setP({ x: e.clientX - pan.current.x, y: e.clientY - pan.current.y }); }}
        onPointerUp={() => { pan.current = null; }}
        style={{
          maxWidth: 'calc(100vw - 48px)', maxHeight: 'calc(100vh - 48px)', borderRadius: 16, objectFit: 'contain',
          transform: `translate(${p.x}px, ${p.y}px) scale(${s})`, cursor: 'grab', touchAction: 'none',
        }}
      />
    </div>,
    document.body,
  );
}
