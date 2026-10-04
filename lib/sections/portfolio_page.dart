import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../mednu/mednu_kit.dart' show M;
import '../mednu/mednu_live.dart';
import '../mednu/mednu_screens.dart';
import '../ui/browser_frame.dart';
import '../ui/phone_frame.dart';
import '../web/sites.dart';
import 'figma_art.dart';

// Edit these to personalise the page.
const kName = 'VAR';
const kEmail = 'vinayanandharaju215@gmail.com';
const kPhone = '+91 77992 30357';
const kResume =
    'https://drive.google.com/file/d/10mvAQFTDiIcQfnxl9eJ_drvLkOBCyHpp/view?usp=sharing';
const kMedNuPlayStore =
    'https://play.google.com/store/apps/details?id=com.mednu.mednu';
const kRangaFigma =
    'https://www.figma.com/design/ENoE68ZPXz8mwXheSg5HGD/Ranga-%E2%80%93-Streaming-App-Case-Study?node-id=1-1179';
const kCourtsideFigma =
    'https://www.figma.com/design/7Vt2iXAaRDNvs4drGZenA0/Courtside-%E2%80%93-Sports-Venue-Booking-App?node-id=0-1';
const kMeridianFigma =
    'https://www.figma.com/design/tdISwGbz7cOHeUgop5YyjJ/meridian-crm-case-study?node-id=1-490';

// Edit the tags to match exactly what you offer.
const _skills = <(String, String, IconData, Color, List<String>)>[
  (
    'App development',
    'Production mobile and web apps, from architecture to store release.',
    Icons.phone_iphone_rounded,
    Color(0xFFC494CD),
    ['Flutter', 'Dart', 'Riverpod', 'Firebase', 'REST APIs', 'Payments', 'Maps', 'Push'],
  ),
  (
    'Salesforce',
    'Custom apps and automation on the Salesforce platform.',
    Icons.cloud_rounded,
    Color(0xFF3AA0F0),
    ['Apex', 'SOQL', 'Lightning Web Components', 'Flows', 'Triggers', 'Integrations'],
  ),
  (
    'UI/UX design',
    'Interfaces that look premium and stay usable on every screen size.',
    Icons.draw_rounded,
    Color(0xFFF9943B),
    ['Figma', 'Prototyping', 'Design systems', 'Responsive UI', 'Accessibility'],
  ),
];

// ── Theme ────────────────────────────────────────────────────
const _bg = Color(0xFF09080D);
const _s1 = Color(0xFF121018);
const _s2 = Color(0xFF1B1823);
const _line = Color(0xFF2A2533);
const _tx = Color(0xFFF4F0F8);
const _mute = Color(0xFF9D95AD);
const _orchid = Color(0xFFC494CD);
const _coral = Color(0xFFF9943B);

TextStyle _disp(double s, {Color c = _tx, double h = 1.0}) => GoogleFonts.sora(
    fontSize: s * .74,
    color: c,
    fontWeight: FontWeight.w600,
    height: h < 1.1 ? 1.12 : h,
    letterSpacing: -s * .03);

TextStyle _ui(double s,
        {Color c = _tx, FontWeight w = FontWeight.w400, double h = 1.5, double? ls}) =>
    GoogleFonts.inter(
        fontSize: s, color: c, fontWeight: w, height: h, letterSpacing: ls);

Future<void> _open(String url) => launchUrl(Uri.parse(url));

