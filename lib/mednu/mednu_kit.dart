import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MedNU brand tokens — mirrored from the production app's AppColors.
class M {
  M._();
  static const plum = Color(0xFF522546);
  static const plum2 = Color(0xFF633058);
  static const plumDeep = Color(0xFF24101F);
  static const plumSoft = Color(0xFFEFE1EC);
  static const orchid = Color(0xFFC494CD);
  static const coral = Color(0xFFF9943B);
  static const bg = Color(0xFFF7F4F6);
  static const ink = Color(0xFF33172C);
  static const inkSoft = Color(0xFF7A6472);
  static const hint = Color(0xFFAE96A7);
  static const border = Color(0xFFE4D9E1);
  static const good = Color(0xFF1E8E5A);
  static const crit = Color(0xFFC0392B);

  static TextStyle t(double size,
          {FontWeight w = FontWeight.w400,
          Color c = ink,
          double? h,
          double? ls}) =>
      GoogleFonts.poppins(
          fontSize: size,
          fontWeight: w,
          color: c,
          height: h,
          letterSpacing: ls,
          decoration: TextDecoration.none);

  static List<BoxShadow> get lift => [
        BoxShadow(
            color: plum.withValues(alpha: .09),
            blurRadius: 22,
            offset: const Offset(0, 8)),
      ];
}

/// Rounded gradient chip with an icon — the service tile glyph.
class GlyphTile extends StatelessWidget {
  const GlyphTile(this.icon, this.colors, {super.key, this.size = 48});
  final IconData icon;
  final List<Color> colors;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * .32),
          gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          boxShadow: [
            BoxShadow(
                color: colors.last.withValues(alpha: .28),
                blurRadius: 12,
                offset: const Offset(0, 6)),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * .5),
      );
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.index});
  final int index;

  static const _items = [
    (Icons.home_rounded, 'Home'),
    (Icons.calendar_month_rounded, 'Bookings'),
    (Icons.folder_copy_rounded, 'Records'),
    (Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFF0E7EE))),
        boxShadow: [
          BoxShadow(
              color: M.plum.withValues(alpha: .06),
              blurRadius: 24,
              offset: const Offset(0, -6)),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < _items.length; i++)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                    decoration: BoxDecoration(
                      color: i == index ? M.plumSoft : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(_items[i].$1,
                        size: 22, color: i == index ? M.plum : M.hint),
                  ),
                  const SizedBox(height: 2),
                  Text(_items[i].$2,
                      style: M.t(10.5,
                          w: i == index ? FontWeight.w600 : FontWeight.w500,
                          c: i == index ? M.plum : M.hint)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Initial-letter avatar on a soft gradient (stands in for a doctor photo).
class Initials extends StatelessWidget {
  const Initials(this.text, {super.key, this.size = 56, this.tone = 0});
  final String text;
  final double size;
  final int tone;

  static const _tones = [
    [Color(0xFFEFE1EC), Color(0xFFD9B7D3)],
    [Color(0xFFFCE7D3), Color(0xFFF7C497)],
    [Color(0xFFDCEBF7), Color(0xFFB4D2EC)],
    [Color(0xFFDDF0E4), Color(0xFFB2DBC1)],
  ];

  @override
  Widget build(BuildContext context) {
    final c = _tones[tone % _tones.length];
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * .3),
        gradient: LinearGradient(
            colors: c, begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Text(text,
          style: M.t(size * .34, w: FontWeight.w600, c: M.plum)),
    );
  }
}


/// Rebuilds [builder] every [period] with an incrementing tick — drives the
/// "live" numbers (countdowns, counters) inside showcased screens.
class Every extends StatefulWidget {
  const Every(this.period, this.builder, {super.key});
  final Duration period;
  final Widget Function(BuildContext context, int tick) builder;

  @override
  State<Every> createState() => _EveryState();
}

class _EveryState extends State<Every> {
  late final Timer _t;
  int _n = 0;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(widget.period, (_) => setState(() => _n++));
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _n);
}
