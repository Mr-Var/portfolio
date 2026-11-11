import { forwardRef, useEffect, useRef, useState } from 'react';
import { C, Icon, a, disp, easeInOutCubic, ui, useDiag, useViewport } from './theme.jsx';
import { BrowserFrame, PhoneFrame } from './frames.jsx';
import {
  M, MedNuBooking, MedNuFindDoctor, MedNuHealth, MedNuHome, MedNuPharmacy, MedNuRolePicker, RealMobileSite,
} from './mednu.jsx';
import { FigmaArt, courtPaint, meridianPaint, rangaPaint } from './figma.jsx';
import { reducedMotion, spotlight, useActiveSection, useRevealAll, useScrollProgress, useToast } from './fx.jsx';
import desktopFull from './assets/real/desktop_full.jpg';
import skyfitDesktop from './assets/real/skyfit_desktop.jpg';

// Edit these to personalise the page.
const NAME = 'VAR';
const EMAIL = 'vinayanandharaju215@gmail.com';
const PHONE = '+91 77992 30357';
const RESUME = 'https://drive.google.com/file/d/10mvAQFTDiIcQfnxl9eJ_drvLkOBCyHpp/view?usp=sharing';
const MEDNU_PLAY = 'https://play.google.com/store/apps/details?id=com.mednu.mednu';
const RANGA_FIGMA =
  'https://www.figma.com/design/ENoE68ZPXz8mwXheSg5HGD/Ranga-%E2%80%93-Streaming-App-Case-Study?node-id=1-1179';
const COURTSIDE_FIGMA =
  'https://www.figma.com/design/7Vt2iXAaRDNvs4drGZenA0/Courtside-%E2%80%93-Sports-Venue-Booking-App?node-id=0-1';
const MERIDIAN_FIGMA = 'https://www.figma.com/design/tdISwGbz7cOHeUgop5YyjJ/meridian-crm-case-study?node-id=1-490';

// Edit the tags to match exactly what you offer.
const SKILLS = [
  ['App development', 'Production mobile and web apps, from architecture to store release.', 'phone_iphone', '#C494CD',
    ['Flutter', 'Dart', 'Riverpod', 'Firebase', 'REST APIs', 'Payments', 'Maps', 'Push']],
  ['Salesforce', 'Custom apps and automation on the Salesforce platform.', 'cloud', '#3AA0F0',
    ['Apex', 'SOQL', 'Lightning Web Components', 'Flows', 'Triggers', 'Integrations']],
  ['UI/UX design', 'Interfaces that look premium and stay usable on every screen size.', 'draw', '#F9943B',
    ['Figma', 'Prototyping', 'Design systems', 'Responsive UI', 'Accessibility']],
];

const REAL_SITE_H = 6596;
const SKYFIT_SITE_H = 1196;
const ROTATE_MS = 7000;

// ── Smooth scroll (700ms easeInOutCubic; instant under reduced motion) ──
let scrollAnim = 0;
function scrollToEl(el, offset = 0) {
  if (!el) return;
  cancelAnimationFrame(scrollAnim);
  const vh = window.innerHeight;
  const top = el.getBoundingClientRect().top + window.scrollY - offset;
  const max = document.documentElement.scrollHeight - vh;
  const to = Math.min(max, Math.max(0, top));
  if (reducedMotion()) {
    window.scrollTo(0, to);
    return;
  }
  const from = window.scrollY;
  const t0 = performance.now();
  const step = (now) => {
    const p = Math.min(1, (now - t0) / 700);
    window.scrollTo(0, from + (to - from) * easeInOutCubic(p));
    if (p < 1) scrollAnim = requestAnimationFrame(step);
  };
  scrollAnim = requestAnimationFrame(step);
}