// ─────────────────────────────────────────────────────────────
class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _skillsKey = GlobalKey();
  final _workKey = GlobalKey();
  final _webKey = GlobalKey();
  final _figmaKey = GlobalKey();
  final _contactKey = GlobalKey();

  void _go(GlobalKey k) {
    final c = k.currentContext;
    if (c == null) return;
    Scrollable.ensureVisible(c,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
        alignment: .02);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final narrow = w < 820;
    final gutter = narrow ? 20.0 : (w < 1200 ? 44.0 : 72.0);

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(children: [
            _Hero(
                narrow: narrow,
                gutter: gutter,
                onWork: () => _go(_workKey),
                onContact: () => _go(_contactKey)),
            _Frame(
                key: _skillsKey,
                gutter: gutter,
                top: narrow ? 72 : 120,
                child: _SkillsBlock(narrow: narrow)),
            _Frame(
                key: _workKey,
                gutter: gutter,
                top: narrow ? 72 : 130,
                child: _MedNuWork(narrow: narrow)),
            _Frame(
                key: _webKey,
                gutter: gutter,
                top: narrow ? 72 : 130,
                child: _Websites(narrow: narrow, gutter: gutter)),
            _Frame(
                key: _figmaKey,
                gutter: gutter,
                top: narrow ? 72 : 130,
                child: _FigmaCards(narrow: narrow)),
            _Frame(
                gutter: gutter,
                top: narrow ? 72 : 130,
                child: _Process(narrow: narrow)),
            _Frame(
                key: _contactKey,
                gutter: gutter,
                top: narrow ? 72 : 130,
                bottom: narrow ? 40 : 80,
                child: _Contact(narrow: narrow)),
          ]),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _Nav(
            narrow: narrow,
            gutter: gutter,
            links: [
              ('Skills', () => _go(_skillsKey)),
              ('Work', () => _go(_workKey)),
              ('Websites', () => _go(_webKey)),
              ('Figma', () => _go(_figmaKey)),
            ],
            onContact: () => _go(_contactKey),
          ),
        ),
      ]),
    );
  }
}

/// Centres content at a max width with page gutters.
class _Frame extends StatelessWidget {
  const _Frame(
      {super.key, required this.gutter, required this.child, this.top = 0, this.bottom = 0});
  final double gutter, top, bottom;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: top, bottom: bottom),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1300 + 144),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: gutter),
              child: child,
            ),
          ),
        ),
      );
}

// ── Nav ──────────────────────────────────────────────────────
class _Nav extends StatelessWidget {
  const _Nav(
      {required this.narrow,
      required this.gutter,
      required this.links,
      required this.onContact});
  final bool narrow;
  final double gutter;
  final List<(String, VoidCallback)> links;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 68,
          padding: EdgeInsets.symmetric(horizontal: gutter),
          decoration: BoxDecoration(
            color: _bg.withValues(alpha: .62),
            border: const Border(bottom: BorderSide(color: _line)),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1300),
              child: Row(children: [
                Text(kName, style: _disp(28)),
                Container(
                  margin: const EdgeInsets.only(left: 3, top: 10),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: _coral, shape: BoxShape.circle),
                ),
                const Spacer(),
                if (!narrow)
                  for (final l in links)
                    _HoverText(label: l.$1, onTap: l.$2),
                const SizedBox(width: 18),
                _Btn('Get in touch', onTap: onContact, small: true),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverText extends StatefulWidget {
  const _HoverText({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<_HoverText> {
  bool _h = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 160),
              style: _ui(14, c: _h ? _tx : _mute, w: FontWeight.w500),
              child: Text(widget.label),
            ),
          ),
        ),
      );
}

class _Btn extends StatefulWidget {
  const _Btn(this.label,
      {required this.onTap, this.outline = false, this.small = false, this.icon});
  final String label;
  final VoidCallback onTap;
  final bool outline, small;
  final IconData? icon;

  @override
  State<_Btn> createState() => _BtnState();
}

class _BtnState extends State<_Btn> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.outline;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(0, _h ? -2 : 0, 0),
          padding: EdgeInsets.symmetric(
              horizontal: widget.small ? 20 : 28, vertical: widget.small ? 11 : 16),
          decoration: BoxDecoration(
            color: o ? Colors.transparent : (_h ? Colors.white : _tx),
            borderRadius: BorderRadius.circular(40),
            border: o ? Border.all(color: _h ? _tx : _line, width: 1.4) : null,
            boxShadow: o || !_h
                ? null
                : [BoxShadow(color: _orchid.withValues(alpha: .35), blurRadius: 24)],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Flexible(
              child: Text(widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: _ui(widget.small ? 13.5 : 15,
                      c: o ? _tx : _bg, w: FontWeight.w600, h: 1.2)),
            ),
            if (widget.icon != null) ...[
              const SizedBox(width: 8),
              Icon(widget.icon, size: 18, color: o ? _tx : _bg),
            ],
          ]),
        ),
      ),
    );
  }
}

