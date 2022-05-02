import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CustomColumn extends MultiChildRenderObjectWidget {
  CustomColumn(
      {List<Widget> children = const [],
      Key? key,
      this.alignment = CustomColumnAlignment.center})
      : super(key: key, children: children);

  final CustomColumnAlignment alignment;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomColumn(
      alignment: alignment,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCustomColumn renderObject) {
    renderObject.alignment = alignment;
  }
}

enum CustomColumnAlignment {
  center,
  start,
  end,
}

extension CustomAlignmentExtension on CustomColumnAlignment {
  double getDx(double childWidth, double parentWidth) {
    switch (this) {
      case CustomColumnAlignment.center:
        return (parentWidth - childWidth) / 2;
      case CustomColumnAlignment.start:
        return 0;
      case CustomColumnAlignment.end:
        return parentWidth - childWidth;
    }
  }
}

/// The [CustomColumn] widget is a [Column] that takes a list of children
class CustomColumnParentData extends ContainerBoxParentData<RenderBox> {
  int? flex;
}

class RenderCustomColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomColumnParentData> {
  RenderCustomColumn({required CustomColumnAlignment alignment})
      : _alignment = alignment;

  CustomColumnAlignment get alignment => _alignment;
  CustomColumnAlignment _alignment;
  set alignment(CustomColumnAlignment value) {
    if (_alignment == value) return;
    _alignment = value;
    markNeedsLayout();
  }

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
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    RenderBox? child = firstChild;
    double height = 0;
    while (child != null) {
      final parentData = child.parentData as CustomColumnParentData;

      height += child.getMaxIntrinsicHeight(width);

      child = parentData.nextSibling;
    }
    return height;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    RenderBox? child = firstChild;
    double height = 0;
    while (child != null) {
      final parentData = child.parentData as CustomColumnParentData;

      height += child.getMinIntrinsicHeight(width);

      child = parentData.nextSibling;
    }
    return height;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    RenderBox? child = firstChild;
    double width = 0;
    while (child != null) {
      final parentData = child.parentData as CustomColumnParentData;

      width = max(width, child.getMaxIntrinsicWidth(height));

      child = parentData.nextSibling;
    }
    return width;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    RenderBox? child = firstChild;
    double width = 0;
    while (child != null) {
      final parentData = child.parentData as CustomColumnParentData;

      width = max(width, child.getMinIntrinsicWidth(height));

      child = parentData.nextSibling;
    }
    return width;
  }

  @override
  void performLayout() {
    size = _preformLayout(constraints: constraints, dry: false);

    // positioning the children
    RenderBox? child = firstChild;
    Offset childOffset = const Offset(0, 0);
    while (child != null) {
      final parentData = child.parentData as CustomColumnParentData;

      final childPositionDx = alignment.getDx(child.size.width, size.width);

      parentData.offset = Offset(childPositionDx, childOffset.dy);
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
