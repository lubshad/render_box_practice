import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:render_object/custom_column.dart';

class CustomBox extends LeafRenderObjectWidget {
  final int flex;
  final Color color;
  final double rotation;
  final VoidCallback? onTap;

  const CustomBox({
    Key? key,
    this.flex = 0,
    required this.color,
    this.rotation = 0,
    this.onTap,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomBox(
      color: color,
      flex: flex,
      rotation: rotation,
      onTap: onTap,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCustomBox renderObject) {
    renderObject
      ..color = color
      ..flex = flex
      ..rotation = rotation
      ..onTap = onTap;
  }
}

class RenderCustomBox extends RenderBox {
  RenderCustomBox(
      {required Color color,
      required int flex,
      required double rotation,
      required VoidCallback? onTap})
      : _color = color,
        _flex = flex,
        _rotation = rotation,
        _onTap = onTap;

  late final TapGestureRecognizer _tapGestureRecognizer;

  set onTap(VoidCallback? value) {
    if (onTap == value) return;
    _onTap = value;
    _tapGestureRecognizer.onTap = onTap;
  }

  VoidCallback? _onTap;
  VoidCallback? get onTap => _onTap;

  set rotation(double value) {
    if (value != _rotation) {
      _rotation = value;
      markNeedsPaint();
    }
  }

  double _rotation;
  double get rotation => _rotation;

  int get flex => _flex;
  int _flex;
  set flex(int value) {
    if (_flex == value) return;
    assert(value >= 0);
    _flex = value;
    parentData?.flex = value;
    markParentNeedsLayout();
  }

  Color get color => _color;
  Color _color;
  set color(Color color) {
    if (color == _color) return;
    _color = color;
    markNeedsPaint();
  }

  @override
  CustomColumnParentData? get parentData {
    if (super.parentData == null) return null;
    assert(super.parentData is CustomColumnParentData,
        "$CustomBox can only be used direct child of $CustomColumn");
    return super.parentData as CustomColumnParentData;
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);

    parentData?.flex = flex;
    _tapGestureRecognizer = TapGestureRecognizer(debugOwner: this)
      ..onTap = onTap;
  }

  @override
  void detach() {
    _tapGestureRecognizer.dispose();
    super.detach();
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  bool hitTestSelf(Offset position) {
    return size.contains(position);
  }

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _tapGestureRecognizer.addPointer(event);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.drawRect(offset & size, Paint()..color = color);

    double smallestSide = size.shortestSide / (3 - sin(rotation));

    canvas.save();

    canvas.translate(offset.dx + size.width / 2, offset.dy + size.height / 2);
    canvas.rotate(rotation);
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset.zero, width: smallestSide, height: smallestSide),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..color = Colors.white);

    canvas.restore();
  }
}