// ── Hero ─────────────────────────────────────────────────────
class _Hero extends StatelessWidget {
  const _Hero(
      {required this.narrow,
      required this.gutter,
      required this.onWork,
      required this.onContact});
  final bool narrow;
  final double gutter;
  final VoidCallback onWork, onContact;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return ClipRect(
      child: Stack(children: [
        // ambient glow
        Positioned(
          top: -220,
          left: w * .5 - 520,
          child: Container(
            width: 1040,
            height: 760,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                M.plum2.withValues(alpha: .55),
                M.plum.withValues(alpha: .0),
              ]),
            ),
          ),
        ),
        Positioned(
          top: 360,
          right: -200,
          child: Container(
            width: 620,
            height: 620,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                _coral.withValues(alpha: .16),
                _coral.withValues(alpha: 0),
              ]),
            ),
          ),
        ),
        _Frame(
          gutter: gutter,
          top: narrow ? 120 : 168,
          bottom: narrow ? 72 : 120,
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .05),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: _line),
              ),
              child: Text('UI/UX  ·  APP DEVELOPMENT  ·  SALESFORCE',
                  textAlign: TextAlign.center,
                  style: _ui(narrow ? 10.5 : 12, c: _orchid, w: FontWeight.w600, ls: 1.8)),
            ),
            SizedBox(height: narrow ? 24 : 32),
            Text('I design, build and ship',
                textAlign: TextAlign.center,
                style: _disp(narrow ? 44 : 104)),
            ShaderMask(
              shaderCallback: (r) => const LinearGradient(
                      colors: [Color(0xFFE9B8F2), _orchid, _coral])
                  .createShader(r),
              child: Text('digital products.',
                  textAlign: TextAlign.center,
                  style: _disp(narrow ? 44 : 104, c: Colors.white)),
            ),
            SizedBox(height: narrow ? 20 : 30),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(
                  'UI/UX designer, Flutter app developer and Salesforce developer — taking ideas from first sketch to live product.',
                  textAlign: TextAlign.center,
                  style: _ui(narrow ? 15.5 : 18.5, c: _mute, h: 1.6)),
            ),
            SizedBox(height: narrow ? 28 : 38),
            Wrap(spacing: 14, runSpacing: 14, alignment: WrapAlignment.center, children: [
              _Btn('View my work', onTap: onWork, icon: Icons.arrow_downward_rounded),
              _Btn('Get in touch', onTap: onContact, outline: true),
              _Btn('Resume',
                  onTap: () => _open(kResume),
                  outline: true,
                  icon: Icons.description_outlined),
            ]),
          ]),
        ),
      ]),
    );
  }
}

// ── Section header ───────────────────────────────────────────
class _Head extends StatelessWidget {
  const _Head(this.eyebrow, this.title, {this.sub, required this.narrow});
  final String eyebrow, title;
  final String? sub;
  final bool narrow;

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(eyebrow.toUpperCase(),
            style: _ui(12, c: _orchid, w: FontWeight.w600, ls: 2.2)),
        const SizedBox(height: 16),
        Text(title, style: _disp(narrow ? 40 : 72, h: 1.02)),
        if (sub != null) ...[
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(sub!, style: _ui(narrow ? 15 : 17, c: _mute, h: 1.6)),
          ),
        ],
        SizedBox(height: narrow ? 32 : 52),
      ]);
}

// ── Skills ───────────────────────────────────────────────────
class _SkillsBlock extends StatelessWidget {
  const _SkillsBlock({required this.narrow});
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    final cards = [
      for (final s in _skills)
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: _line),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [s.$4.withValues(alpha: .10), _s1, _s1],
              stops: const [0, .45, 1],
            ),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: s.$4.withValues(alpha: .14),
                border: Border.all(color: s.$4.withValues(alpha: .35)),
              ),
              child: Icon(s.$3, color: s.$4),
            ),
            const SizedBox(height: 24),
            Text(s.$1, style: _disp(36)),
            const SizedBox(height: 10),
            Text(s.$2, style: _ui(14.5, c: _mute, h: 1.55)),
            const SizedBox(height: 22),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final t in s.$5)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .04),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: _line),
                  ),
                  child: Text(t, style: _ui(12.5, c: _tx, h: 1.2)),
                ),
            ]),
          ]),
        ),
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Head('What I do', 'Three disciplines,\none pair of hands.', narrow: narrow),
      narrow
          ? Column(children: [
              for (final c in cards) ...[c, const SizedBox(height: 16)],
            ])
          : IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                for (var i = 0; i < cards.length; i++) ...[
                  if (i > 0) const SizedBox(width: 20),
                  Expanded(child: cards[i]),
                ],
              ]),
            ),
    ]);
  }
}

