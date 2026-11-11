import { useEffect, useRef, useState } from 'react';

/** True when the user asked the OS for less motion. */
export const reducedMotion = () =>
  typeof window !== 'undefined' && window.matchMedia?.('(prefers-reduced-motion: reduce)').matches;

/**
 * Scroll reveal: any element with [data-reveal] fades/rises in once it enters the viewport.
 * Optional style `--d` sets a stagger delay. Content is fully visible without JS or with reduced motion.
 */
export function useRevealAll() {
  useEffect(() => {
    const root = document.documentElement;
    if (reducedMotion() || !('IntersectionObserver' in window)) return undefined;
    root.classList.add('fx');
    const io = new IntersectionObserver(
      (entries) => {
        entries.forEach((e) => {
          if (e.isIntersecting) {
            e.target.classList.add('in');
            io.unobserve(e.target);
          }
        });
      },
      { rootMargin: '0px 0px -8% 0px', threshold: 0.08 },
    );
    const scan = () => document.querySelectorAll('[data-reveal]:not(.in)').forEach((el) => io.observe(el));
    scan();
    const mo = new MutationObserver(scan);
    mo.observe(document.body, { childList: true, subtree: true });
    return () => {
      io.disconnect();
      mo.disconnect();
      root.classList.remove('fx');
    };
  }, []);
}

/** Cursor-following spotlight: sets --mx/--my on the element for a radial-gradient glow. */
export const spotlight = {
  onPointerMove(e) {
    const r = e.currentTarget.getBoundingClientRect();
    e.currentTarget.style.setProperty('--mx', `${e.clientX - r.left}px`);
    e.currentTarget.style.setProperty('--my', `${e.clientY - r.top}px`);
  },
};

/** 0..1 page scroll progress. */
export function useScrollProgress() {
  const [p, setP] = useState(0);
  useEffect(() => {
    let raf = 0;
    const on = () => {
      cancelAnimationFrame(raf);
      raf = requestAnimationFrame(() => {
        const max = document.documentElement.scrollHeight - window.innerHeight;
        setP(max > 0 ? Math.min(1, window.scrollY / max) : 0);
      });
    };
    on();
    window.addEventListener('scroll', on, { passive: true });
    window.addEventListener('resize', on);
    return () => {
      window.removeEventListener('scroll', on);
      window.removeEventListener('resize', on);
      cancelAnimationFrame(raf);
    };
  }, []);
  return p;
}

/** Index of the section currently under the nav (scrollspy), or -1 above the first. */
export function useActiveSection(refs) {
  const [active, setActive] = useState(-1);
  useEffect(() => {
    const on = () => {
      const probe = window.innerHeight * 0.35;
      let idx = -1;
      refs.forEach((r, i) => {
        const el = r.current;
        if (el && el.getBoundingClientRect().top <= probe) idx = i;
      });
      setActive(idx);
    };
    on();
    window.addEventListener('scroll', on, { passive: true });
    window.addEventListener('resize', on);
    return () => {
      window.removeEventListener('scroll', on);
      window.removeEventListener('resize', on);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
  return active;
}

/** Tiny polite toast. Returns [node, show(message)]. */
export function useToast() {
  const [msg, setMsg] = useState(null);
  const timer = useRef(0);
  const show = (m) => {
    clearTimeout(timer.current);
    setMsg(m);
    timer.current = setTimeout(() => setMsg(null), 2200);
  };
  useEffect(() => () => clearTimeout(timer.current), []);
  const node = (
    <div className={`toast ${msg ? 'show' : ''}`} role="status" aria-live="polite">
      {msg}
    </div>
  );
  return [node, show];
}
