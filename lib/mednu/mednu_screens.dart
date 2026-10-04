import 'package:flutter/material.dart';

import 'mednu_kit.dart';

const _top = 54.0;

Widget _scroll(List<Widget> children, {EdgeInsets? pad}) =>
    SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: pad ?? EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );

// ─────────────────────────────────────────────────────────────
// 1 · Patient home
// ─────────────────────────────────────────────────────────────
class MedNuHome extends StatelessWidget {
  const MedNuHome({super.key});

  static const _services = [
    (Icons.emergency_rounded, 'Emergency', [Color(0xFFEF5350), Color(0xFFB71C1C)]),
    (Icons.event_available_rounded, 'Appointment', [Color(0xFF42A5F5), Color(0xFF1565C0)]),
    (Icons.medication_rounded, 'Medicines', [Color(0xFF66BB6A), Color(0xFF2E7D32)]),
    (Icons.biotech_rounded, 'Lab Tests', [Color(0xFF5C6BC0), Color(0xFF3949AB)]),
    (Icons.local_hospital_rounded, 'Ambulance', [Color(0xFFEF5350), Color(0xFF522546)]),
    (Icons.self_improvement_rounded, 'Physio', [Color(0xFF42A5F5), Color(0xFF0D47A1)]),
    (Icons.restaurant_rounded, 'Nutrition', [Color(0xFF9CCC65), Color(0xFF33691E)]),
    (Icons.volunteer_activism_rounded, 'Care Assist', [Color(0xFFFFA726), Color(0xFFE65100)]),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: M.bg,
      child: Column(
        children: [
          Expanded(
            child: _scroll([
              const SizedBox(height: _top + 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                          color: M.plumSoft,
                          borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.place_rounded,
                          color: M.plum, size: 21),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Delivering care to', style: M.t(11, c: M.inkSoft)),
                          Row(children: [
                            Text('Jubilee Hills, Hyderabad',
                                style: M.t(14, w: FontWeight.w600)),
                            const Icon(Icons.keyboard_arrow_down_rounded,
                                size: 18, color: M.plum),
                          ]),
                        ],
                      ),
                    ),
                    Stack(clipBehavior: Clip.none, children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: M.lift),
                        child: const Icon(Icons.notifications_none_rounded,
                            color: M.ink, size: 22),
                      ),
                      Positioned(
                        top: 9,
                        right: 10,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                              color: M.coral,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.6)),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Hero banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 168,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                        colors: [M.plum, M.plum, M.plumDeep],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    boxShadow: [
                      BoxShadow(
                          color: M.plum.withValues(alpha: .35),
                          blurRadius: 28,
                          offset: const Offset(0, 14)),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -40,
                        top: -50,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: M.orchid.withValues(alpha: .22),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -6,
                        bottom: 0,
                        child: Image.asset('assets/mednu/home_hero_doctor_cutout.png',
                            height: 164, fit: BoxFit.contain),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFF5BE49B),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 6),
                                  Every(
                                    const Duration(seconds: 3),
                                    (_, i) => Text(
                                        '${118 + (i * 7) % 15} doctors online',
                                        style: M.t(10.5,
                                            c: const Color(0xFFE8D2E4),
                                            w: FontWeight.w500)),
                                  ),
                                ]),
                                const SizedBox(height: 8),
                                Text('Consult top\nspecialists',
                                    style: M.t(21,
                                        w: FontWeight.w600,
                                        c: Colors.white,
                                        h: 1.2)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 9),
                              decoration: BoxDecoration(
                                  color: M.coral,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Text('Consult now',
                                    style: M.t(12,
                                        w: FontWeight.w600, c: M.plumDeep)),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward_rounded,
                                    size: 15, color: M.plumDeep),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: M.border)),
                  child: Row(children: [
                    const Icon(Icons.search_rounded, color: M.hint, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text('Doctors, medicines, lab tests',
                            style: M.t(13, c: M.hint))),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: M.plumSoft,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.mic_none_rounded,
                          size: 18, color: M.plum),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Text('Our services', style: M.t(16, w: FontWeight.w600)),
                  const Spacer(),
                  Text('See all', style: M.t(12, w: FontWeight.w500, c: M.plum)),
                ]),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 10,
                  childAspectRatio: .78,
                  padding: EdgeInsets.zero,
                  children: [
                    for (final s in _services)
                      Column(children: [
                        GlyphTile(s.$1, s.$3, size: 54),
                        const SizedBox(height: 7),
                        Text(s.$2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: M.t(10.5, w: FontWeight.w500)),
                      ]),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: M.lift),
                  child: Row(children: [
                    const Initials('RK', size: 50, tone: 1),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Every(const Duration(seconds: 1), (_, i) {
                            final left = 8047 - i;
                            String two(int n) => n.toString().padLeft(2, '0');
                            return Text(
                                'STARTS IN ${two(left ~/ 3600)}:${two(left % 3600 ~/ 60)}:${two(left % 60)}',
                                style: M.t(9.5,
                                    w: FontWeight.w600, c: M.coral, ls: .8));
                          }),
                          const SizedBox(height: 2),
                          Text('Dr. Ritika Kapoor',
                              style: M.t(14, w: FontWeight.w600)),
                          Text('Cardiology · Video consult · 5:30 PM',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: M.t(11, c: M.inkSoft)),
                        ],
                      ),
                    ),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                          color: M.plum, borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.videocam_rounded,
                          color: Colors.white, size: 21),
                    ),
                  ]),
                ),
              ),
            ]),
          ),
          const BottomNav(index: 0),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 2 · Find a doctor
