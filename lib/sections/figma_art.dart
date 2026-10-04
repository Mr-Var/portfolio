import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Abstract court lines — decorative, not a preview of the file.
class CourtPainter extends CustomPainter {
  const CourtPainter();

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFF1F7A4D));
    final line = Paint()
      ..color = Colors.white.withValues(alpha: .85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final r = Rect.fromLTWH(s.width * .08, s.height * .1, s.width * .84, s.height * .8);
    canvas.drawRect(r, line);
    canvas.drawLine(Offset(r.center.dx, r.top), Offset(r.center.dx, r.bottom), line);
    canvas.drawCircle(r.center, s.height * .14, line);
    canvas.drawRect(Rect.fromLTWH(r.left, r.center.dy - s.height * .2, s.width * .14, s.height * .4), line);
    canvas.drawRect(Rect.fromLTWH(r.right - s.width * .14, r.center.dy - s.height * .2, s.width * .14, s.height * .4), line);
    canvas.drawCircle(r.center, 7, Paint()..color = const Color(0xFFFFD83D));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

/// Abstract streaming-UI motif — decorative, not a preview of the file.
class RangaPainter extends CustomPainter {
  const RangaPainter();

  @override
  void paint(Canvas canvas, Size s) {
    final rect = Offset.zero & s;
    canvas.drawRect(
        rect,
        Paint()
          ..shader = const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3B1D5A), Color(0xFFB8432F)])
              .createShader(rect));
    final glow = Offset(s.width * .5, s.height * .42);
    canvas.drawCircle(
        glow,
        s.height * .3,
        Paint()
          ..shader = RadialGradient(colors: [
            const Color(0xFFFFB36B).withValues(alpha: .9),
            const Color(0xFFFFB36B).withValues(alpha: 0)
          ]).createShader(Rect.fromCircle(center: glow, radius: s.height * .3)));
    // play button
    canvas.drawCircle(glow, 38, Paint()..color = Colors.white.withValues(alpha: .95));
    canvas.drawPath(
        Path()
          ..moveTo(glow.dx - 10, glow.dy - 16)
          ..lineTo(glow.dx + 18, glow.dy)
          ..lineTo(glow.dx - 10, glow.dy + 16)
          ..close(),
        Paint()..color = const Color(0xFF3B1D5A));
    // content rail
    for (var i = 0; i < 5; i++) {
      final r = RRect.fromRectAndRadius(
          Rect.fromLTWH(s.width * .06 + i * s.width * .19, s.height * .72,
              s.width * .16, s.height * .2),
          const Radius.circular(10));
      canvas.drawRRect(r, Paint()..color = Colors.white.withValues(alpha: .14 + i * .03));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

/// Shows every PNG/JPG found in [folder] as a draggable rail of real design
/// frames; falls back to the decorative painter until images are added.
class FigmaArt extends StatelessWidget {
  const FigmaArt({super.key, required this.folder, required this.fallback, this.height = 380});
  final String folder;
  final double height;
  final CustomPainter fallback;

  static Future<List<String>> _find(String folder) async {
    final m = await AssetManifest.loadFromAssetBundle(rootBundle);
    final all = m.listAssets().where((a) {
      final l = a.toLowerCase();
      return a.startsWith(folder) &&
          (l.endsWith('.png') || l.endsWith('.jpg') || l.endsWith('.jpeg') || l.endsWith('.webp'));
    }).toList()
      ..sort();
    return all;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _find(folder),
      builder: (context, snap) {
        final files = snap.data ?? const <String>[];
        if (files.isEmpty) {
          return AspectRatio(
            aspectRatio: 1.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: CustomPaint(painter: fallback),
            ),
          );
        }
        return SizedBox(
          height: height,
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
              itemCount: files.length,
              separatorBuilder: (_, _) => const SizedBox(width: 18),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (_) => Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: const EdgeInsets.all(24),
                    child: InteractiveViewer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(files[i], fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(files[i],
                        height: height, fit: BoxFit.fitHeight,
                        filterQuality: FilterQuality.medium),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Abstract CRM-dashboard motif — decorative, not a preview of the file.
class MeridianPainter extends CustomPainter {
  const MeridianPainter();

  @override
  void paint(Canvas canvas, Size s) {
    final rect = Offset.zero & s;
    canvas.drawRect(
        rect,
        Paint()
          ..shader = const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0B2A4A), Color(0xFF1B5FA8)])
              .createShader(rect));
    final card = Paint()..color = Colors.white.withValues(alpha: .1);
    final pad = s.width * .07;
    // sidebar
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(pad, pad, s.width * .16, s.height - pad * 2),
            const Radius.circular(14)),
        card);
    // KPI cards
    final kx = pad + s.width * .2;
    final kw = (s.width - kx - pad - 24) / 3;
    for (var i = 0; i < 3; i++) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(kx + i * (kw + 12), pad, kw, s.height * .2),
              const Radius.circular(12)),
          card);
    }
    // pipeline bars
    final by = pad + s.height * .26;
    final bh = s.height - by - pad;
    final bw = (s.width - kx - pad) / 7;
    const hs = [.45, .7, .55, .9, .65, .8, .5];
    for (var i = 0; i < hs.length; i++) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(kx + i * bw + 4, by + bh * (1 - hs[i]), bw - 8, bh * hs[i]),
              const Radius.circular(8)),
          Paint()
            ..color = (i == 3 ? const Color(0xFFF9943B) : Colors.white)
                .withValues(alpha: i == 3 ? .95 : .22));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
