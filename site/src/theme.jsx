import { useEffect, useLayoutEffect, useRef, useState } from 'react';

// ── Page theme (mirrors the Flutter constants) ───────────────
// Surface/text colours are CSS variables so the light/dark toggle can swap them.
export const C = {
  bg: 'var(--bg)',
  s1: 'var(--s1)',
  s2: 'var(--s2)',
  line: 'var(--line)',
  tx: 'var(--tx)',
  mute: 'var(--mute)',
  orchid: '#C084FC',
  coral: '#FB923C',
};

/** hex (#RRGGBB) + alpha -> rgba() */
export const a = (hex, alpha) => {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n >> 16) & 255},${(n >> 8) & 255},${n & 255},${alpha})`;
};

/** Flutter blurRadius -> CSS box-shadow blur (sigma = r*0.57735+0.5, CSS blur = 2*sigma). */
export const blur = (r) => +(r * 1.1547 + 1).toFixed(1);

/** Display type: Sora, scaled like the Flutter `_disp` helper. */
export const disp = (s, c = C.tx, h = 1.0) => ({
  fontFamily: "'Sora', sans-serif",
  fontSize: s * 0.74,
  color: c,
  fontWeight: 600,
  lineHeight: h < 1.1 ? 1.12 : h,
  letterSpacing: -s * 0.03,
});

/** UI type: Inter, like the Flutter `_ui` helper. */
export const ui = (s, { c = C.tx, w = 400, h = 1.5, ls } = {}) => ({
  fontFamily: "'Inter', sans-serif",
  fontSize: s,
  color: c,
  fontWeight: w,
  lineHeight: h,
  letterSpacing: ls,
});

/** Material icon (rounded by default, outlined with `o`). */
export function Icon({ n, s = 24, c, o = false, style }) {
  return (
    <span className={o ? 'mi mio' : 'mi'} style={{ fontSize: s, color: c, ...style }} aria-hidden="true">
      {n}
    </span>
  );
}

export function useViewport() {
  const [w, setW] = useState(() => document.documentElement.clientWidth || window.innerWidth);
  useEffect(() => {
    const on = () => setW(document.documentElement.clientWidth || window.innerWidth);
    window.addEventListener('resize', on);
    return () => window.removeEventListener('resize', on);
  }, []);
  return w;
}

/**
 * Flutter's LinearGradient(topLeft -> bottomRight) runs corner to corner.
 * CSS `to bottom right` does not on non-square boxes, so compute the angle.
 * Use as: <div ref={useDiag()} style={{ background: `linear-gradient(var(--diag), ...)` }}>
 */
export function useDiag() {
  const ref = useRef(null);
  useLayoutEffect(() => {
    const el = ref.current;
    if (!el) return undefined;
    const set = () => {
      const w = el.offsetWidth;
      const h = el.offsetHeight;
      if (w && h) el.style.setProperty('--diag', `${90 + (Math.atan2(h, w) * 180) / Math.PI}deg`);
    };
    set();
    const ro = new ResizeObserver(set);
    ro.observe(el);
    return () => ro.disconnect();
  }, []);
  return ref;
}

/** Re-renders every `ms` with an incrementing tick (Flutter `Every`). */
export function useTick(ms) {
  const [n, setN] = useState(0);
  useEffect(() => {
    const id = setInterval(() => setN((x) => x + 1), ms);
    return () => clearInterval(id);
  }, [ms]);
  return n;
}

// ── Curves ───────────────────────────────────────────────────
export function bezier(x1, y1, x2, y2) {
  const cx = 3 * x1, bx = 3 * (x2 - x1) - cx, ax = 1 - cx - bx;
  const cy = 3 * y1, by = 3 * (y2 - y1) - cy, ay = 1 - cy - by;
  const sx = (t) => ((ax * t + bx) * t + cx) * t;
  const sy = (t) => ((ay * t + by) * t + cy) * t;
  return (x) => {
    if (x <= 0) return 0;
    if (x >= 1) return 1;
    let lo = 0, hi = 1, t = x;
    for (let i = 0; i < 40; i++) {
      const v = sx(t);
      if (Math.abs(v - x) < 1e-6) break;
      if (v < x) lo = t; else hi = t;
      t = (lo + hi) / 2;
    }
    return sy(t);
  };
}
export const easeInOut = bezier(0.42, 0, 0.58, 1);
export const easeInOutCubic = bezier(0.645, 0.045, 0.355, 1);

/**
 * AnimationController.repeat(reverse: true) equivalent.
 * Calls apply(value 0..1) every frame; pause()/resume() mirror stop()/repeat().
 */
export function bounce(periodMs, apply) {
  if (window.matchMedia?.('(prefers-reduced-motion: reduce)').matches) {
    apply(0);
    return { pause() {}, resume() {}, stop() {} };
  }
  let v = 0, dir = 1, run = true, last = null, raf = 0;
  const loop = (ts) => {
    if (last != null && run) {
      v += (dir * (ts - last)) / periodMs;
      if (v >= 1) { v = Math.max(0, 2 - v); dir = -1; }
      else if (v <= 0) { v = Math.min(1, -v); dir = 1; }
      apply(v);
    }
    last = ts;
    raf = requestAnimationFrame(loop);
  };
  apply(0);
  raf = requestAnimationFrame(loop);
  return {
    pause() { run = false; },
    resume() { run = true; dir = 1; },
    stop() { cancelAnimationFrame(raf); },
  };
}

/** Canvas sized to its box (DPR aware). `paint(ctx, w, h, t)`; `animate` repaints every frame. */
export function Paint({ paint, animate = false, style, className }) {
  const ref = useRef(null);
  useEffect(() => {
    const cv = ref.current;
    const ctx = cv.getContext('2d');
    let w = 0, h = 0, raf = 0;
    const start = performance.now();
    const draw = (now) => {
      ctx.setTransform(1, 0, 0, 1, 0, 0);
      ctx.clearRect(0, 0, cv.width, cv.height);
      const dpr = cv.width / (w || 1);
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      if (w && h) paint(ctx, w, h, (now ?? performance.now()) - start);
    };
    const size = () => {
      w = cv.offsetWidth;
      h = cv.offsetHeight;
      const dpr = Math.max(1, window.devicePixelRatio || 1);
      cv.width = Math.round(w * dpr);
      cv.height = Math.round(h * dpr);
      if (!animate) draw();
    };
    const ro = new ResizeObserver(size);
    ro.observe(cv);
    size();
    if (animate) {
      const loop = (now) => { draw(now); raf = requestAnimationFrame(loop); };
      raf = requestAnimationFrame(loop);
    }
    return () => { ro.disconnect(); cancelAnimationFrame(raf); };
  }, [paint, animate]);
  return <canvas ref={ref} className={className} style={{ display: 'block', width: '100%', height: '100%', ...style }} />;
}
