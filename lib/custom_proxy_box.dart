import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomProxyBox extends SingleChildRenderObjectWidget {
  const CustomProxyBox({Key? key, required Widget child})
      : super(key: key, child: child);
  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomProxyBox();
  }
}

class RenderCustomProxyBox extends RenderProxyBox {
  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    canvas.saveLayer(offset & size, Paint()..blendMode = BlendMode.hardLight);

    context.paintChild(child!, offset);
    canvas.restore();
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return false;
  }
}