// ── MedNU case study with interactive viewer ─────────────────
class _MedNuWork extends StatefulWidget {
  const _MedNuWork({required this.narrow});
  final bool narrow;

  @override
  State<_MedNuWork> createState() => _MedNuWorkState();
}

class _MedNuWorkState extends State<_MedNuWork> {
  int _i = 0;
  bool _hover = false;
  Timer? _t;

  static const _items = <(String, String, Widget)>[
    ('mednu.in on mobile', 'The live, responsive website as it looks on a phone.', RealMobileSite()),
    ('Home', 'Services, a live doctors-online count and a ticking countdown to your next consult.', MedNuHome()),
    ('Find a doctor', 'Specialty filters, ratings and live availability at a glance.', MedNuFindDoctor()),
    ('Book a slot', 'Tap a day and a time — the confirm bar updates instantly.', MedNuBooking()),
    ('Pharmacy cart', 'Quantity steppers recalculate totals and savings live.', MedNuPharmacy()),
    ('Health dashboard', 'A live ECG trace and heart rate. Tap water to log a glass.', MedNuHealth()),
    ('Partner onboarding', 'One app, ten provider roles, one clear choice.', MedNuRolePicker()),
  ];

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 7), (_) {
      if (!_hover && mounted) setState(() => _i = (_i + 1) % _items.length);
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final narrow = widget.narrow;
    final phoneW = narrow ? 270.0 : 330.0;

    final phone = Stack(alignment: Alignment.center, children: [
      Container(
        width: phoneW * 1.5,
        height: phoneW * 1.5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [
            M.plum2.withValues(alpha: .7),
            M.plum.withValues(alpha: 0),
          ]),
        ),
      ),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        switchInCurve: Curves.easeOutCubic,
        transitionBuilder: (c, a) => FadeTransition(
          opacity: a,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, .03), end: Offset.zero).animate(a),
            child: c,
          ),
        ),
        child: PhoneFrame(
          key: ValueKey(_i),
          width: phoneW,
          child: _items[_i].$3,
        ),
      ),
    ]);

    final tabs = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (var k = 0; k < _items.length; k++)
        GestureDetector(
          onTap: () => setState(() => _i = k),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
              decoration: BoxDecoration(
                color: k == _i ? _s2 : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: k == _i ? _line : Colors.transparent),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  width: 34,
                  child: Text(_two(k + 1),
                      style: _ui(12.5,
                          c: k == _i ? _coral : _mute, w: FontWeight.w600, h: 1.6)),
                ),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_items[k].$1,
                        style: _ui(16,
                            c: k == _i ? _tx : _mute, w: FontWeight.w600, h: 1.3)),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      alignment: Alignment.topLeft,
                      child: k == _i
                          ? Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(_items[k].$2,
                                  style: _ui(13.5, c: _mute, h: 1.55)),
                            )
                          : const SizedBox(width: double.infinity),
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        ),
    ]);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _Head(
          '01 — Case study',
          'MedNU',
          narrow: narrow,
          sub:
              'A family healthcare platform: patients book doctors, order medicines, call an ambulance and track every service, while providers run their work from a separate partner app. Designed and built end to end.',
        ),
        const Wrap(spacing: 10, runSpacing: 10, children: [
          _Chip('Flutter'),
          _Chip('Firebase'),
          _Chip('Patient app'),
          _Chip('Partner app (10 roles)'),
          _Chip('Web portal'),
          _Chip('Admin panel'),
        ]),
        SizedBox(height: narrow ? 28 : 40),
        Container(
          padding: EdgeInsets.all(narrow ? 18 : 36),
          decoration: BoxDecoration(
            color: _s1,
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: _line),
          ),
          child: narrow
              ? Column(children: [
                  phone,
                  const SizedBox(height: 18),
                  tabs,
                ])
              : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(flex: 5, child: tabs),
                  const SizedBox(width: 24),
                  Expanded(flex: 5, child: Center(child: phone)),
                ]),
        ),
        const SizedBox(height: 20),
        _DesignTokens(narrow: narrow),
        const SizedBox(height: 22),
        Align(
          alignment: Alignment.centerLeft,
          child: _Btn('Get the app on Google Play',
              onTap: () => _open(kMedNuPlayStore),
              outline: true,
              icon: Icons.arrow_outward_rounded),
        ),
      ]),
    );
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .04),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: _line),
        ),
        child: Text(label, style: _ui(13, c: _tx, h: 1.2)),
      );
}

