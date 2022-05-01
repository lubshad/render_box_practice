
import 'package:flutter/widgets.dart';

import 'custom_column.dart';

class CustomExpanded extends ParentDataWidget<CustomColumnParentData> {
  const CustomExpanded({
    Key? key,
    this.flex = 1,
    required Widget child,
  }) : super(key: key, child: child);
  final int flex;

  @override
  void applyParentData(RenderObject renderObject) {
    final CustomColumnParentData parentData =
        renderObject.parentData as CustomColumnParentData;
    if (parentData.flex != flex) {
      parentData.flex = flex;
      final targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => CustomColumn;
}
