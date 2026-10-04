import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'mednu_kit.dart';

const _top = 54.0;

Widget _scroll(List<Widget> children) => SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );


// ─────────────────────────────────────────────────────────────
// Booking — tap a day and a slot
// ─────────────────────────────────────────────────────────────
class MedNuBooking extends StatefulWidget {
  const MedNuBooking({super.key});

  @override
  State<MedNuBooking> createState() => _MedNuBookingState();
}

class _MedNuBookingState extends State<MedNuBooking> {
  int _day = 2;
  int _slot = 6;

  static const _days = [
    ('Mon', '06'), ('Tue', '07'), ('Wed', '08'), ('Thu', '09'), ('Fri', '10'),
  ];
  static const _slots = [
    ('10:00', 'AM'), ('10:30', 'AM'), ('11:00', 'AM'), ('11:30', 'AM'),
    ('4:00', 'PM'), ('4:30', 'PM'), ('5:30', 'PM'), ('6:00', 'PM'),
  ];
  static const _taken = {1, 4};

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: M.bg,
      child: Stack(children: [
        Column(children: [
          Container(
            height: 262,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [M.plum, M.plumDeep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
            ),
            child: Stack(children: [
              Positioned(
                right: 6,
                bottom: 0,
                child: Image.asset('assets/mednu/doctor_animated_cutout.png',
                    height: 176, fit: BoxFit.contain),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, _top + 6, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      _glass(Icons.arrow_back_rounded),
                      const Spacer(),
                      _glass(Icons.favorite_border_rounded),
                    ]),
                    const SizedBox(height: 22),
                    Text('Dr. Ritika\nKapoor',
                        style: M.t(26,
                            w: FontWeight.w600, c: Colors.white, h: 1.15)),
                    const SizedBox(height: 6),
                    Text('Senior Cardiologist · MD, DM',
                        style: M.t(12, c: const Color(0xFFE0C6DB))),
                  ],
                ),
              ),
            ]),
          ),
          Expanded(
            child: _scroll([
              Transform.translate(
                offset: const Offset(0, -26),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: M.lift),
                    child: Row(children: [
                      for (final s in const [
                        ('1.2k', 'Patients'),
                        ('12 yrs', 'Experience'),
                        ('4.9', 'Rating'),
                      ])
                        Expanded(
                          child: Column(children: [
                            Text(s.$1,
                                style: M.t(16, w: FontWeight.w600, c: M.plum)),
                            Text(s.$2, style: M.t(10.5, c: M.inkSoft)),
                          ]),
                        ),
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text('Pick a day', style: M.t(15, w: FontWeight.w600)),
                      const Spacer(),
                      Text('October 2026', style: M.t(12, c: M.inkSoft)),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      for (var i = 0; i < _days.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _day = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              decoration: BoxDecoration(
                                color: i == _day ? M.plum : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: i == _day ? M.plum : M.border),
                              ),
                              child: Column(children: [
                                Text(_days[i].$1,
                                    style: M.t(10.5,
                                        c: i == _day
                                            ? const Color(0xFFE0C6DB)
                                            : M.inkSoft)),
                                const SizedBox(height: 3),
                                Text(_days[i].$2,
                                    style: M.t(16,
                                        w: FontWeight.w600,
                                        c: i == _day ? Colors.white : M.ink)),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ]),
                    const SizedBox(height: 20),
                    Text('Available slots',
                        style: M.t(15, w: FontWeight.w600)),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.9,
                      children: [
                        for (var i = 0; i < _slots.length; i++)
                          GestureDetector(
                            onTap: _taken.contains(i)
                                ? null
                                : () => setState(() => _slot = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: i == _slot
                                    ? M.plumSoft
                                    : _taken.contains(i)
                                        ? const Color(0xFFF1ECF0)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: i == _slot ? M.plum : M.border,
                                    width: i == _slot ? 1.4 : 1),
                              ),
                              child: Text(
                                _slots[i].$1,
                                style: M
                                    .t(12,
                                        w: i == _slot
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        c: _taken.contains(i)
                                            ? M.hint
                                            : i == _slot
                                                ? M.plum
                                                : M.ink)
                                    .copyWith(
                                        decoration: _taken.contains(i)
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 104),
        ]),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: M.plum.withValues(alpha: .1),
                    blurRadius: 24,
                    offset: const Offset(0, -8)),
              ],
            ),
            child: Row(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Consultation fee', style: M.t(10.5, c: M.inkSoft)),
                  Text('₹700', style: M.t(20, w: FontWeight.w600)),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [M.plum, M.plum2]),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                          color: M.plum.withValues(alpha: .35),
                          blurRadius: 16,
                          offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Text(
                      'Confirm · ${_days[_day].$1}, ${_slots[_slot].$1} ${_slots[_slot].$2}',
                      style: M.t(13.5, w: FontWeight.w600, c: Colors.white)),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _glass(IconData i) => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(13)),
        child: Icon(i, color: Colors.white, size: 20),
      );
}