// ─────────────────────────────────────────────────────────────
class MedNuFindDoctor extends StatelessWidget {
  const MedNuFindDoctor({super.key});

  static const _docs = [
    ('Dr. Ritika Kapoor', 'Cardiologist', '4.9', '1.2k', '₹700', '12 yrs', 'RK', 0, true),
    ('Dr. Arjun Menon', 'Endocrinologist', '4.8', '860', '₹600', '9 yrs', 'AM', 2, true),
    ('Dr. Sana Qureshi', 'Dermatologist', '4.8', '940', '₹500', '8 yrs', 'SQ', 1, false),
    ('Dr. Vikram Rao', 'General Physician', '4.7', '2.1k', '₹350', '15 yrs', 'VR', 3, true),
  ];

  @override
  Widget build(BuildContext context) {
    const chips = ['All', 'Cardiology', 'Diabetes', 'Skin', 'Women\'s'];
    return ColoredBox(
      color: M.bg,
      child: Column(children: [
        Expanded(
          child: _scroll([
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
                Text('Find your doctor', style: M.t(19, w: FontWeight.w600)),
              ]),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: M.border)),
                child: Row(children: [
                  const Icon(Icons.search_rounded, color: M.hint),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text('Search by name or condition',
                          style: M.t(13, c: M.hint))),
                  const Icon(Icons.tune_rounded, color: M.plum, size: 20),
                ]),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: chips.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == 1 ? M.plum : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: i == 1 ? M.plum : M.border),
                  ),
                  child: Text(chips[i],
                      style: M.t(12,
                          w: FontWeight.w500,
                          c: i == 1 ? Colors.white : M.inkSoft)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            for (final d in _docs)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: M.lift),
                  child: Column(children: [
                    Row(children: [
                      Initials(d.$7, size: 62, tone: d.$8),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.$1, style: M.t(14.5, w: FontWeight.w600)),
                            Text(d.$2, style: M.t(11.5, c: M.inkSoft)),
                            const SizedBox(height: 6),
                            Row(children: [
                              const Icon(Icons.star_rounded,
                                  color: M.coral, size: 15),
                              const SizedBox(width: 3),
                              Text(d.$3,
                                  style: M.t(11.5, w: FontWeight.w600)),
                              Text('  (${d.$4})  ·  ${d.$6}',
                                  style: M.t(11, c: M.inkSoft)),
                            ]),
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                            color: d.$9
                                ? const Color(0xFFE3F4EA)
                                : M.plumSoft,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(d.$9 ? 'Available now' : 'Tomorrow, 10 AM',
                            style: M.t(10.5,
                                w: FontWeight.w600,
                                c: d.$9 ? M.good : M.plum)),
                      ),
                      const Spacer(),
                      Text(d.$5, style: M.t(15, w: FontWeight.w600)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 9),
                        decoration: BoxDecoration(
                            color: M.plum,
                            borderRadius: BorderRadius.circular(12)),
                        child: Text('Book',
                            style: M.t(12,
                                w: FontWeight.w600, c: Colors.white)),
                      ),
                    ]),
                  ]),
                ),
              ),
          ]),
        ),
        const BottomNav(index: 0),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 5 · Partner app — role picker