class _DesignTokens extends StatelessWidget {
  const _DesignTokens({required this.narrow});
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    const sw = [
      ('Plum', M.plum, '#522546'),
      ('Orchid', M.orchid, '#C494CD'),
      ('Coral', M.coral, '#F9943B'),
      ('Blush', M.plumSoft, '#EFE1EC'),
      ('Ink', M.ink, '#33172C'),
    ];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(narrow ? 20 : 28),
      decoration: BoxDecoration(
        color: _s1,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _line),
      ),
      child: Wrap(spacing: 28, runSpacing: 22, crossAxisAlignment: WrapCrossAlignment.center, children: [
        Text('Design system', style: _disp(28)),
        for (final s in sw)
          Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: s.$2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.$1, style: _ui(13, w: FontWeight.w600, h: 1.2)),
              Text(s.$3, style: _ui(11.5, c: _mute, h: 1.3)),
            ]),
          ]),
        Text('Poppins · light & dark · semantic status colours',
            style: _ui(13, c: _mute)),
      ]),
    );
  }
}

// ── Websites ─────────────────────────────────────────────────
class _Websites extends StatelessWidget {
  const _Websites({required this.narrow, required this.gutter});
  final bool narrow;
  final double gutter;

  @override
  Widget build(BuildContext context) {
    final w = math.min(MediaQuery.sizeOf(context).width, 1444.0);
    final inner = w - gutter * 2;
    final two = !narrow && inner > 900;
    final fw = two ? (inner - 36) / 2 : inner;

    Widget item(String url, String name, String title, String sub, double h, Widget site) =>
        SizedBox(
          width: fw,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            BrowserFrame(url: url, siteHeight: h, site: site, width: fw),
            SizedBox(height: 20 + (fw / 1280) * 6),
            Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: _ui(17, w: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(sub, style: _ui(14, c: _mute)),
                ]),
              ),
              const SizedBox(width: 16),
              _Btn('Visit $name',
                  onTap: () => _open('https://$url'),
                  icon: Icons.arrow_outward_rounded),
            ]),
          ]),
        );

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Head('02 — Websites', 'Live websites.',
          narrow: narrow,
          sub: 'Production sites. Each preview scrolls on its own — hover to pause, click for a full-size view, or visit the real thing.'),
      Wrap(spacing: 36, runSpacing: 52, children: [
        item('mednu.in', 'MedNU', 'MedNU — live website',
            'The production site, captured in full.', kRealSiteH, const RealMedNuSite()),
        item('skyfit-one.vercel.app', 'skyXfit', 'skyXfit — fitness calculator',
            'BMI, body-fat, calorie and macro calculator for a fitness channel.',
            kSkyfitSiteH, const RealSkyfitSite()),
      ]),
    ]);
  }
}

// ── Figma case studies ───────────────────────────────────────
class _FigmaCards extends StatelessWidget {
  const _FigmaCards({required this.narrow});
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1100;

