
import 'package:flutter/material.dart';



// ═════════════════════════════════════════════════════════════
// 1 · The live mednu.in website — real full-page capture
// ═════════════════════════════════════════════════════════════
const double kRealSiteH = 6596;

class RealMedNuSite extends StatelessWidget {
  const RealMedNuSite({super.key});

  @override
  Widget build(BuildContext context) => Image.asset(
        'assets/real/desktop_full.jpg',
        width: 1280,
        height: kRealSiteH,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.medium,
      );
}

const double kSkyfitSiteH = 1196;

class RealSkyfitSite extends StatelessWidget {
  const RealSkyfitSite({super.key});

  @override
  Widget build(BuildContext context) => Image.asset(
        'assets/real/skyfit_desktop.jpg',
        width: 1280,
        height: kSkyfitSiteH,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.medium,
      );
}

/// Real mobile capture of mednu.in that scrolls itself inside a phone.
class RealMobileSite extends StatefulWidget {
  const RealMobileSite({super.key});

  @override
  State<RealMobileSite> createState() => _RealMobileSiteState();
}

class _RealMobileSiteState extends State<RealMobileSite>
    with SingleTickerProviderStateMixin {
  // 780x6752 capture shown at 390 logical px wide.
  static const _h = 6752 / 2;
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 70))
        ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  // Space reserved for the phone's status bar / island.
  static const _top = 54.0;

  @override
  Widget build(BuildContext context) => Column(children: [
        const ColoredBox(color: Colors.white, child: SizedBox(height: _top, width: double.infinity)),
        Expanded(
          child: ClipRect(
            child: AnimatedBuilder(
              animation: _c,
              builder: (_, child) => Transform.translate(
                offset: Offset(
                    0, -(_h - (844 - _top)) * Curves.easeInOut.transform(_c.value)),
                child: child,
              ),
              child: OverflowBox(
                alignment: Alignment.topLeft,
                minHeight: _h,
                maxHeight: _h,
                minWidth: 390,
                maxWidth: 390,
                child: Image.asset('assets/real/mobile_full.jpg',
                    width: 390, height: _h, fit: BoxFit.fill),
              ),
            ),
          ),
        ),
      ]);
}
