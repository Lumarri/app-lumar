import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets.dart';

/// Prefers a transparent PNG with the same name when supplied later.
class PoseImage extends StatefulWidget {
  const PoseImage({
    super.key,
    required this.asset,
    this.label,
    this.small = false,
  });
  final String asset;
  final String? label;
  final bool small;
  @override
  State<PoseImage> createState() => _PoseImageState();
}

class _PoseImageState extends State<PoseImage> {
  static Future<AssetManifest>? _manifest;
  late Future<String> _asset;
  @override
  void initState() {
    super.initState();
    _asset = _resolve();
  }

  @override
  void didUpdateWidget(PoseImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset != widget.asset) _asset = _resolve();
  }

  Future<String> _resolve() async {
    final requested = widget.asset;
    if (requested.endsWith('.png')) return requested;
    final png = requested.replaceFirst(RegExp(r'\.[^.]+$'), '.png');
    try {
      final manifest = await (_manifest ??= AssetManifest.loadFromAssetBundle(
        rootBundle,
      ));
      return manifest.listAssets().contains(png) ? png : requested;
    } catch (_) {
      return requested;
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<String>(
    future: _asset,
    builder: (context, snapshot) => Image.asset(
      snapshot.data ?? widget.asset,
      fit: BoxFit.contain,
      cacheWidth: widget.small ? 180 : 800,
      semanticLabel: widget.label,
      excludeFromSemantics: widget.label == null,
      errorBuilder: (_, _, _) =>
          const Icon(Icons.person_outline_rounded, color: violet),
    ),
  );
}

class TutorOverlay extends StatelessWidget {
  const TutorOverlay({
    super.key,
    required this.asset,
    required this.label,
    required this.accent,
    required this.animationToken,
  });
  final String asset, label, animationToken;
  final Color accent;
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: TweenAnimationBuilder<double>(
      key: ValueKey(animationToken),
      tween: Tween(begin: 0, end: 1),
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, (1 - value) * 12),
        child: Transform.rotate(angle: (1 - value) * -.035, child: child),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 1,
            left: 18,
            right: 18,
            height: 18,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: RadialGradient(
                  colors: [accent.withValues(alpha: .22), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: PoseImage(asset: asset, label: label),
          ),
        ],
      ),
    ),
  );
}
