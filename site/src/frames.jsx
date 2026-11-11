import { useEffect, useRef, useState } from 'react';
import { createPortal } from 'react-dom';
import { Icon, a, bounce, easeInOut } from './theme.jsx';

// ═════════════════════════════════════════════════════════════
// Phone — fixed 390x844 design canvas inside a bezel, scaled to `width`.
// (The Flutter frame adds 10px padding + 1.5px border inside 410x864,
//  so the screen is actually laid out at 387x841.)
// ═════════════════════════════════════════════════════════════
const BEZEL = 10;
export const SCREEN = { w: 390, h: 844 };

export function PhoneFrame({ width = 280, children, dark = false, statusColor }) {
  const outerW = SCREEN.w + BEZEL * 2;
  const outerH = SCREEN.h + BEZEL * 2;
  const scale = width / outerW;
  const glyph = statusColor ?? (dark ? '#FFFFFF' : '#111111');

  return (
    <div className="phone" style={{ width, height: outerH * scale }}>
      <div className="phone-body" style={{ width: outerW, height: outerH, transform: `scale(${scale})` }}>
        <div className="phone-screen">
          <div style={{ position: 'absolute', inset: 0 }}>{children}</div>
          {/* Status bar */}
          <div className="phone-status" style={{ color: glyph }}>
            <span style={{ fontSize: 15, fontWeight: 600, fontFamily: "'Inter', sans-serif" }}>9:41</span>
            <span style={{ flex: 1 }} />
            <Icon n="signal_cellular_alt" s={16} c={glyph} />
            <span style={{ width: 5 }} />
            <Icon n="wifi" s={16} c={glyph} />
            <span style={{ width: 5 }} />
            <Icon n="battery_full" s={19} c={glyph} />
          </div>
          {/* Dynamic island */}
          <div className="phone-island" style={{ left: (SCREEN.w - 100) / 2 }} />
          {/* Home indicator */}
          <div className="phone-home" style={{ left: (SCREEN.w - 128) / 2, background: a(glyph, 0.85) }} />
        </div>
      </div>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════
// Browser — a 1280px-wide site in a desktop window. Scrolls itself
// (pauses on hover); click opens a full-size scrollable viewer.
// ═════════════════════════════════════════════════════════════
export const SITE_W = 1280;
const VIEWPORT_H = 800;
const CHROME_H = 46;

function Chrome({ url, color, dark }) {
  const fg = dark ? 'rgba(255,255,255,.7)' : '#55505C';
  return (
    <div className="chrome" style={{ background: color }}>
      {['#FF5F57', '#FEBC2E', '#28C840'].map((c) => (
        <span key={c} className="chrome-dot" style={{ background: c }} />
      ))}
      <span style={{ width: 22, flexShrink: 0 }} />
      <Icon n="arrow_back" s={18} c={fg} />
      <span style={{ width: 12, flexShrink: 0 }} />
      <Icon n="arrow_forward" s={18} c={dark ? 'rgba(255,255,255,.28)' : a('#55505C', 0.4)} />
      <span style={{ width: 12, flexShrink: 0 }} />
      <Icon n="refresh" s={18} c={fg} />
      <span style={{ width: 18, flexShrink: 0 }} />
      <div className="chrome-url" style={{ background: dark ? 'rgba(255,255,255,.1)' : '#fff' }}>
        <Icon n="lock" s={12} c={fg} />
        <span style={{ width: 6 }} />
        <span style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 13, color: fg, whiteSpace: 'nowrap' }}>{url}</span>
      </div>
      <span style={{ width: 60, flexShrink: 0 }} />
    </div>
  );
}

export function BrowserFrame({ url, siteHeight, src, width, dark = false }) {
  const scale = width / SITE_W;
  const h = (VIEWPORT_H + CHROME_H) * scale;
  const bar = dark ? '#1C1C22' : '#EDEAF0';
  const scrolls = siteHeight > VIEWPORT_H + 40;
  const siteRef = useRef(null);
  const ctl = useRef(null);
  const [open, setOpen] = useState(false);

  useEffect(() => {
    if (!scrolls) return undefined;
    const range = siteHeight - VIEWPORT_H;
    ctl.current = bounce(siteHeight * 8, (v) => {
      if (siteRef.current) siteRef.current.style.transform = `translateY(${-range * easeInOut(v)}px)`;
    });
    return () => ctl.current.stop();
  }, [scrolls, siteHeight]);

  return (
    <>
      <div
        className="browser"
        style={{ width, height: h }}
        onMouseEnter={() => ctl.current?.pause()}
        onMouseLeave={() => ctl.current?.resume()}
        onClick={() => setOpen(true)}
      >
        <div
          className="browser-body"
          style={{ width: SITE_W, height: VIEWPORT_H + CHROME_H, transform: `scale(${scale})` }}
        >
          <Chrome url={url} color={bar} dark={dark} />
          <div style={{ height: VIEWPORT_H, overflow: 'hidden', position: 'relative' }}>
            <div ref={siteRef} style={{ width: SITE_W, height: siteHeight, pointerEvents: 'none' }}>
              <img src={src} alt="" width={SITE_W} height={siteHeight} style={{ width: SITE_W, height: siteHeight }} />
            </div>
          </div>
        </div>
      </div>
      {open && <SiteViewer url={url} height={siteHeight} src={src} onClose={() => setOpen(false)} />}
    </>
  );
}

function SiteViewer({ url, height, src, onClose }) {
  const [shown, setShown] = useState(false);
  const closing = useRef(false);

  const close = () => {
    if (closing.current) return;
    closing.current = true;
    setShown(false);
    setTimeout(onClose, 300);
  };

  useEffect(() => {
    const raf = requestAnimationFrame(() => setShown(true));
    const key = (e) => { if (e.key === 'Escape') close(); };
    window.addEventListener('keydown', key);
    const prev = document.documentElement.style.overflow;
    document.documentElement.style.overflow = 'hidden';
    return () => {
      cancelAnimationFrame(raf);
      window.removeEventListener('keydown', key);
      document.documentElement.style.overflow = prev;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return createPortal(
    <div className="viewer" style={{ opacity: shown ? 1 : 0 }}>
      <div className="viewer-in">
        <div className="viewer-box">
          <Chrome url={url} color="#EDEAF0" dark={false} />
          <div className="viewer-scroll">
            <img src={src} alt={url} style={{ width: '100%', aspectRatio: `${SITE_W} / ${height}` }} />
          </div>
        </div>
      </div>
      <button className="viewer-close" onClick={close} aria-label="Close">
        <Icon n="close" s={24} c="#000" />
      </button>
    </div>,
    document.body,
  );
}