    Widget card(String idx, String title, String sub, String blurb, String url,
            String folder, CustomPainter art, Color accent) =>
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _s1,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: _line),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FigmaArt(folder: folder, fallback: art, height: narrow ? 260 : 300),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 24, 10, 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('$idx — DESIGN FILE',
                    style: _ui(11.5, c: accent, w: FontWeight.w600, ls: 2)),
                const SizedBox(height: 10),
                Text(title, style: _disp(narrow ? 40 : 48)),
                const SizedBox(height: 4),
                Text(sub, style: _ui(15, w: FontWeight.w600)),
                const SizedBox(height: 12),
                Text(blurb, style: _ui(14, c: _mute, h: 1.6)),
                const SizedBox(height: 22),
                _Btn('Open in Figma',
                    onTap: () => _open(url), icon: Icons.arrow_outward_rounded),
              ]),
            ),
          ]),
        );

    final cards = [
      card(
          '03',
          'Meridian',
          'CRM case study',
          'A CRM product case study — the full design file with screens, flows and the thinking behind them.',
          kMeridianFigma,
          'assets/figma/meridian/',
          const MeridianPainter(),
          const Color(0xFF3AA0F0)),
      card(
          '04',
          'Courtside',
          'Sports venue booking app',
          'The full Figma file — screens, components and flows — for a mobile app that lets players find and book sports venues.',
          kCourtsideFigma,
          'assets/figma/courtside/',
          const CourtPainter(),
          const Color(0xFF4CD08A)),
      card(
          '05',
          'Ranga',
          'Streaming app case study',
          'A Figma case study for a streaming app — research, flows and the final screens, all in one file.',
          kRangaFigma,
          'assets/figma/ranga/',
          const RangaPainter(),
          _coral),
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Head('Figma', 'Design case studies', narrow: narrow,
          sub: 'Full design files you can open and explore.'),
      wide
          ? IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                for (var i = 0; i < cards.length; i++) ...[
                  if (i > 0) const SizedBox(width: 22),
                  Expanded(child: cards[i]),
                ],
              ]),
            )
          : Column(children: [
              for (final c in cards) ...[c, const SizedBox(height: 20)],
            ]),
    ]);
  }
}

// ── Process ──────────────────────────────────────────────────
class _Process extends StatelessWidget {
  const _Process({required this.narrow});
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('Understand', 'Who uses it, in what moment, and what happens if it goes wrong.'),
      ('Systemise', 'Colour, type and spacing become tokens before any screen exists.'),
      ('Build', 'I design directly in code — what you review is what ships.'),
      ('Harden', 'Small phones, tablets, dark mode and long text. No overflow, ever.'),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Head('Process', 'From first sketch\nto shipped.', narrow: narrow),
      Wrap(spacing: 28, runSpacing: 36, children: [
        for (var i = 0; i < steps.length; i++)
          SizedBox(
            width: narrow ? double.infinity : 280,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 16),
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: _line))),
                child: Text('0${i + 1}', style: _disp(44, c: _orchid)),
              ),
              const SizedBox(height: 18),
              Text(steps[i].$1, style: _ui(19, w: FontWeight.w600, h: 1.2)),
              const SizedBox(height: 8),
              Text(steps[i].$2, style: _ui(14.5, c: _mute, h: 1.6)),
            ]),
          ),
      ]),
    ]);
  }
}

// ── Contact ──────────────────────────────────────────────────
class _Contact extends StatelessWidget {
  const _Contact({required this.narrow});
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(narrow ? 28 : 72),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: _line),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3A1B33), Color(0xFF15101A), Color(0xFF1F1410)],
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("LET'S WORK TOGETHER",
            style: _ui(12, c: _orchid, w: FontWeight.w600, ls: 2.2)),
        const SizedBox(height: 18),
        Text('Have a product\nworth building?', style: _disp(narrow ? 44 : 96)),
        SizedBox(height: narrow ? 28 : 44),
        Wrap(spacing: 14, runSpacing: 14, children: [
          _Btn(kEmail,
              onTap: () => _open('mailto:$kEmail'), icon: Icons.mail_outline_rounded),
          _Btn(kPhone,
              onTap: () => _open('tel:${kPhone.replaceAll(' ', '')}'),
              outline: true,
              icon: Icons.call_outlined),
          _Btn('Resume',
              onTap: () => _open(kResume),
              outline: true,
              icon: Icons.description_outlined),
        ]),
      ]),
    );
  }
}
