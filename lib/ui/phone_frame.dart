import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Logical canvas every showcased screen is designed on (iPhone 14-ish).
const Size kScreen = Size(390, 844);

/// Renders [child] on a fixed 390x844 canvas inside a device bezel and scales
/// the whole thing to [width]. Layout inside is therefore identical at any
/// preview size — no reflow, no overflow surprises.
class PhoneFrame extends StatefulWidget {
  const PhoneFrame({
    super.key,
    required this.child,
    this.width = 280,
    this.dark = false,
    this.statusColor,
  });

  final Widget child;
  final double width;
  final bool dark;

  /// Status-bar glyph colour; defaults from [dark].
  final Color? statusColor;

  @override
  State<PhoneFrame> createState() => _PhoneFrameState();
}

class _PhoneFrameState extends State<PhoneFrame> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    const bezel = 10.0;
    final scale = widget.width / (kScreen.width + bezel * 2);
    final h = (kScreen.height + bezel * 2) * scale;
    final glyph = widget.statusColor ??
        (widget.dark ? Colors.white : const Color(0xFF111111));

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hover ? -10 : 0, 0),
        width: widget.width,
        height: h,
        child: FittedBox(
          fit: BoxFit.fill,
          child: Container(
            width: kScreen.width + bezel * 2,
            height: kScreen.height + bezel * 2,
            padding: const EdgeInsets.all(bezel),
            decoration: BoxDecoration(
              color: const Color(0xFF0E0E10),
              borderRadius: BorderRadius.circular(58),
              border: Border.all(color: const Color(0xFF3A3A40), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _hover ? .38 : .24),
                  blurRadius: _hover ? 60 : 36,
                  offset: Offset(0, _hover ? 34 : 20),
                  spreadRadius: -8,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(48),
              child: SizedBox(
                width: kScreen.width,
                height: kScreen.height,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: MediaQuery(
                        data: const MediaQueryData(
                          size: kScreen,
                          padding: EdgeInsets.only(top: 54, bottom: 30),
                        ),
                        child: widget.child,
                      ),
                    ),
                    // Status bar
                    Positioned(
                      top: 18,
                      left: 34,
                      right: 30,
                      child: IgnorePointer(
                        child: Row(
                          children: [
                            Text('9:41',
                                style: TextStyle(
                                    color: glyph,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none)),
                            const Spacer(),
                            Icon(Icons.signal_cellular_alt_rounded,
                                size: 16, color: glyph),
                            const SizedBox(width: 5),
                            Icon(Icons.wifi_rounded, size: 16, color: glyph),
                            const SizedBox(width: 5),
                            Icon(Icons.battery_full_rounded,
                                size: 19, color: glyph),
                          ],
                        ),
                      ),
                    ),
                    // Dynamic island
                    Positioned(
                      top: 11,
                      left: (kScreen.width - 100) / 2,
                      child: Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    // Home indicator
                    Positioned(
                      bottom: 8,
                      left: (kScreen.width - 128) / 2,
                      child: IgnorePointer(
                        child: Container(
                          width: 128,
                          height: 5,
                          decoration: BoxDecoration(
                            color: glyph.withValues(alpha: .85),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontally draggable rail of phones (mouse-drag enabled for web/desktop).
class PhoneRail extends StatelessWidget {
  const PhoneRail({
    super.key,
    required this.children,
    this.phoneWidth = 290,
    this.gap = 36,
    this.extraHeight = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
  });

  final List<Widget> children;
  final double phoneWidth;
  final double gap;

  /// Space below each phone for captions.
  final double extraHeight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final h = (kScreen.height + 20) * phoneWidth / (kScreen.width + 20) +
        padding.vertical +
        extraHeight;
    return SizedBox(
      height: h,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
          scrollbars: false,
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: padding,
          clipBehavior: Clip.none,
          itemCount: children.length,
          separatorBuilder: (_, _) => SizedBox(width: gap),
          itemBuilder: (_, i) => children[i],
        ),
      ),
    );
  }
}