// ─────────────────────────────────────────────────────────────
// Pharmacy cart — quantity steppers and live totals
// ─────────────────────────────────────────────────────────────
class MedNuPharmacy extends StatefulWidget {
  const MedNuPharmacy({super.key});

  @override
  State<MedNuPharmacy> createState() => _MedNuPharmacyState();
}

class _MedNuPharmacyState extends State<MedNuPharmacy> {
  final _qty = [2, 1, 1];
  static const _items = [
    ('Metformin 500mg', 'Strip of 15 · Sun Pharma', 42, Icons.medication_rounded, [Color(0xFF66BB6A), Color(0xFF2E7D32)]),
    ('Atorvastatin 10mg', 'Strip of 10 · Cipla', 118, Icons.medication_liquid_rounded, [Color(0xFF5C6BC0), Color(0xFF3949AB)]),
    ('Vitamin D3 60K', 'Capsule · 4 pack', 96, Icons.science_rounded, [Color(0xFFFFA726), Color(0xFFE65100)]),
  ];

  int get _total {
    var t = 0;
    for (var i = 0; i < _items.length; i++) {
      t += _items[i].$3 * _qty[i];
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {
    final saved = (_total * .15).round();
    return ColoredBox(
      color: M.bg,
      child: Stack(children: [
        _scroll([
          const SizedBox(height: _top + 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: M.lift),
                child: const Icon(Icons.arrow_back_rounded, size: 21),
              ),
              const SizedBox(width: 14),
              Text('Your cart', style: M.t(19, w: FontWeight.w600)),
              const Spacer(),
              Every(
                const Duration(seconds: 1),
                (_, i) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE3F4EA),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const Icon(Icons.bolt_rounded, size: 14, color: M.good),
                    Text(' ${27 - (i ~/ 4) % 6} min',
                        style: M.t(11, w: FontWeight.w600, c: M.good)),
                  ]),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [M.plumSoft, Color(0xFFFCE7D3)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(children: [
                const Icon(Icons.description_rounded, color: M.plum),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Prescription verified',
                          style: M.t(13, w: FontWeight.w600)),
                      Text('Dr. Kapoor · 02 Oct',
                          style: M.t(11, c: M.inkSoft)),
                    ],
                  ),
                ),
                const Icon(Icons.verified_rounded, color: M.good, size: 22),
              ]),
            ),
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < _items.length; i++)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: M.lift),
                child: Row(children: [
                  GlyphTile(_items[i].$4, _items[i].$5, size: 50),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_items[i].$1, style: M.t(13.5, w: FontWeight.w600)),
                        Text(_items[i].$2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: M.t(10.5, c: M.inkSoft)),
                        const SizedBox(height: 4),
                        Text('₹${_items[i].$3 * _qty[i]}',
                            style: M.t(14, w: FontWeight.w600, c: M.plum)),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: M.plumSoft,
                        borderRadius: BorderRadius.circular(14)),
                    child: Row(children: [
                      _step(Icons.remove_rounded,
                          () => setState(() => _qty[i] = math.max(1, _qty[i] - 1))),
                      SizedBox(
                        width: 22,
                        child: Text('${_qty[i]}',
                            textAlign: TextAlign.center,
                            style: M.t(13, w: FontWeight.w600)),
                      ),
                      _step(Icons.add_rounded,
                          () => setState(() => _qty[i] = math.min(9, _qty[i] + 1))),
                    ]),
                  ),
                ]),
              ),
            ),
        ]),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                    color: M.plum.withValues(alpha: .1),
                    blurRadius: 24,
                    offset: const Offset(0, -8)),
              ],
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(children: [
                Text('Subtotal', style: M.t(12.5, c: M.inkSoft)),
                const Spacer(),
                Text('₹$_total', style: M.t(12.5, w: FontWeight.w500)),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                Text('MEDNU15 applied', style: M.t(12.5, c: M.good)),
                const Spacer(),
                Text('−₹$saved', style: M.t(12.5, w: FontWeight.w500, c: M.good)),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                Text('Delivery', style: M.t(12.5, c: M.inkSoft)),
                const Spacer(),
                Text('Free', style: M.t(12.5, w: FontWeight.w500)),
              ]),
              const Divider(height: 22, color: M.border),
              Row(children: [
                Text('Total', style: M.t(15, w: FontWeight.w600)),
                const Spacer(),
                Text('₹${_total - saved}', style: M.t(20, w: FontWeight.w600)),
              ]),
              const SizedBox(height: 14),
              Container(
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [M.plum, M.plum2]),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text('Pay with UPI',
                    style: M.t(14, w: FontWeight.w600, c: Colors.white)),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _step(IconData i, VoidCallback f) => GestureDetector(
        onTap: f,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
            width: 32, height: 32, child: Icon(i, size: 17, color: M.plum)),
      );
}

