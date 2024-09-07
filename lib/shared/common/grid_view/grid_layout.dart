import 'package:flutter/material.dart';

import '../../resources/constants_manager.dart';
import 'custom_gridview.dart';

class GridLayout extends StatefulWidget {
  final int length;
  final int? crossAxisCount;
  final ScrollPhysics? physics;
  final bool? shrinkWrap;

  final Widget Function(BuildContext, int) itemBuilder;

  const GridLayout({
    Key? key,
    required this.length,
    required this.itemBuilder,
    this.shrinkWrap,
    this.crossAxisCount,
    this.physics,
  }) : super(key: key);

  @override
  _GridLayoutState createState() => _GridLayoutState();
}

class _GridLayoutState extends State<GridLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimes) {
        if (dimes.maxWidth <= AppConstants.kMobileBreakpoint ||
            dimes.maxWidth <= 900) {
          return CustomGridView(
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap,
            crossAxisCount: widget.crossAxisCount ?? 2,
            itemBuilder: widget.itemBuilder,
            length: widget.length,
          );
        } else if (dimes.maxWidth > AppConstants.kMobileBreakpoint &&
            dimes.maxWidth <= AppConstants.kTabletBreakpoint) {
          return CustomGridView(
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap,
            crossAxisCount: widget.crossAxisCount ?? 3,
            itemBuilder: widget.itemBuilder,
            length: widget.length,
          );
        } else if (dimes.maxWidth > AppConstants.kTabletBreakpoint &&
            dimes.maxWidth >= AppConstants.kDesktopBreakPoint) {
          return CustomGridView(
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap,
            crossAxisCount: widget.crossAxisCount ?? 3,
            itemBuilder: widget.itemBuilder,
            length: widget.length,
          );
        } else {
          return CustomGridView(
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap,
            crossAxisCount: widget.crossAxisCount ?? 3,
            itemBuilder: widget.itemBuilder,
            length: widget.length,
          );
        }
      },
    );
  }
}
