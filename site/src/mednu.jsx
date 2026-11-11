import { useCallback, useEffect, useRef, useState } from 'react';
import { Icon, Paint, a, blur, bounce, easeInOut, useDiag, useTick } from './theme.jsx';
import heroDoctor from './assets/mednu/home_hero_doctor_cutout.png';
import bookingDoctor from './assets/mednu/doctor_animated_cutout.png';
import logo from './assets/mednu/mednu_logo.png';
import mobileFull from './assets/real/mobile_full.jpg';

/** MedNU brand tokens — mirrored from the production app's AppColors. */
export const M = {
  plum: '#522546',
  plum2: '#633058',
  plumDeep: '#24101F',
  plumSoft: '#EFE1EC',
  orchid: '#C494CD',
  coral: '#F9943B',
  bg: '#F7F4F6',
  ink: '#33172C',
  inkSoft: '#7A6472',
  hint: '#AE96A7',
  border: '#E4D9E1',
  good: '#1E8E5A',
  crit: '#C0392B',
};

/** Poppins text style (Flutter `M.t`). Text never wraps unless it has a newline. */
const t = (size, { w = 400, c = M.ink, h, ls } = {}) => ({
  fontFamily: "'Poppins', sans-serif",
  fontSize: size,
  fontWeight: w,
  color: c,
  lineHeight: h ?? 'normal',
  letterSpacing: ls,
  whiteSpace: 'pre',
});
const ellipsis = { overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', display: 'block' };
const lift = `0 8px ${blur(22)}px ${a(M.plum, 0.09)}`;
const ICON_DARK = 'rgba(0,0,0,.87)';
const TOP = 54;

const row = { display: 'flex', alignItems: 'center' };
const col = { display: 'flex', flexDirection: 'column' };
const box = (s, r, bg, extra) => ({
  width: s, height: s, borderRadius: r, background: bg, flexShrink: 0,
  display: 'flex', alignItems: 'center', justifyContent: 'center', ...extra,
});
const Gap = ({ w, h }) => <span style={{ display: 'block', width: w, height: h, flexShrink: 0 }} />;
const Spacer = () => <span style={{ flex: 1 }} />;

/** Rounded gradient chip with an icon — the service tile glyph. */
export function GlyphTile({ icon, colors, size = 48 }) {
  return (
    <div
      style={box(size, size * 0.32, `linear-gradient(135deg, ${colors[0]}, ${colors[1]})`, {
        boxShadow: `0 6px ${blur(12)}px ${a(colors[1], 0.28)}`,
      })}
    >
      <Icon n={icon} s={size * 0.5} c="#fff" />
    </div>
  );
}

const NAV = [
  ['home', 'Home'],
  ['calendar_month', 'Bookings'],
  ['folder_copy', 'Records'],
  ['person', 'Profile'],
];

export function BottomNav({ index }) {
  return (
    <div
      style={{
        ...row, height: 84, flexShrink: 0, padding: '10px 18px 22px', background: '#fff',
        borderTop: '1px solid #F0E7EE', boxShadow: `0 -6px ${blur(24)}px ${a(M.plum, 0.06)}`, position: 'relative',
      }}
    >
      {NAV.map(([ic, label], i) => (
        <div key={label} style={{ ...col, alignItems: 'center', flex: '1 1 0' }}>
          <div
            style={{
              display: 'flex', padding: '5px 18px', borderRadius: 14,
              background: i === index ? M.plumSoft : 'transparent', transition: 'background-color 200ms linear',
            }}
          >
            <Icon n={ic} s={22} c={i === index ? M.plum : M.hint} />
          </div>
          <Gap h={2} />
          <span style={t(10.5, { w: i === index ? 600 : 500, c: i === index ? M.plum : M.hint })}>{label}</span>
        </div>
      ))}
    </div>
  );
}

const TONES = [
  ['#EFE1EC', '#D9B7D3'],
  ['#FCE7D3', '#F7C497'],
  ['#DCEBF7', '#B4D2EC'],
  ['#DDF0E4', '#B2DBC1'],
];

/** Initial-letter avatar on a soft gradient (stands in for a doctor photo). */
export function Initials({ text, size = 56, tone = 0 }) {
  const c = TONES[tone % TONES.length];
  return (
    <div style={box(size, size * 0.3, `linear-gradient(135deg, ${c[0]}, ${c[1]})`)}>
      <span style={t(size * 0.34, { w: 600, c: M.plum })}>{text}</span>
    </div>
  );
}

const Screen = ({ children, style }) => (
  <div style={{ position: 'absolute', inset: 0, background: M.bg, overflow: 'hidden', ...style }}>{children}</div>
);
/** Non-scrollable content area that fills the space above a bottom bar. */
const Body = ({ children, style }) => (
  <div className="m-body" style={{ flex: 1, minHeight: 0, overflow: 'hidden', ...col, alignItems: 'flex-start', ...style }}>
    {children}
  </div>
);
const Pad = ({ children, x = 20, style }) => (
  <div style={{ padding: `0 ${x}px`, alignSelf: 'stretch', ...style }}>{children}</div>
);
const BackBtn = () => (
  <div style={box(42, 14, '#fff', { boxShadow: lift })}>
    <Icon n="arrow_back" s={21} c={ICON_DARK} />
  </div>
);

// ═════════════════════════════════════════════════════════════
// Real mobile capture of mednu.in that scrolls itself inside a phone.
// ═════════════════════════════════════════════════════════════
export function RealMobileSite() {
  const H = 6752 / 2; // 780x6752 capture shown at 390 logical px wide
  const ref = useRef(null);
  useEffect(() => {
    const c = bounce(70000, (v) => {
      if (ref.current) ref.current.style.transform = `translateY(${-(H - (844 - TOP)) * easeInOut(v)}px)`;
    });
    return () => c.stop();
  }, [H]);
  return (
    <div style={{ position: 'absolute', inset: 0, ...col, background: 'transparent' }}>
      <div style={{ height: TOP, background: '#fff', flexShrink: 0 }} />
      <div style={{ flex: 1, minHeight: 0, overflow: 'hidden' }}>
        <img ref={ref} src={mobileFull} alt="" style={{ width: 390, height: H, maxWidth: 'none' }} />
      </div>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════
// 1 · Patient home
// ═════════════════════════════════════════════════════════════
const SERVICES = [
  ['emergency', 'Emergency', ['#EF5350', '#B71C1C']],
  ['event_available', 'Appointment', ['#42A5F5', '#1565C0']],
  ['medication', 'Medicines', ['#66BB6A', '#2E7D32']],
  ['biotech', 'Lab Tests', ['#5C6BC0', '#3949AB']],
  ['local_hospital', 'Ambulance', ['#EF5350', '#522546']],
  ['self_improvement', 'Physio', ['#42A5F5', '#0D47A1']],
  ['restaurant', 'Nutrition', ['#9CCC65', '#33691E']],
  ['volunteer_activism', 'Care Assist', ['#FFA726', '#E65100']],
];
const two = (n) => String(n).padStart(2, '0');

function DoctorsOnline() {
  const i = useTick(3000);
  return (
    <span style={t(10.5, { c: '#E8D2E4', w: 500 })}>{`${118 + ((i * 7) % 15)} doctors online`}</span>
  );
}
function Countdown() {
  const i = useTick(1000);
  const left = 8047 - i;
  return (
    <span style={t(9.5, { w: 600, c: M.coral, ls: 0.8 })}>
      {`STARTS IN ${two(Math.trunc(left / 3600))}:${two(Math.trunc((left % 3600) / 60))}:${two(left % 60)}`}
    </span>
  );
}

export function MedNuHome() {
  const banner = useDiag();
  return (
    <Screen style={col}>
      <Body>
        <Gap h={TOP + 6} />
        <Pad>
          <div style={row}>
            <div style={box(42, 14, M.plumSoft)}>
              <Icon n="place" s={21} c={M.plum} />
            </div>
            <Gap w={12} />
            <div style={{ ...col, flex: 1, minWidth: 0 }}>
              <span style={t(11, { c: M.inkSoft })}>Delivering care to</span>
              <div style={row}>
                <span style={t(14, { w: 600 })}>Jubilee Hills, Hyderabad</span>
                <Icon n="keyboard_arrow_down" s={18} c={M.plum} />
              </div>
            </div>
            <div style={{ position: 'relative', flexShrink: 0 }}>
              <div style={box(42, 14, '#fff', { boxShadow: lift })}>
                <Icon n="notifications_none" s={22} c={M.ink} />
              </div>
              <div
                style={{
                  position: 'absolute', top: 9, right: 10, width: 9, height: 9, borderRadius: '50%',
                  background: M.coral, border: '1.6px solid #fff',
                }}
              />
            </div>
          </div>
        </Pad>
        <Gap h={18} />
        {/* Hero banner */}
        <Pad>
          <div
            ref={banner}
            style={{
              height: 168, borderRadius: 26, overflow: 'hidden', position: 'relative',
              background: `linear-gradient(var(--diag, 135deg), ${M.plum}, ${M.plum}, ${M.plumDeep})`,
              boxShadow: `0 14px ${blur(28)}px ${a(M.plum, 0.35)}`,
            }}
          >
            <div
              style={{
                position: 'absolute', right: -40, top: -50, width: 180, height: 180, borderRadius: '50%',
                background: a(M.orchid, 0.22),
              }}
            />
            <img src={heroDoctor} alt="" style={{ position: 'absolute', right: -6, bottom: 0, height: 164 }} />
            <div
              style={{
                position: 'absolute', inset: 0, padding: '20px 0 18px 20px', ...col,
                alignItems: 'flex-start', justifyContent: 'space-between',
              }}
            >
              <div style={col}>
                <div style={row}>
                  <span style={{ width: 7, height: 7, borderRadius: '50%', background: '#5BE49B' }} />
                  <Gap w={6} />
                  <DoctorsOnline />
                </div>
                <Gap h={8} />
                <span style={t(21, { w: 600, c: '#fff', h: 1.2 })}>{'Consult top\nspecialists'}</span>
              </div>
              <div style={{ ...row, padding: '9px 16px', borderRadius: 30, background: M.coral }}>
                <span style={t(12, { w: 600, c: M.plumDeep })}>Consult now</span>
                <Gap w={4} />
                <Icon n="arrow_forward" s={15} c={M.plumDeep} />
              </div>
            </div>
          </div>
        </Pad>
        <Gap h={14} />
        {/* Search */}
        <Pad>
          <div
            style={{
              ...row, height: 50, padding: '0 16px', background: '#fff', borderRadius: 16,
              border: `1px solid ${M.border}`,
            }}
          >
            <Icon n="search" s={22} c={M.hint} />
            <Gap w={10} />
            <span style={{ ...t(13, { c: M.hint }), flex: 1 }}>Doctors, medicines, lab tests</span>
            <div style={box(30, 10, M.plumSoft)}>
              <Icon n="mic_none" s={18} c={M.plum} />
            </div>
          </div>
        </Pad>
        <Gap h={22} />
        <Pad>
          <div style={row}>
            <span style={t(16, { w: 600 })}>Our services</span>
            <Spacer />
            <span style={t(12, { w: 500, c: M.plum })}>See all</span>
          </div>
        </Pad>
        <Gap h={14} />
        <Pad>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, minmax(0, 1fr))', rowGap: 14, columnGap: 10 }}>
            {SERVICES.map(([ic, label, colors]) => (
              <div key={label} style={{ ...col, alignItems: 'center', aspectRatio: '0.78', minWidth: 0 }}>
                <GlyphTile icon={ic} colors={colors} size={54} />
                <Gap h={7} />
                <span style={{ ...t(10.5, { w: 500 }), ...ellipsis, maxWidth: '100%' }}>{label}</span>
              </div>
            ))}
          </div>
        </Pad>
        <Gap h={10} />
        <Pad>
          <div style={{ ...row, padding: 14, background: '#fff', borderRadius: 22, boxShadow: lift }}>
            <Initials text="RK" size={50} tone={1} />
            <Gap w={12} />
            <div style={{ ...col, flex: 1, minWidth: 0 }}>
              <Countdown />
              <Gap h={2} />
              <span style={t(14, { w: 600 })}>Dr. Ritika Kapoor</span>
              <span style={{ ...t(11, { c: M.inkSoft }), ...ellipsis }}>Cardiology · Video consult · 5:30 PM</span>
            </div>
            <div style={box(42, 14, M.plum)}>
              <Icon n="videocam" s={21} c="#fff" />
            </div>
          </div>
        </Pad>
      </Body>
      <BottomNav index={0} />
    </Screen>
  );
}

// ═════════════════════════════════════════════════════════════
// 2 · Find a doctor
// ═════════════════════════════════════════════════════════════
const DOCS = [
  ['Dr. Ritika Kapoor', 'Cardiologist', '4.9', '1.2k', '₹700', '12 yrs', 'RK', 0, true],
  ['Dr. Arjun Menon', 'Endocrinologist', '4.8', '860', '₹600', '9 yrs', 'AM', 2, true],
  ['Dr. Sana Qureshi', 'Dermatologist', '4.8', '940', '₹500', '8 yrs', 'SQ', 1, false],
  ['Dr. Vikram Rao', 'General Physician', '4.7', '2.1k', '₹350', '15 yrs', 'VR', 3, true],
];

export function MedNuFindDoctor() {
  const chips = ['All', 'Cardiology', 'Diabetes', 'Skin', "Women's"];
  return (
    <Screen style={col}>
      <Body>
        <Gap h={TOP + 6} />
        <Pad>
          <div style={row}>
            <BackBtn />
            <Gap w={14} />
            <span style={t(19, { w: 600 })}>Find your doctor</span>
          </div>
        </Pad>
        <Gap h={16} />
        <Pad>
          <div
            style={{
              ...row, height: 50, padding: '0 16px', background: '#fff', borderRadius: 16,
              border: `1px solid ${M.border}`,
            }}
          >
            <Icon n="search" c={M.hint} />
            <Gap w={10} />
            <span style={{ ...t(13, { c: M.hint }), flex: 1 }}>Search by name or condition</span>
            <Icon n="tune" s={20} c={M.plum} />
          </div>
        </Pad>
        <Gap h={14} />
        <div style={{ ...row, alignSelf: 'stretch', height: 38, overflow: 'hidden', padding: '0 20px', gap: 8, alignItems: 'stretch' }}>
          {chips.map((c, i) => (
            <div
              key={c}
              style={{
                ...row, flexShrink: 0, padding: '0 16px', borderRadius: 30,
                background: i === 1 ? M.plum : '#fff', border: `1px solid ${i === 1 ? M.plum : M.border}`,
              }}
            >
              <span style={t(12, { w: 500, c: i === 1 ? '#fff' : M.inkSoft })}>{c}</span>
            </div>
          ))}
        </div>
        <Gap h={16} />
        {DOCS.map((d) => (
          <Pad key={d[0]} style={{ paddingBottom: 12 }}>
            <div style={{ padding: 14, background: '#fff', borderRadius: 22, boxShadow: lift }}>
              <div style={row}>
                <Initials text={d[6]} size={62} tone={d[7]} />
                <Gap w={14} />
                <div style={{ ...col, flex: 1, minWidth: 0 }}>
                  <span style={t(14.5, { w: 600 })}>{d[0]}</span>
                  <span style={t(11.5, { c: M.inkSoft })}>{d[1]}</span>
                  <Gap h={6} />
                  <div style={row}>
                    <Icon n="star" s={15} c={M.coral} />
                    <Gap w={3} />
                    <span style={t(11.5, { w: 600 })}>{d[2]}</span>
                    <span style={t(11, { c: M.inkSoft })}>{`  (${d[3]})  ·  ${d[5]}`}</span>
                  </div>
                </div>
              </div>
              <Gap h={12} />
              <div style={row}>
                <div style={{ padding: '4px 9px', borderRadius: 8, background: d[8] ? '#E3F4EA' : M.plumSoft }}>
                  <span style={t(10.5, { w: 600, c: d[8] ? M.good : M.plum })}>
                    {d[8] ? 'Available now' : 'Tomorrow, 10 AM'}
                  </span>
                </div>
                <Spacer />
                <span style={t(15, { w: 600 })}>{d[4]}</span>
                <Gap w={12} />
                <div style={{ padding: '9px 16px', borderRadius: 12, background: M.plum }}>
                  <span style={t(12, { w: 600, c: '#fff' })}>Book</span>
                </div>
              </div>
            </div>
          </Pad>
        ))}
      </Body>
      <BottomNav index={0} />
    </Screen>
  );
}

// ═════════════════════════════════════════════════════════════
// Booking — tap a day and a slot
// ═════════════════════════════════════════════════════════════
const DAYS = [['Mon', '06'], ['Tue', '07'], ['Wed', '08'], ['Thu', '09'], ['Fri', '10']];
const SLOTS = [
  ['10:00', 'AM'], ['10:30', 'AM'], ['11:00', 'AM'], ['11:30', 'AM'],
  ['4:00', 'PM'], ['4:30', 'PM'], ['5:30', 'PM'], ['6:00', 'PM'],
];
const TAKEN = new Set([1, 4]);

const Glass = ({ n, o }) => (
  <div style={box(40, 13, 'rgba(255,255,255,.14)')}>
    <Icon n={n} s={20} c="#fff" o={o} />
  </div>
);

export function MedNuBooking() {
  const [day, setDay] = useState(2);
  const [slot, setSlot] = useState(6);
  const head = useDiag();
  const ease = '180ms linear';
  return (
    <Screen>
      <div style={{ position: 'absolute', inset: 0, ...col }}>
        <div
          ref={head}
          style={{
            height: 262, flexShrink: 0, position: 'relative', borderRadius: '0 0 34px 34px',
            background: `linear-gradient(var(--diag, 135deg), ${M.plum}, ${M.plumDeep})`,
          }}
        >
          <img src={bookingDoctor} alt="" style={{ position: 'absolute', right: 6, bottom: 0, height: 176 }} />
          <div style={{ position: 'relative', padding: `${TOP + 6}px 20px 0`, ...col, alignItems: 'flex-start' }}>
            <div style={{ ...row, alignSelf: 'stretch' }}>
              <Glass n="arrow_back" />
              <Spacer />
              <Glass n="favorite_border" />
            </div>
            <Gap h={22} />
            <span style={t(26, { w: 600, c: '#fff', h: 1.15 })}>{'Dr. Ritika\nKapoor'}</span>
            <Gap h={6} />
            <span style={t(12, { c: '#E0C6DB' })}>Senior Cardiologist · MD, DM</span>
          </div>
        </div>
        {/* Stats card overlaps the header; kept outside the clipped body so it is never cut off. */}
        <Pad style={{ position: 'relative', top: -26, zIndex: 1, flexShrink: 0 }}>
          <div style={{ ...row, padding: '14px 0', background: '#fff', borderRadius: 22, boxShadow: lift }}>
            {[['1.2k', 'Patients'], ['12 yrs', 'Experience'], ['4.9', 'Rating']].map(([v, l]) => (
              <div key={l} style={{ ...col, alignItems: 'center', flex: '1 1 0' }}>
                <span style={t(16, { w: 600, c: M.plum })}>{v}</span>
                <span style={t(10.5, { c: M.inkSoft })}>{l}</span>
              </div>
            ))}
          </div>
        </Pad>
        <Body style={{ alignItems: 'stretch' }}>
          <Pad>
            <div style={row}>
              <span style={t(15, { w: 600 })}>Pick a day</span>
              <Spacer />
              <span style={t(12, { c: M.inkSoft })}>October 2026</span>
            </div>
            <Gap h={12} />
            <div style={{ ...row, gap: 8 }}>
              {DAYS.map(([d, n], i) => (
                <div
                  key={d}
                  onClick={() => setDay(i)}
                  style={{
                    ...col, alignItems: 'center', flex: '1 1 0', padding: '11px 0', borderRadius: 16,
                    background: i === day ? M.plum : '#fff', border: `1px solid ${i === day ? M.plum : M.border}`,
                    transition: `background-color ${ease}, border-color ${ease}`,
                  }}
                >
                  <span style={t(10.5, { c: i === day ? '#E0C6DB' : M.inkSoft })}>{d}</span>
                  <Gap h={3} />
                  <span style={t(16, { w: 600, c: i === day ? '#fff' : M.ink })}>{n}</span>
                </div>
              ))}
            </div>
            <Gap h={20} />
            <span style={t(15, { w: 600 })}>Available slots</span>
            <Gap h={12} />
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, minmax(0, 1fr))', gap: 8 }}>
              {SLOTS.map(([time], i) => {
                const taken = TAKEN.has(i);
                const sel = i === slot;
                return (
                  <div
                    key={time}
                    onClick={taken ? undefined : () => setSlot(i)}
                    style={{
                      aspectRatio: '1.9', display: 'flex', alignItems: 'center', justifyContent: 'center',
                      borderRadius: 12, border: `${sel ? 1.4 : 1}px solid ${sel ? M.plum : M.border}`,
                      background: sel ? M.plumSoft : taken ? '#F1ECF0' : '#fff',
                      transition: `background-color ${ease}, border-color ${ease}`,
                    }}
                  >
                    <span
                      style={{
                        ...t(12, { w: sel ? 600 : 500, c: taken ? M.hint : sel ? M.plum : M.ink }),
                        textDecoration: taken ? 'line-through' : 'none',
                      }}
                    >
                      {time}
                    </span>
                  </div>
                );
              })}
            </div>
          </Pad>
        </Body>
        <Gap h={104} />
      </div>
      <div
        style={{
          position: 'absolute', left: 0, right: 0, bottom: 0, ...row, padding: '14px 20px 30px',
          background: '#fff', boxShadow: `0 -8px ${blur(24)}px ${a(M.plum, 0.1)}`,
        }}
      >
        <div style={col}>
          <span style={t(10.5, { c: M.inkSoft })}>Consultation fee</span>
          <span style={t(20, { w: 600 })}>₹700</span>
        </div>
        <Gap w={20} />
        <div
          style={{
            flex: 1, height: 52, display: 'flex', alignItems: 'center', justifyContent: 'center', borderRadius: 18,
            background: `linear-gradient(90deg, ${M.plum}, ${M.plum2})`,
            boxShadow: `0 8px ${blur(16)}px ${a(M.plum, 0.35)}`,
          }}
        >
          <span style={t(13.5, { w: 600, c: '#fff' })}>
            {`Confirm · ${DAYS[day][0]}, ${SLOTS[slot][0]} ${SLOTS[slot][1]}`}
          </span>
        </div>
      </div>
    </Screen>
  );
}

// ═════════════════════════════════════════════════════════════
// Pharmacy cart — quantity steppers and live totals
// ═════════════════════════════════════════════════════════════
const ITEMS = [
  ['Metformin 500mg', 'Strip of 15 · Sun Pharma', 42, 'medication', ['#66BB6A', '#2E7D32']],
  ['Atorvastatin 10mg', 'Strip of 10 · Cipla', 118, 'medication_liquid', ['#5C6BC0', '#3949AB']],
  ['Vitamin D3 60K', 'Capsule · 4 pack', 96, 'science', ['#FFA726', '#E65100']],
];

function EtaBadge() {
  const i = useTick(1000);
  return (
    <div style={{ ...row, padding: '6px 10px', borderRadius: 10, background: '#E3F4EA' }}>
      <Icon n="bolt" s={14} c={M.good} />
      <span style={t(11, { w: 600, c: M.good })}>{` ${27 - (Math.trunc(i / 4) % 6)} min`}</span>
    </div>
  );
}

const Step = ({ n, onClick }) => (
  <div onClick={onClick} style={{ width: 32, height: 32, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
    <Icon n={n} s={17} c={M.plum} />
  </div>
);

export function MedNuPharmacy() {
  const [qty, setQty] = useState([2, 1, 1]);
  const total = ITEMS.reduce((s, it, i) => s + it[2] * qty[i], 0);
  const saved = Math.round(total * 0.15);
  const bump = (i, d) => setQty((q) => q.map((v, k) => (k === i ? Math.min(9, Math.max(1, v + d)) : v)));
  const line = (label, value, lc = M.inkSoft, vc = M.ink) => (
    <div style={row}>
      <span style={t(12.5, { c: lc })}>{label}</span>
      <Spacer />
      <span style={t(12.5, { w: 500, c: vc })}>{value}</span>
    </div>
  );
  return (
    <Screen>
      <Body style={{ position: 'absolute', inset: 0 }}>
        <Gap h={TOP + 6} />
        <Pad>
          <div style={row}>
            <BackBtn />
            <Gap w={14} />
            <span style={t(19, { w: 600 })}>Your cart</span>
            <Spacer />
            <EtaBadge />
          </div>
        </Pad>
        <Gap h={18} />
        <Pad>
          <div
            style={{
              ...row, padding: 14, borderRadius: 20,
              background: `linear-gradient(90deg, ${M.plumSoft}, #FCE7D3)`,
            }}
          >
            <Icon n="description" c={M.plum} />
            <Gap w={12} />
            <div style={{ ...col, flex: 1 }}>
              <span style={t(13, { w: 600 })}>Prescription verified</span>
              <span style={t(11, { c: M.inkSoft })}>Dr. Kapoor · 02 Oct</span>
            </div>
            <Icon n="verified" s={22} c={M.good} />
          </div>
        </Pad>
        <Gap h={18} />
        {ITEMS.map((it, i) => (
          <Pad key={it[0]} style={{ paddingBottom: 12 }}>
            <div style={{ ...row, padding: 14, background: '#fff', borderRadius: 20, boxShadow: lift }}>
              <GlyphTile icon={it[3]} colors={it[4]} size={50} />
              <Gap w={12} />
              <div style={{ ...col, flex: 1, minWidth: 0 }}>
                <span style={t(13.5, { w: 600 })}>{it[0]}</span>
                <span style={{ ...t(10.5, { c: M.inkSoft }), ...ellipsis }}>{it[1]}</span>
                <Gap h={4} />
                <span style={t(14, { w: 600, c: M.plum })}>{`₹${it[2] * qty[i]}`}</span>
              </div>
              <div style={{ ...row, background: M.plumSoft, borderRadius: 14 }}>
                <Step n="remove" onClick={() => bump(i, -1)} />
                <span style={{ ...t(13, { w: 600 }), width: 22, textAlign: 'center' }}>{qty[i]}</span>
                <Step n="add" onClick={() => bump(i, 1)} />
              </div>
            </div>
          </Pad>
        ))}
      </Body>
      <div
        style={{
          position: 'absolute', left: 0, right: 0, bottom: 0, ...col, padding: '16px 20px 30px',
          background: '#fff', borderRadius: '28px 28px 0 0', boxShadow: `0 -8px ${blur(24)}px ${a(M.plum, 0.1)}`,
        }}
      >
        {line('Subtotal', `₹${total}`)}
        <Gap h={6} />
        {line('MEDNU15 applied', `−₹${saved}`, M.good, M.good)}
        <Gap h={6} />
        {line('Delivery', 'Free')}
        <div style={{ height: 1, background: M.border, margin: '10.5px 0' }} />
        <div style={row}>
          <span style={t(15, { w: 600 })}>Total</span>
          <Spacer />
          <span style={t(20, { w: 600 })}>{`₹${total - saved}`}</span>
        </div>
        <Gap h={14} />
        <div
          style={{
            height: 52, display: 'flex', alignItems: 'center', justifyContent: 'center', borderRadius: 18,
            background: `linear-gradient(90deg, ${M.plum}, ${M.plum2})`,
          }}
        >
          <span style={t(14, { w: 600, c: '#fff' })}>Pay with UPI</span>
        </div>
      </div>
    </Screen>
  );
}

// ═════════════════════════════════════════════════════════════
// Health dashboard — live ECG trace, BPM and tap-to-log water
// ═════════════════════════════════════════════════════════════
const g = (u, mu, sig) => Math.exp(-(((u - mu) / sig) ** 2));
const wave = (u) =>
  0.55 - 0.07 * g(u, 0.14, 0.03) + 0.08 * g(u, 0.3, 0.008) - 0.46 * g(u, 0.34, 0.008) +
  0.16 * g(u, 0.38, 0.01) - 0.12 * g(u, 0.62, 0.045);

const paintEcg = (ctx, w, h, ms) => {
  const tt = (ms / 3000) % 1;
  ctx.strokeStyle = 'rgba(255,255,255,.06)';
  ctx.lineWidth = 1;
  ctx.beginPath();
  for (let x = 0; x < w; x += 22) {
    ctx.moveTo(x, 0);
    ctx.lineTo(x, h);
  }
  ctx.stroke();
  ctx.beginPath();
  for (let x = 0; x <= w; x += 2) {
    const u = ((x / w) * 2 + tt) % 1;
    const y = wave(u) * h;
    if (x === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
  }
  const grad = ctx.createLinearGradient(0, 0, w, 0);
  grad.addColorStop(0, 'rgba(255,107,122,0)');
  grad.addColorStop(0.25, '#FF6B7A');
  grad.addColorStop(1, '#FF6B7A');
  ctx.strokeStyle = grad;
  ctx.lineWidth = 2.4;
  ctx.lineJoin = 'round';
  ctx.stroke();
};

function Bpm() {
  const i = useTick(1000);
  return (
    <div style={{ display: 'flex', alignItems: 'flex-end' }}>
      <span style={t(30, { w: 600, c: '#fff', h: 1 })}>{72 + [0, 1, 2, 1, 0, -1, -2, -1][i % 8]}</span>
      <span style={{ ...t(11, { c: '#E0C6DB' }), paddingLeft: 4, paddingBottom: 3 }}>bpm</span>
    </div>
  );
}

function Tile({ icon, label, value, sub, c, p, onClick }) {
  return (
    <div onClick={onClick} style={{ flex: '1 1 0', minWidth: 0, padding: 14, background: '#fff', borderRadius: 20, boxShadow: lift }}>
      <div style={row}>
        <div style={box(30, 10, a(c, 0.15))}>
          <Icon n={icon} s={17} c={c} />
        </div>
        <Gap w={8} />
        <span style={t(11.5, { c: M.inkSoft })}>{label}</span>
      </div>
      <Gap h={10} />
      <div style={{ display: 'flex', alignItems: 'flex-end' }}>
        <span style={t(19, { w: 600, h: 1 })}>{value}</span>
        <Gap w={4} />
        <span style={{ ...t(10, { c: M.hint }), ...ellipsis, minWidth: 0 }}>{sub}</span>
      </div>
      <Gap h={10} />
      <div style={{ height: 5, borderRadius: 3, overflow: 'hidden', background: a(c, 0.15) }}>
        <div style={{ height: '100%', width: `${Math.min(1, Math.max(0, p)) * 100}%`, background: c }} />
      </div>
    </div>
  );
}

export function MedNuHealth() {
  const [water, setWater] = useState(5);
  const card = useDiag();
  const ecg = useCallback(paintEcg, []);
  return (
    <Screen style={col}>
      <Body>
        <Gap h={TOP + 6} />
        <Pad>
          <div style={col}>
            <span style={t(22, { w: 600 })}>Health dashboard</span>
            <span style={t(11.5, { c: M.inkSoft })}>Everything synced · just now</span>
          </div>
          <Gap h={16} />
          <div
            ref={card}
            style={{
              padding: '16px 18px 8px', borderRadius: 26,
              background: `linear-gradient(var(--diag, 135deg), ${M.plum}, ${M.plumDeep})`,
              boxShadow: `0 12px ${blur(24)}px ${a(M.plum, 0.3)}`,
            }}
          >
            <div style={row}>
              <Icon n="favorite" s={18} c="#FF6B7A" />
              <Gap w={8} />
              <span style={t(12.5, { c: '#E0C6DB' })}>Heart rate</span>
              <Spacer />
              <Bpm />
            </div>
            <div style={{ height: 92 }}>
              <Paint paint={ecg} animate />
            </div>
          </div>
          <Gap h={14} />
          <div style={{ ...row, gap: 12, alignItems: 'stretch' }}>
            <Tile icon="directions_walk" label="Steps" value="7,420" sub="/ 10,000" c="#42A5F5" p={0.74} />
            <Tile
              icon="water_drop" label="Water" value={`${water}`} sub="/ 8 glasses" c="#26C6DA" p={water / 8}
              onClick={() => setWater((w) => (w >= 8 ? 0 : w + 1))}
            />
          </div>
          <Gap h={12} />
          <div style={{ ...row, gap: 12, alignItems: 'stretch' }}>
            <Tile icon="bedtime" label="Sleep" value="7h 12m" sub="/ 8h" c={M.orchid} p={0.9} />
            <Tile icon="air" label="SpO₂" value="98%" sub="normal" c={M.good} p={0.98} />
          </div>
          <Gap h={14} />
          <div style={{ ...row, padding: 14, background: '#fff', borderRadius: 20, boxShadow: lift }}>
            <GlyphTile icon="alarm" colors={['#FFA726', '#E65100']} size={44} />
            <Gap w={12} />
            <div style={{ ...col, flex: 1 }}>
              <span style={t(13.5, { w: 600 })}>Metformin 500mg</span>
              <span style={t(11, { c: M.inkSoft })}>After dinner · 8:30 PM</span>
            </div>
            <div style={{ padding: '7px 12px', borderRadius: 10, background: M.plum }}>
              <span style={t(11.5, { w: 600, c: '#fff' })}>Take</span>
            </div>
          </div>
        </Pad>
      </Body>
      <BottomNav index={2} />
    </Screen>
  );
}

// ═════════════════════════════════════════════════════════════
// 5 · Partner app — role picker
// ═════════════════════════════════════════════════════════════
const ROLES = [
  ['medical_services', 'Doctor', 'Consult & prescribe', ['#522546', '#633058']],
  ['local_hospital', 'Ambulance', 'Respond to SOS', ['#EF5350', '#522546']],
  ['local_pharmacy', 'Pharmacy', 'Fulfil orders', ['#66BB6A', '#2E7D32']],
  ['biotech', 'Lab', 'Collect samples', ['#5C6BC0', '#3949AB']],
  ['volunteer_activism', 'Caregiver', 'Home assistance', ['#FFA726', '#E65100']],
  ['self_improvement', 'Physio', 'Rehab sessions', ['#42A5F5', '#0D47A1']],
  ['psychology', 'Counsellor', 'Mental wellness', ['#A36BAC', '#522546']],
  ['restaurant', 'Nutritionist', 'Diet planning', ['#9CCC65', '#33691E']],
];

export function MedNuRolePicker() {
  const selected = 1;
  return (
    <Screen>
      <div style={{ position: 'absolute', inset: 0, ...col }}>
        <Gap h={TOP + 18} />
        <Pad x={22}>
          <div style={row}>
            <img src={logo} alt="MedNU" style={{ height: 30, width: 30 }} />
            <Gap w={8} />
            <div style={{ padding: '3px 8px', borderRadius: 6, background: M.plumSoft }}>
              <span style={t(9, { w: 600, c: M.plum, ls: 1.2 })}>PARTNER</span>
            </div>
          </div>
          <Gap h={22} />
          <span style={{ ...t(28, { w: 600, h: 1.15 }), display: 'block' }}>{'How will you\nuse MedNU?'}</span>
          <Gap h={8} />
          <span style={{ ...t(13, { c: M.inkSoft, h: 1.5 }), display: 'block' }}>
            {'Choose your role. You can add more later\nfrom your profile.'}
          </span>
        </Pad>
        <Gap h={20} />
        <div style={{ flex: 1, minHeight: 0, overflow: 'hidden' }}>
          <div
            style={{
              display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: 12, padding: '0 22px 110px',
            }}
          >
            {ROLES.map(([ic, name, desc, colors], i) => (
              <div
                key={name}
                style={{
                  aspectRatio: '1.32', padding: 14, borderRadius: 22, ...col, justifyContent: 'space-between', minWidth: 0,
                  background: i === selected ? M.plumSoft : '#fff',
                  border: `${i === selected ? 1.6 : 1}px solid ${i === selected ? M.plum : M.border}`,
                  boxShadow: i === selected ? lift : 'none',
                }}
              >
                <div style={row}>
                  <GlyphTile icon={ic} colors={colors} size={40} />
                  <Spacer />
                  {i === selected && <Icon n="check_circle" s={22} c={M.plum} />}
                </div>
                <div style={{ ...col, minWidth: 0 }}>
                  <span style={t(14, { w: 600 })}>{name}</span>
                  <span style={{ ...t(11, { c: M.inkSoft }), ...ellipsis }}>{desc}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
      <div
        style={{
          position: 'absolute', left: 0, right: 0, bottom: 0, padding: '26px 22px 34px',
          background: `linear-gradient(180deg, ${a(M.bg, 0)}, ${M.bg}, ${M.bg})`,
        }}
      >
        <div
          style={{
            height: 54, ...row, justifyContent: 'center', borderRadius: 18,
            background: `linear-gradient(90deg, ${M.plum}, ${M.plum2})`,
            boxShadow: `0 8px ${blur(18)}px ${a(M.plum, 0.35)}`,
          }}
        >
          <span style={t(14, { w: 600, c: '#fff' })}>Continue as Ambulance</span>
          <Gap w={6} />
          <Icon n="arrow_forward" s={18} c="#fff" />
        </div>
      </div>
    </Screen>
  );
}