// ─────────────────────────────────────────────────────────────
// Health dashboard — live ECG trace, BPM and tap-to-log water
// ─────────────────────────────────────────────────────────────
class MedNuHealth extends StatefulWidget {
  const MedNuHealth({super.key});

  @override
  State<MedNuHealth> createState() => _MedNuHealthState();
}

class _MedNuHealthState extends State<MedNuHealth>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 3))
        ..repeat();
  int _water = 5;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: M.bg,
      child: Column(children: [
        Expanded(
          child: _scroll([
            const SizedBox(height: _top + 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Health dashboard', style: M.t(22, w: FontWeight.w600)),
                  Text('Everything synced · just now',
                      style: M.t(11.5, c: M.inkSoft)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [M.plum, M.plumDeep],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                            color: M.plum.withValues(alpha: .3),
                            blurRadius: 24,
                            offset: const Offset(0, 12)),
                      ],
                    ),
                    child: Column(children: [
                      Row(children: [
                        const Icon(Icons.favorite_rounded,
                            color: Color(0xFFFF6B7A), size: 18),
                        const SizedBox(width: 8),
                        Text('Heart rate',
                            style: M.t(12.5, c: const Color(0xFFE0C6DB))),
                        const Spacer(),
                        Every(
                          const Duration(seconds: 1),
                          (_, i) => Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${72 + [0, 1, 2, 1, 0, -1, -2, -1][i % 8]}',
                                  style: M.t(30,
                                      w: FontWeight.w600,
                                      c: Colors.white,
                                      h: 1)),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, bottom: 3),
                                child: Text('bpm',
                                    style: M.t(11,
                                        c: const Color(0xFFE0C6DB))),
                              ),
                            ],
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 92,
                        width: double.infinity,
                        child: AnimatedBuilder(
                          animation: _c,
                          builder: (_, _) => CustomPaint(
                              painter: _EcgTrace(_c.value)),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(
                      child: _tile(Icons.directions_walk_rounded, 'Steps',
                          '7,420', '/ 10,000', const Color(0xFF42A5F5), .74),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _water = _water >= 8 ? 0 : _water + 1),
                        child: _tile(Icons.water_drop_rounded, 'Water',
                            '$_water', '/ 8 glasses', const Color(0xFF26C6DA),
                            _water / 8),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: _tile(Icons.bedtime_rounded, 'Sleep', '7h 12m',
                          '/ 8h', M.orchid, .9),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _tile(Icons.air_rounded, 'SpO₂', '98%',
                          'normal', M.good, .98),
                    ),
                  ]),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: M.lift),
                    child: Row(children: [
                      const GlyphTile(Icons.alarm_rounded,
                          [Color(0xFFFFA726), Color(0xFFE65100)],
                          size: 44),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Metformin 500mg',
                                style: M.t(13.5, w: FontWeight.w600)),
                            Text('After dinner · 8:30 PM',
                                style: M.t(11, c: M.inkSoft)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                            color: M.plum,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text('Take',
                            style: M.t(11.5,
                                w: FontWeight.w600, c: Colors.white)),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ]),
        ),
        const BottomNav(index: 2),
      ]),
    );
  }

  Widget _tile(IconData i, String label, String value, String sub, Color c,
          double p) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: M.lift),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: c.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(i, size: 17, color: c),
            ),
            const SizedBox(width: 8),
            Text(label, style: M.t(11.5, c: M.inkSoft)),
          ]),
          const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(value, style: M.t(19, w: FontWeight.w600, h: 1)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: M.t(10, c: M.hint)),
            ),
          ]),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: p.clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: c.withValues(alpha: .15),
              valueColor: AlwaysStoppedAnimation(c),
            ),
          ),
        ]),
      );
}

class _EcgTrace extends CustomPainter {
  _EcgTrace(this.t);
  final double t;

  static double _g(double u, double mu, double sig) =>
      math.exp(-math.pow((u - mu) / sig, 2).toDouble());

  static double _wave(double u) =>
      .55 -
      .07 * _g(u, .14, .03) +
      .08 * _g(u, .30, .008) -
      .46 * _g(u, .34, .008) +
      .16 * _g(u, .38, .010) -
      .12 * _g(u, .62, .045);

  @override
  void paint(Canvas canvas, Size s) {
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: .06)
      ..strokeWidth = 1;
    for (var x = 0.0; x < s.width; x += 22) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), grid);
    }
    final path = Path();
    for (var x = 0.0; x <= s.width; x += 2) {
      final u = ((x / s.width) * 2 + t) % 1.0;
      final y = _wave(u) * s.height;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final rect = Offset.zero & s;
    canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(colors: [
            const Color(0xFFFF6B7A).withValues(alpha: 0),
            const Color(0xFFFF6B7A),
            const Color(0xFFFF6B7A),
          ], stops: const [0, .25, 1]).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..strokeJoin = StrokeJoin.round);
  }

  @override
  bool shouldRepaint(covariant _EcgTrace old) => old.t != t;
}
