import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CustomColumn extends MultiChildRenderObjectWidget {
  CustomColumn({List<Widget> children = const [], Key? key})
      : super(key: key, children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCustomColumn();
  }
}

/// The [CustomColumn] widget is a [Column] that takes a list of children
class CustomColumnParentData extends ContainerBoxParentData<RenderBox> {
  int? flex;
}

class _RenderCustomColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomColumnParentData> {
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! CustomColumnParentData) {
      child.parentData = CustomColumnParentData();
    }
  }

  Size _preformLayout(
      {required BoxConstraints constraints, required bool dry}) {
    double width = 0, height = 0;
    int totalFlex = 0;
    RenderBox? lastFlexchild;
    // layout all the non-flex children
    RenderBox? child = firstChild;
    while (child != null) {
      final parentData = child.parentData as CustomColumnParentData;
      final flex = parentData.flex ?? 0;

      if (flex > 0) {
        totalFlex += flex;
        lastFlexchild = child;
      } else {
        late final Size childSize;
        if (!dry) {
          child.layout(BoxConstraints(maxWidth: constraints.maxWidth),
              parentUsesSize: true);
          childSize = child.size;
        } else {
          childSize = child
              .getDryLayout(BoxConstraints(maxWidth: constraints.maxWidth));
        }
        height += childSize.height;
        width = max(width, childSize.width);
      }
      child = parentData.nextSibling;
    }

    // layout the flex children
    child = lastFlexchild;
    final flexHeight = (constraints.maxHeight - height) / totalFlex;
    while (child != null) {
      final parentData = child.parentData as CustomColumnParentData;
      final flex = parentData.flex ?? 0;

      if (flex > 0) {
        final childHeight = flexHeight * flex;
        late final Size childSize;
        if (!dry) {
          child.layout(
              BoxConstraints(
                  minHeight: childHeight,
                  maxHeight: childHeight,
                  maxWidth: constraints.maxWidth),
              parentUsesSize: true);
          childSize = child.size;
        } else {
          childSize = child.getDryLayout(BoxConstraints(
              minHeight: childHeight,
              maxHeight: childHeight,
              maxWidth: constraints.maxWidth));
        }
        height += childSize.height;
        width = max(width, childSize.width);
      }

      child = parentData.previousSibling;
    }

    return Size(width, height);
  }

  @override
  void performLayout() {
    size = _preformLayout(constraints: constraints, dry: false);

    // positioning the children
    RenderBox? child = firstChild;
    Offset childOffset = const Offset(0, 0);
    while (child != null) {
      final parentData = child.parentData as CustomColumnParentData;

      parentData.offset = Offset(0, childOffset.dy);
      childOffset += Offset(0, child.size.height);

      child = parentData.nextSibling;
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _preformLayout(constraints: constraints, dry: true);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