// ─────────────────────────────────────────────────────────────
export default function App() {
  const w = useViewport();
  const narrow = w < 820;
  const gutter = narrow ? 20 : w < 1200 ? 44 : 72;
  const skills = useRef(null);
  const work = useRef(null);
  const web = useRef(null);
  const figma = useRef(null);
  const process = useRef(null);
  const contact = useRef(null);
  const active = useActiveSection([skills, work, web, figma, process, contact]);
  const [toast, showToast] = useToast();
  useRevealAll();

  const go = (r) => () => {
    scrollToEl(r.current, -1);
    r.current?.querySelector('h2')?.focus({ preventScroll: true });
  };
  const top = narrow ? 72 : 130;

  return (
    <div style={{ background: C.bg, minHeight: '100vh' }}>
      <a className="skip" href="#main">Skip to content</a>
      <Nav
        narrow={narrow}
        gutter={gutter}
        active={active}
        links={[['Skills', go(skills)], ['Work', go(work)], ['Websites', go(web)], ['Figma', go(figma)]]}
        onContact={go(contact)}
      />
      <main id="main">
        <Hero narrow={narrow} gutter={gutter} vw={w} onWork={go(work)} onContact={go(contact)} />
        <Frame ref={skills} g={gutter} top={narrow ? 72 : 120} id="skills">
          <SkillsBlock narrow={narrow} vw={w} />
        </Frame>
        <Frame ref={work} g={gutter} top={top} id="work">
          <MedNuWork narrow={narrow} />
        </Frame>
        <Frame ref={web} g={gutter} top={top} id="websites">
          <Websites narrow={narrow} gutter={gutter} vw={w} />
        </Frame>
        <Frame ref={figma} g={gutter} top={top} id="figma">
          <FigmaCards narrow={narrow} vw={w} />
        </Frame>
        <Frame ref={process} g={gutter} top={top} id="process">
          <Process narrow={narrow} vw={w} />
        </Frame>
        <Frame ref={contact} g={gutter} top={top} bottom={narrow ? 40 : 64} id="contact">
          <Contact narrow={narrow} onCopied={() => showToast('Email copied to clipboard')} />
        </Frame>
      </main>
      <Footer gutter={gutter} />
      {toast}
    </div>
  );
}

/** Centres content at a max width with page gutters. */
const Frame = forwardRef(function Frame({ g, top = 0, bottom = 0, children, id }, ref) {
  return (
    <section ref={ref} id={id} style={{ paddingTop: top, paddingBottom: bottom, scrollMarginTop: 0 }}>
      <div style={{ maxWidth: 1444, margin: '0 auto', padding: `0 ${g}px` }}>{children}</div>
    </section>
  );
});