// ─────────────────────────────────────────────────────────────
class MedNuRolePicker extends StatelessWidget {
  const MedNuRolePicker({super.key});

  static const _roles = [
    (Icons.medical_services_rounded, 'Doctor', 'Consult & prescribe', [Color(0xFF522546), Color(0xFF633058)]),
    (Icons.local_hospital_rounded, 'Ambulance', 'Respond to SOS', [Color(0xFFEF5350), Color(0xFF522546)]),
    (Icons.local_pharmacy_rounded, 'Pharmacy', 'Fulfil orders', [Color(0xFF66BB6A), Color(0xFF2E7D32)]),
    (Icons.biotech_rounded, 'Lab', 'Collect samples', [Color(0xFF5C6BC0), Color(0xFF3949AB)]),
    (Icons.volunteer_activism_rounded, 'Caregiver', 'Home assistance', [Color(0xFFFFA726), Color(0xFFE65100)]),
    (Icons.self_improvement_rounded, 'Physio', 'Rehab sessions', [Color(0xFF42A5F5), Color(0xFF0D47A1)]),
    (Icons.psychology_rounded, 'Counsellor', 'Mental wellness', [Color(0xFFA36BAC), Color(0xFF522546)]),
    (Icons.restaurant_rounded, 'Nutritionist', 'Diet planning', [Color(0xFF9CCC65), Color(0xFF33691E)]),
  ];

  @override
  Widget build(BuildContext context) {
    const selected = 1;
    return ColoredBox(
      color: M.bg,
      child: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: _top + 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Image.asset('assets/mednu/mednu_logo.png', height: 30),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: M.plumSoft,
                        borderRadius: BorderRadius.circular(6)),
                    child: Text('PARTNER',
                        style: M.t(9, w: FontWeight.w600, c: M.plum, ls: 1.2)),
                  ),
                ]),
                const SizedBox(height: 22),
                Text('How will you\nuse MedNU?',
                    style: M.t(28, w: FontWeight.w600, h: 1.15)),
                const SizedBox(height: 8),
                Text('Choose your role. You can add more later\nfrom your profile.',
                    style: M.t(13, c: M.inkSoft, h: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 110),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.32,
              children: [
                for (var i = 0; i < _roles.length; i++)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: i == selected ? M.plumSoft : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                          color: i == selected ? M.plum : M.border,
                          width: i == selected ? 1.6 : 1),
                      boxShadow: i == selected ? M.lift : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          GlyphTile(_roles[i].$1, _roles[i].$4, size: 40),
                          const Spacer(),
                          if (i == selected)
                            const Icon(Icons.check_circle_rounded,
                                color: M.plum, size: 22),
                        ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_roles[i].$2,
                                style: M.t(14, w: FontWeight.w600)),
                            Text(_roles[i].$3,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: M.t(11, c: M.inkSoft)),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ]),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 34),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [M.bg.withValues(alpha: 0), M.bg, M.bg],
              ),
            ),
            child: Container(
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [M.plum, M.plum2]),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: M.plum.withValues(alpha: .35),
                      blurRadius: 18,
                      offset: const Offset(0, 8)),
                ],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Continue as Ambulance',
                    style: M.t(14, w: FontWeight.w600, c: Colors.white)),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 18),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
