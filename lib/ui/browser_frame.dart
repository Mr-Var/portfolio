import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const double kSiteWidth = 1280;
const double kViewportHeight = 800;
const double _chromeHeight = 46;

/// A desktop browser window showing a 1280px-wide website. When the page is
/// taller than the viewport it scrolls itself slowly (pauses on hover), and
/// tapping opens it full-size in a scrollable viewer.
class BrowserFrame extends StatefulWidget {
  const BrowserFrame({
    super.key,
    required this.url,
    required this.siteHeight,
    required this.site,
    required this.width,
    this.dark = false,
  });

  final String url;
  final double siteHeight;
  final Widget site;
  final double width;
  final bool dark;

  @override
  State<BrowserFrame> createState() => _BrowserFrameState();
}

class _BrowserFrameState extends State<BrowserFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.siteHeight * 8).round()));
  bool _hover = false;

  bool get _scrolls => widget.siteHeight > kViewportHeight + 40;

  @override
  void initState() {
    super.initState();
    if (_scrolls) _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _setHover(bool h) {
    setState(() => _hover = h);
    if (!_scrolls) return;
    h ? _c.stop() : _c.repeat(reverse: true, min: 0, max: 1);
  }

  void _open() {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: .86),
      pageBuilder: (_, _, _) => _SiteViewer(
          url: widget.url, height: widget.siteHeight, site: widget.site),
      transitionsBuilder: (_, a, _, child) =>
          FadeTransition(opacity: a, child: child),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.width / kSiteWidth;
    final h = (kViewportHeight + _chromeHeight) * scale;
    final bar = widget.dark ? const Color(0xFF1C1C22) : const Color(0xFFEDEAF0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTap: _open,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
          width: widget.width,
          height: h,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Container(
              width: kSiteWidth,
              height: kViewportHeight + _chromeHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: _hover ? .35 : .22),
                      blurRadius: _hover ? 70 : 44,
                      offset: Offset(0, _hover ? 36 : 24),
                      spreadRadius: -10),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Column(children: [
                  _Chrome(url: widget.url, color: bar, dark: widget.dark),
                  Expanded(
                    child: ClipRect(
                      child: AnimatedBuilder(
                        animation: _c,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(
                              0,
                              -(widget.siteHeight - kViewportHeight) *
                                  Curves.easeInOut.transform(_c.value)),
                          child: child,
                        ),
                        child: OverflowBox(
                          alignment: Alignment.topLeft,
                          minHeight: widget.siteHeight,
                          maxHeight: widget.siteHeight,
                          minWidth: kSiteWidth,
                          maxWidth: kSiteWidth,
                          child: IgnorePointer(child: widget.site),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Chrome extends StatelessWidget {
  const _Chrome({required this.url, required this.color, required this.dark});
  final String url;
  final Color color;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Colors.white70 : const Color(0xFF55505C);
    return Container(
      height: _chromeHeight,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(children: [
        for (final c in const [Color(0xFFFF5F57), Color(0xFFFEBC2E), Color(0xFF28C840)])
          Container(
            width: 13,
            height: 13,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
          ),
        const SizedBox(width: 22),
        Icon(Icons.arrow_back_rounded, size: 18, color: fg),
        const SizedBox(width: 12),
        Icon(Icons.arrow_forward_rounded, size: 18, color: fg.withValues(alpha: .4)),
        const SizedBox(width: 12),
        Icon(Icons.refresh_rounded, size: 18, color: fg),
        const SizedBox(width: 18),
        Expanded(
          child: Container(
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: dark ? Colors.white10 : Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.lock_rounded, size: 12, color: fg),
              const SizedBox(width: 6),
              Text(url,
                  style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: fg,
                      decoration: TextDecoration.none)),
            ]),
          ),
        ),
        const SizedBox(width: 60),
      ]),
    );
  }
}

class _SiteViewer extends StatelessWidget {
  const _SiteViewer(
      {required this.url, required this.height, required this.site});
  final String url;
  final double height;
  final Widget site;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1480),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: ColoredBox(
                    color: Colors.white,
                    child: Column(children: [
                      _Chrome(url: url, color: const Color(0xFFEDEAF0), dark: false),
                      Expanded(
                        child: SingleChildScrollView(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                                width: kSiteWidth, height: height, child: site),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 16,
            child: IconButton.filled(
              style: IconButton.styleFrom(
                  backgroundColor: Colors.white, foregroundColor: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        ]),
      ),
    );
  }
}