// ── Nav ──────────────────────────────────────────────────────
function Nav({ narrow, gutter, links, onContact, active }) {
  const progress = useScrollProgress();
  const [open, setOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  useEffect(() => {
    const on = () => setScrolled(window.scrollY > 8);
    on();
    window.addEventListener('scroll', on, { passive: true });
    return () => window.removeEventListener('scroll', on);
  }, []);
  useEffect(() => {
    if (!narrow) setOpen(false);
  }, [narrow]);
  useEffect(() => {
    if (!open) return undefined;
    const key = (e) => { if (e.key === 'Escape') setOpen(false); };
    window.addEventListener('keydown', key);
    return () => window.removeEventListener('keydown', key);
  }, [open]);

  const pick = (fn) => () => { setOpen(false); fn(); };

  return (
    <>
    <nav className={`nav ${scrolled ? 'scrolled' : ''}`} style={{ padding: `0 ${gutter}px` }} aria-label="Primary">
      <div className="nav-in">
        <a href="#main" className="logo" onClick={(e) => { e.preventDefault(); scrollToEl(document.body); }} aria-label="Back to top">
          <span style={disp(28)}>{NAME}</span>
          <span className="nav-dot" />
        </a>
        <span style={{ flex: 1 }} />
        {!narrow && (
          <div className="nav-links">
            {links.map(([label, onTap], i) => (
              <button
                key={label}
                className={`nav-link ${active === i ? 'on' : ''}`}
                style={{ ...ui(14, { w: 500 }), color: undefined }}
                onClick={onTap}
                aria-current={active === i ? 'true' : undefined}
              >
                {label}
              </button>
            ))}
          </div>
        )}
        <span style={{ width: 14, flexShrink: 0 }} />
        <Btn label="Get in touch" onClick={onContact} small />
        {narrow && (
          <button
            className="menu-btn"
            onClick={() => setOpen((o) => !o)}
            aria-expanded={open}
            aria-controls="mobile-menu"
            aria-label={open ? 'Close menu' : 'Open menu'}
          >
            <Icon n={open ? 'close' : 'menu'} s={22} c={C.tx} />
          </button>
        )}
      </div>
      <div className="nav-progress" style={{ transform: `scaleX(${progress})` }} aria-hidden="true" />
    </nav>
    {/* Sheet lives outside <nav>: the nav's backdrop-filter would trap position:fixed. */}
      {narrow && (
        <div id="mobile-menu" className={`sheet ${open ? 'open' : ''}`} hidden={!open}>
          {links.map(([label, onTap], i) => (
            <button key={label} className={`sheet-link ${active === i ? 'on' : ''}`} onClick={pick(onTap)}>
              <span style={ui(12, { c: C.coral, w: 600 })}>{String(i + 1).padStart(2, '0')}</span>
              <span style={disp(36)}>{label}</span>
              <Icon n="arrow_forward" s={20} c={C.mute} />
            </button>
          ))}
        </div>
      )}
    </>
  );
}

function Btn({ label, onClick, href, outline = false, small = false, icon, iconOutlined = false, ariaLabel }) {
  const fg = outline ? C.tx : C.bg;
  const external = href && /^https?:/.test(href);
  const Tag = href ? 'a' : 'button';
  return (
    <Tag
      className={`btn ${outline ? 'btn-o' : 'btn-f'} ${small ? 'btn-s' : ''}`}
      href={href}
      onClick={onClick}
      target={external ? '_blank' : undefined}
      rel={external ? 'noopener noreferrer' : undefined}
      aria-label={ariaLabel ?? (external ? `${label} (opens in a new tab)` : undefined)}
    >
      <span className="btn-l" style={ui(small ? 13.5 : 15, { c: fg, w: 600, h: 1.2 })}>{label}</span>
      {icon && (
        <>
          <span style={{ width: 8, flexShrink: 0 }} />
          <Icon n={icon} s={18} c={fg} o={iconOutlined} style={{ transition: 'transform 200ms ease' }} />
        </>
      )}
    </Tag>
  );
}

// ── Hero ─────────────────────────────────────────────────────
const HERO_WORDS = ['I', 'design,', 'build', 'and', 'ship'];

function Hero({ narrow, gutter, vw, onWork, onContact }) {
  const ref = useRef(null);
  // Pointer-following light on desktop only.
  const move = (e) => {
    if (narrow || !ref.current) return;
    const r = ref.current.getBoundingClientRect();
    ref.current.style.setProperty('--hx', `${e.clientX - r.left}px`);
    ref.current.style.setProperty('--hy', `${e.clientY - r.top}px`);
  };
  const tags = SKILLS.flatMap((s) => s[4]);

  return (
    <header ref={ref} className="hero" onPointerMove={move}>
      <div className="hero-bg" aria-hidden="true">
      <div className="hero-grid" aria-hidden="true" />
      <div className="hero-light" aria-hidden="true" />
      <div
        className="glow drift-a"
        aria-hidden="true"
        style={{
          top: -220, left: vw * 0.5 - 380, width: 760, height: 760,
          background: `radial-gradient(circle closest-side, ${a(M.plum2, 0.55)}, ${a(M.plum, 0)})`,
        }}
      />
      <div
        className="glow drift-b"
        aria-hidden="true"
        style={{
          top: 360, right: -200, width: 620, height: 620,
          background: `radial-gradient(circle closest-side, ${a(C.coral, 0.16)}, ${a(C.coral, 0)})`,
        }}
      />
      </div>
      <Frame g={gutter} top={narrow ? 120 : 168} bottom={narrow ? 48 : 72}>
        <div style={{ position: 'relative', display: 'flex', flexDirection: 'column', alignItems: 'center', textAlign: 'center' }}>
          <div className="pill intro" style={{ '--d': '0ms' }}>
            <span className="pulse" aria-hidden="true" />
            <span style={{ ...ui(narrow ? 10.5 : 12, { c: C.orchid, w: 600, ls: narrow ? 1.1 : 1.8 }), whiteSpace: 'nowrap' }}>
              UI/UX&nbsp;&nbsp;·&nbsp;&nbsp;APP DEVELOPMENT&nbsp;&nbsp;·&nbsp;&nbsp;SALESFORCE
            </span>
          </div>
          <div style={{ height: narrow ? 24 : 32 }} />
          <h1 style={{ ...disp(narrow ? 44 : 104), margin: 0, textWrap: 'balance' }}>
            {HERO_WORDS.map((wd, i) => (
              <span key={wd} className="word intro" style={{ '--d': `${80 + i * 60}ms` }}>
                {wd}
                {i < HERO_WORDS.length - 1 ? ' ' : ''}
              </span>
            ))}
            <br />
            <span className="grad-text intro shimmer" style={{ ...disp(narrow ? 44 : 104, '#fff'), '--d': '420ms' }}>
              digital products.
            </span>
          </h1>
          <div style={{ height: narrow ? 20 : 30 }} />
          <p className="intro" style={{ ...ui(narrow ? 15.5 : 18.5, { c: C.mute, h: 1.6 }), maxWidth: 640, margin: 0, '--d': '520ms' }}>
            UI/UX designer, Flutter app developer and Salesforce developer — taking ideas from first sketch to live product.
          </p>
          <div style={{ height: narrow ? 28 : 38 }} />
          <div className="wrap intro" style={{ gap: 14, justifyContent: 'center', '--d': '620ms' }}>
            <Btn label="View my work" onClick={onWork} icon="arrow_downward" />
            <Btn label="Get in touch" onClick={onContact} outline />
            <Btn label="Resume" href={RESUME} outline icon="description" iconOutlined />
          </div>
        </div>
      </Frame>
      <div className="marquee intro" style={{ '--d': '760ms' }} aria-label="Tools and skills">
        <div className="marquee-track">
          {[0, 1].map((k) => (
            <div className="marquee-set" key={k} aria-hidden={k === 1 ? 'true' : undefined}>
              {tags.map((tg) => (
                <span key={tg} className="marquee-item" style={ui(narrow ? 13 : 14.5, { c: C.mute, w: 500 })}>
                  <span className="marquee-dot" />
                  {tg}
                </span>
              ))}
            </div>
          ))}
        </div>
      </div>
    </header>
  );
}

// ── Section header ───────────────────────────────────────────
function Head({ eyebrow, title, sub, narrow }) {
  return (
    <div data-reveal="">
      <div>
        <div className="eyebrow" style={ui(12, { c: C.orchid, w: 600, ls: 2.2 })}>
          <span className="eyebrow-line" aria-hidden="true" />
          {eyebrow.toUpperCase()}
        </div>
        <div style={{ height: 16 }} />
        <h2 tabIndex={-1} style={{ ...disp(narrow ? 40 : 72, C.tx, 1.02), margin: 0, whiteSpace: 'pre-line', outline: 'none' }}>
          {title}
        </h2>
        {sub && (
          <>
            <div style={{ height: 16 }} />
            <p style={{ ...ui(narrow ? 15 : 17, { c: C.mute, h: 1.6 }), maxWidth: 620, margin: 0 }}>{sub}</p>
          </>
        )}
      </div>
      <div style={{ height: narrow ? 32 : 52 }} />
    </div>
  );
}

// ── Skills (bento) ───────────────────────────────────────────
function SkillCard({ s, i, big }) {
  const ref = useDiag();
  const [title, desc, icon, accent, tags] = s;
  return (
    <article
      ref={ref}
      className={`card spot lift ${big ? 'bento-big' : ''}`}
      data-reveal=""
      {...spotlight}
      style={{
        '--d': `${i * 60}ms`, '--accent': accent, padding: big ? 36 : 28, borderRadius: 28,
        background: `linear-gradient(var(--diag, 135deg), ${a(accent, big ? 0.16 : 0.1)} 0%, ${C.s1} 45%, ${C.s1} 100%)`,
      }}
    >
      <span className="card-index" aria-hidden="true" style={{ color: a(accent, 0.12) }}>{`0${i + 1}`}</span>
      <div className="skill-icon" style={{ background: a(accent, 0.14), border: `1px solid ${a(accent, 0.35)}` }}>
        <Icon n={icon} c={accent} s={big ? 28 : 24} />
      </div>
      <div style={{ height: big ? 32 : 24 }} />
      <h3 style={{ ...disp(big ? 52 : 36), margin: 0 }}>{title}</h3>
      <div style={{ height: 10 }} />
      <p style={{ ...ui(big ? 16.5 : 14.5, { c: C.mute, h: 1.55 }), margin: 0, maxWidth: 460 }}>{desc}</p>
      <div style={{ flex: 1, minHeight: 22 }} />
      <ul className="wrap tags" style={{ gap: 8 }}>
        {tags.map((tg) => (
          <li key={tg} className="tag" style={{ ...ui(12.5, { h: 1.2 }), padding: '7px 12px' }}>{tg}</li>
        ))}
      </ul>
    </article>
  );
}

function SkillsBlock({ narrow, vw }) {
  const cols = narrow ? 1 : vw < 1100 ? 2 : 3;
  return (
    <div>
      <Head eyebrow="What I do" title={'Three disciplines,\none pair of hands.'} narrow={narrow} />
      <div className={`bento cols-${cols}`}>
        {SKILLS.map((s, i) => <SkillCard key={s[0]} s={s} i={i} big={i === 0 && cols > 1} />)}
      </div>
    </div>
  );
}

// ── MedNU case study with interactive viewer ─────────────────
const ITEMS = [
  ['mednu.in on mobile', 'The live, responsive website as it looks on a phone.', RealMobileSite],
  ['Home', 'Services, a live doctors-online count and a ticking countdown to your next consult.', MedNuHome],
  ['Find a doctor', 'Specialty filters, ratings and live availability at a glance.', MedNuFindDoctor],
  ['Book a slot', 'Tap a day and a time — the confirm bar updates instantly.', MedNuBooking],
  ['Pharmacy cart', 'Quantity steppers recalculate totals and savings live.', MedNuPharmacy],
  ['Health dashboard', 'A live ECG trace and heart rate. Tap water to log a glass.', MedNuHealth],
  ['Partner onboarding', 'One app, ten provider roles, one clear choice.', MedNuRolePicker],
];

function MedNuWork({ narrow }) {
  // Layers emulate an animated switcher: outgoing screens fade out under the incoming one.
  const [layers, setLayers] = useState([{ key: 0, idx: 0, out: false, first: true }]);
  const nextKey = useRef(1);
  const [hover, setHover] = useState(false);
  const [focusIn, setFocusIn] = useState(false);
  const [paused, setPaused] = useState(() => reducedMotion());
  const [cycle, setCycle] = useState(0);
  const current = layers.find((l) => !l.out).idx;
  const holding = paused || hover || focusIn;

  const show = (pick) => {
    setCycle((c) => c + 1);
    setLayers((ls) => {
      const cur = ls.find((l) => !l.out);
      const n = typeof pick === 'function' ? pick(cur.idx) : pick;
      if (n === cur.idx) return ls;
      const now = Date.now();
      return [
        ...ls.map((l) => (l.out ? l : { ...l, out: true, outAt: now })),
        { key: nextKey.current++, idx: n, out: false },
      ];
    });
  };

  useEffect(() => {
    if (!layers.some((l) => l.out)) return undefined;
    const id = setTimeout(() => setLayers((ls) => ls.filter((l) => !l.out || Date.now() - l.outAt < 300)), 320);
    return () => clearTimeout(id);
  }, [layers]);

  // Auto-advance; restarts whenever the user picks a screen. Holds while hovered, focused or paused.
  useEffect(() => {
    if (holding) return undefined;
    const id = setTimeout(() => show((i) => (i + 1) % ITEMS.length), ROTATE_MS);
    return () => clearTimeout(id);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [holding, cycle]);

  const onKey = (e) => {
    const k = e.key;
    if (!['ArrowDown', 'ArrowUp', 'ArrowRight', 'ArrowLeft', 'Home', 'End'].includes(k)) return;
    e.preventDefault();
    const n =
      k === 'Home' ? 0 : k === 'End' ? ITEMS.length - 1
        : (current + (k === 'ArrowDown' || k === 'ArrowRight' ? 1 : -1) + ITEMS.length) % ITEMS.length;
    show(n);
    document.getElementById(`mednu-tab-${n}`)?.focus();
  };

  const phoneW = narrow ? 270 : 330;
  const phone = (
    <div
      className="phone-stage"
      role="tabpanel"
      id="mednu-panel"
      aria-labelledby={`mednu-tab-${current}`}
      style={{ display: 'grid', placeItems: 'center', width: '100%' }}
    >
      <div
        style={{
          gridArea: '1 / 1', width: `min(${phoneW * 1.5}px, 100%)`, height: phoneW * 1.5,
          background: `radial-gradient(circle closest-side, ${a(M.plum2, 0.7)}, ${a(M.plum, 0)})`,
        }}
      />
      {layers.map((l) => {
        const Screen = ITEMS[l.idx][2];
        return (
          <div
            key={l.key}
            className={l.first ? '' : l.out ? 'sw-out' : 'sw-in'}
            style={{ gridArea: '1 / 1' }}
            aria-hidden={l.out ? 'true' : undefined}
          >
            <PhoneFrame width={phoneW}>
              <Screen />
            </PhoneFrame>
          </div>
        );
      })}
    </div>
  );

  const tabs = (
    <div>
      <div role="tablist" aria-label="MedNU screens" aria-orientation="vertical" onKeyDown={onKey}>
        {ITEMS.map(([title, desc], k) => {
          const on = k === current;
          return (
            <button
              key={title}
              id={`mednu-tab-${k}`}
              role="tab"
              aria-selected={on}
              aria-controls="mednu-panel"
              tabIndex={on ? 0 : -1}
              className={`tab ${on ? 'on' : ''}`}
              onClick={() => show(k)}
            >
              <span style={{ ...ui(12.5, { c: on ? C.coral : C.mute, w: 600, h: 1.6 }), width: 34, flexShrink: 0 }}>
                {String(k + 1).padStart(2, '0')}
              </span>
              <span style={{ flex: 1, minWidth: 0, textAlign: 'left' }}>
                <span style={{ ...ui(16, { c: on ? C.tx : C.mute, w: 600, h: 1.3 }), display: 'block' }}>{title}</span>
                <span className={`tab-desc ${on ? 'open' : ''}`}>
                  <span style={{ overflow: 'hidden', display: 'block' }}>
                    <span style={{ ...ui(13.5, { c: C.mute, h: 1.55 }), paddingTop: 6, display: 'block' }}>{desc}</span>
                  </span>
                </span>
              </span>
              {on && (
                <span
                  key={`${cycle}-${k}`}
                  className={`tab-timer ${holding ? 'hold' : ''}`}
                  style={{ animationDuration: `${ROTATE_MS}ms` }}
                  aria-hidden="true"
                />
              )}
            </button>
          );
        })}
      </div>
      <button className="autoplay" onClick={() => setPaused((p) => !p)} aria-pressed={paused}>
        <Icon n={paused ? 'play_arrow' : 'pause'} s={18} c={C.tx} />
        <span style={ui(13, { w: 500, c: C.mute })}>{paused ? 'Play tour' : 'Pause tour'}</span>
      </button>
    </div>
  );

  return (
    <div
      onMouseEnter={() => setHover(true)}
      onMouseLeave={() => setHover(false)}
      onFocus={() => setFocusIn(true)}
      onBlur={(e) => { if (!e.currentTarget.contains(e.relatedTarget)) setFocusIn(false); }}
    >
      <Head
        eyebrow="01 — Case study"
        title="MedNU"
        narrow={narrow}
        sub="A family healthcare platform: patients book doctors, order medicines, call an ambulance and track every service, while providers run their work from a separate partner app. Designed and built end to end."
      />
      <ul className="wrap tags" style={{ gap: 10 }} data-reveal="">
        {['Flutter', 'Firebase', 'Patient app', 'Partner app (10 roles)', 'Web portal', 'Admin panel'].map((c) => (
          <li key={c} className="tag" style={{ ...ui(13, { h: 1.2 }), padding: '8px 14px' }}>{c}</li>
        ))}
      </ul>
      <div style={{ height: narrow ? 28 : 40 }} />
      <div className="card showcase" data-reveal="" style={{ padding: narrow ? 18 : 36, borderRadius: 36, background: C.s1 }}>
        {narrow ? (
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
            {phone}
            <div style={{ height: 18 }} />
            <div style={{ alignSelf: 'stretch' }}>{tabs}</div>
          </div>
        ) : (
          <div style={{ display: 'flex', alignItems: 'center' }}>
            <div style={{ flex: '5 1 0', minWidth: 0 }}>{tabs}</div>
            <div style={{ width: 24, flexShrink: 0 }} />
            <div style={{ flex: '5 1 0', minWidth: 0, display: 'flex', justifyContent: 'center' }}>{phone}</div>
          </div>
        )}
      </div>
      <div style={{ height: 20 }} />
      <DesignTokens narrow={narrow} />
      <div style={{ height: 22 }} />
      <div data-reveal="">
        <Btn label="Get the app on Google Play" href={MEDNU_PLAY} outline icon="arrow_outward" />
      </div>
    </div>
  );
}

function DesignTokens({ narrow }) {
  const sw = [
    ['Plum', M.plum, '#522546'],
    ['Orchid', M.orchid, '#C494CD'],
    ['Coral', M.coral, '#F9943B'],
    ['Blush', M.plumSoft, '#EFE1EC'],
    ['Ink', M.ink, '#33172C'],
  ];
  return (
    <div className="card" data-reveal="" style={{ padding: narrow ? 20 : 28, borderRadius: 28, background: C.s1 }}>
      <div className="wrap" style={{ columnGap: 28, rowGap: 22, alignItems: 'center' }}>
        <span style={disp(28)}>Design system</span>
        {sw.map(([name, color, hex]) => (
          <div key={name} className="swatch">
            <span
              className="swatch-chip"
              style={{ background: color, border: '1px solid rgba(255,255,255,.24)' }}
            />
            <span style={{ width: 10 }} />
            <div>
              <div style={ui(13, { w: 600, h: 1.2 })}>{name}</div>
              <div style={ui(11.5, { c: C.mute, h: 1.3 })}>{hex}</div>
            </div>
          </div>
        ))}
        <span style={ui(13, { c: C.mute })}>Poppins · light &amp; dark · semantic status colours</span>
      </div>
    </div>
  );
}

// ── Websites ─────────────────────────────────────────────────
function Websites({ narrow, gutter, vw }) {
  const inner = Math.min(vw, 1444) - gutter * 2;
  const twoCol = !narrow && inner > 900;
  const fw = twoCol ? (inner - 36) / 2 : inner;

  const item = (url, name, title, sub, h, src, i) => (
    <div key={url} style={{ width: fw, '--d': `${i * 80}ms` }} data-reveal="">
      <div className="site-wrap">
        <BrowserFrame url={url} siteHeight={h} src={src} width={fw} />
        <span className="site-hint" aria-hidden="true">
          <Icon n="open_in_full" s={16} c={C.bg} />
          View full page
        </span>
      </div>
      <div style={{ height: 20 + (fw / 1280) * 6 }} />
      <div style={{ display: 'flex', alignItems: 'center' }}>
        <div style={{ flex: 1, minWidth: 0 }}>
          <h3 style={{ ...ui(17, { w: 600 }), margin: 0 }}>{title}</h3>
          <div style={{ height: 4 }} />
          <div style={ui(14, { c: C.mute })}>{sub}</div>
        </div>
        <span style={{ width: 16, flexShrink: 0 }} />
        <Btn label={`Visit ${name}`} href={`https://${url}`} icon="arrow_outward" />
      </div>
    </div>
  );

  return (
    <div>
      <Head
        eyebrow="02 — Websites"
        title="Live websites."
        narrow={narrow}
        sub="Production sites. Each preview scrolls on its own — hover to pause, click for a full-size view, or visit the real thing."
      />
      <div className="wrap" style={{ columnGap: 36, rowGap: 52 }}>
        {item('mednu.in', 'MedNU', 'MedNU — live website', 'The production site, captured in full.', REAL_SITE_H, desktopFull, 0)}
        {item('skyfit-one.vercel.app', 'skyXfit', 'skyXfit — fitness calculator',
          'BMI, body-fat, calorie and macro calculator for a fitness channel.', SKYFIT_SITE_H, skyfitDesktop, 1)}
      </div>
    </div>
  );
}

// ── Figma case studies ───────────────────────────────────────
function FigmaCards({ narrow, vw }) {
  const wide = vw >= 1100;
  const cards = [
    ['03', 'Meridian', 'CRM case study',
      'A CRM product case study — the full design file with screens, flows and the thinking behind them.',
      MERIDIAN_FIGMA, 'meridian', meridianPaint, '#3AA0F0'],
    ['04', 'Courtside', 'Sports venue booking app',
      'The full Figma file — screens, components and flows — for a mobile app that lets players find and book sports venues.',
      COURTSIDE_FIGMA, 'courtside', courtPaint, '#4CD08A'],
    ['05', 'Ranga', 'Streaming app case study',
      'A Figma case study for a streaming app — research, flows and the final screens, all in one file.',
      RANGA_FIGMA, 'ranga', rangaPaint, C.coral],
  ];

  const card = ([idx, title, sub, blurb, url, folder, art, accent], i) => (
    <article
      key={title}
      className="card spot lift figma-card"
      data-reveal=""
      {...spotlight}
      style={{ padding: 18, borderRadius: 32, background: C.s1, minWidth: 0, '--accent': accent, '--d': `${i * 70}ms` }}
    >
      <div className="art-zoom">
        <FigmaArt folder={folder} fallback={art} height={narrow ? 260 : 300} />
      </div>
      <div style={{ padding: '24px 10px 10px', display: 'flex', flexDirection: 'column', flex: 1 }}>
        <div style={ui(11.5, { c: accent, w: 600, ls: 2 })}>{`${idx} — DESIGN FILE`}</div>
        <div style={{ height: 10 }} />
        <h3 style={{ ...disp(narrow ? 40 : 48), margin: 0 }}>{title}</h3>
        <div style={{ height: 4 }} />
        <div style={ui(15, { w: 600 })}>{sub}</div>
        <div style={{ height: 12 }} />
        <p style={{ ...ui(14, { c: C.mute, h: 1.6 }), margin: 0 }}>{blurb}</p>
        <div style={{ flex: 1, minHeight: 22 }} />
        <div>
          <Btn label="Open in Figma" href={url} icon="arrow_outward" />
        </div>
      </div>
    </article>
  );

  return (
    <div>
      <Head eyebrow="Figma" title="Design case studies" narrow={narrow} sub="Full design files you can open and explore." />
      {wide ? (
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, minmax(0, 1fr))', gap: 22 }}>{cards.map(card)}</div>
      ) : (
        <div style={{ display: 'grid', gap: 20 }}>{cards.map(card)}</div>
      )}
    </div>
  );
}

// ── Process ──────────────────────────────────────────────────
function Process({ narrow, vw }) {
  const steps = [
    ['Understand', 'Who uses it, in what moment, and what happens if it goes wrong.', 'lightbulb'],
    ['Systemise', 'Colour, type and spacing become tokens before any screen exists.', 'palette'],
    ['Build', 'I design directly in code — what you review is what ships.', 'code'],
    ['Harden', 'Small phones, tablets, dark mode and long text. No overflow, ever.', 'verified'],
  ];
  const cols = narrow ? 1 : vw < 1100 ? 2 : 4;
  return (
    <div>
      <Head eyebrow="Process" title={'From first sketch\nto shipped.'} narrow={narrow} />
      <ol className={`steps cols-${cols}`}>
        {steps.map(([title, body, icon], i) => (
          <li key={title} className="step" data-reveal="" style={{ '--d': `${i * 90}ms` }}>
            <div className="step-top">
              <span style={disp(44, C.orchid)}>{`0${i + 1}`}</span>
              <span className="step-icon" aria-hidden="true">
                <Icon n={icon} s={20} c={C.orchid} />
              </span>
            </div>
            <div className="step-rule" aria-hidden="true"><span /></div>
            <div style={{ height: 18 }} />
            <h3 style={{ ...ui(19, { w: 600, h: 1.2 }), margin: 0 }}>{title}</h3>
            <div style={{ height: 8 }} />
            <p style={{ ...ui(14.5, { c: C.mute, h: 1.6 }), margin: 0 }}>{body}</p>
          </li>
        ))}
      </ol>
    </div>
  );
}

// ── Contact ──────────────────────────────────────────────────
function Contact({ narrow, onCopied }) {
  const ref = useDiag();
  const copy = async () => {
    try {
      await navigator.clipboard.writeText(EMAIL);
      onCopied();
    } catch {
      window.location.href = `mailto:${EMAIL}`;
    }
  };
  return (
    <div
      ref={ref}
      className="card contact spot"
      data-reveal=""
      {...spotlight}
      style={{
        padding: narrow ? 28 : 72, borderRadius: 40, '--accent': C.orchid,
        background: 'linear-gradient(var(--diag, 135deg), #3A1B33, #15101A, #1F1410)',
      }}
    >
      <div className="contact-orb" aria-hidden="true" />
      <div style={{ position: 'relative' }}>
        <div className="eyebrow" style={ui(12, { c: C.orchid, w: 600, ls: 2.2 })}>
          <span className="eyebrow-line" aria-hidden="true" />
          LET&apos;S WORK TOGETHER
        </div>
        <div style={{ height: 18 }} />
        <h2 tabIndex={-1} style={{ ...disp(narrow ? 44 : 96), margin: 0, whiteSpace: 'pre-line', outline: 'none' }}>
          {'Have a product\nworth building?'}
        </h2>
        <div style={{ height: narrow ? 28 : 44 }} />
        <div className="wrap" style={{ gap: 14, alignItems: 'center' }}>
          <div className="email-group">
            <Btn label={EMAIL} href={`mailto:${EMAIL}`} icon="mail_outline" ariaLabel={`Email ${EMAIL}`} />
            <button className="icon-btn" onClick={copy} aria-label="Copy email address" title="Copy email">
              <Icon n="content_copy" s={18} c={C.tx} o />
            </button>
          </div>
          <Btn label={PHONE} href={`tel:${PHONE.replace(/ /g, '')}`} outline icon="call" iconOutlined ariaLabel={`Call ${PHONE}`} />
          <Btn label="Resume" href={RESUME} outline icon="description" iconOutlined />
        </div>
      </div>
    </div>
  );
}

function Footer({ gutter }) {
  return (
    <footer className="footer" style={{ padding: `0 ${gutter}px` }}>
      <div className="footer-in">
        <span style={ui(13, { c: C.mute })}>{`© ${new Date().getFullYear()} ${NAME}`}</span>
        <button className="to-top" onClick={() => scrollToEl(document.body)}>
          <span style={ui(13, { c: C.mute, w: 500 })}>Back to top</span>
          <Icon n="arrow_upward" s={16} c={C.mute} />
        </button>
      </div>
    </footer>
  );
}
