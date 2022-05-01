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
    return _RenderCustomBox(
      color: color,
      flex: flex,
    );
  }
}

class _RenderCustomBox extends RenderBox {
  _RenderCustomBox({required Color color, required int flex})
      : _color = color,
        _flex = flex;

  int get flex => _flex;
  final int _flex;

  Color get color => _color;
  final Color _color;

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
