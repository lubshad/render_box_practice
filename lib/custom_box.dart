import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:render_object/custom_column.dart';

class CustomBox extends LeafRenderObjectWidget {
  final int flex;
  final Color color;

  const CustomBox({Key? key, this.flex = 0, required this.color})
      : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomBox(
      color: color,
      flex: flex,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCustomBox renderObject) {
    renderObject
      ..color = color
      ..flex = flex;
  }
}

class RenderCustomBox extends RenderBox {
  RenderCustomBox({required Color color, required int flex})
      : _color = color,
        _flex = flex;

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
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }
}
