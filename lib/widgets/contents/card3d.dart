import 'package:flutter/material.dart';

import 'package:mexi_canje/utils/constants.dart';
import 'package:smooth_corner/smooth_corner.dart';

class Card3D extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final double rotationXFactor;
  final double rotationYFactor;
  final double lightSourceFactor;
  final Color baseColor;
  final BorderRadius borderRadius;

  const Card3D({
    super.key,
    required this.child,
    this.width = 300.0,
    this.height = 200.0,
    this.rotationXFactor = 0.005,
    this.rotationYFactor = 0.005,
    this.lightSourceFactor = 150.0,
    this.baseColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
  });

  @override
  _Card3DState createState() => _Card3DState();
}

class _Card3DState extends State<Card3D> {
  final ValueNotifier<Offset> _pointerPosition = ValueNotifier(Offset.zero);

  void _onPointerMove(PointerEvent event) {
    _pointerPosition.value = event.localPosition;
  }

  void _onPointerExit(PointerEvent event) {
    _pointerPosition.value = Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onPointerMove,
      onExit: _onPointerExit,
      child: GestureDetector(
        // Wrap with GestureDetector for touch support
        onPanUpdate: (details) {
          // Use onPanUpdate for touch drag
          _pointerPosition.value = details.localPosition;
        },
        onPanEnd: (details) {
          // Reset on touch end
          _pointerPosition.value = Offset.zero;
        },
        behavior: HitTestBehavior
            .opaque, // Make GestureDetector take up space for touch events
        child: Center(
          child: ValueListenableBuilder<Offset>(
            valueListenable: _pointerPosition,
            builder: (context, pointerPosition, _) {
              final centerX = widget.width / 4;
              final centerY = widget.height / 2;
              final offsetX =
                  pointerPosition.dx != 0 ? pointerPosition.dx - centerX : 0.0;
              final offsetY =
                  pointerPosition.dy != 0 ? pointerPosition.dy - centerY : 0.0;

              final rotationX = offsetY * widget.rotationXFactor;
              final rotationY = offsetX * widget.rotationYFactor;

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(-rotationX)
                  ..rotateY(rotationY),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: widget.baseColor,
                    shadows: AppStyles.getShadows,
                    shape: SmoothRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      smoothness: 0.6,
                    ),
                  ),
                  child: ShaderMask(
                    blendMode: BlendMode.overlay,
                    shaderCallback: (bounds) {
                      final lightX = centerX + offsetX;
                      final lightY = centerY + offsetY;

                      return LinearGradient(
                        begin: Alignment(
                            (lightX - centerX) / widget.lightSourceFactor,
                            (lightY - centerY) / widget.lightSourceFactor),
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.transparent
                        ],
                        stops: const [0.0, 1.0],
                      ).createShader(bounds);
                    },
                    child: Container(
                      child: widget.child,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
