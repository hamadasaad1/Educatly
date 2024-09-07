import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CustomGridView extends StatelessWidget {
  final int length;
  final int crossAxisCount;
  final ScrollPhysics? physics;
  final bool? shrinkWrap;
  final Widget Function(BuildContext, int) itemBuilder;

  CustomGridView({
    Key? key,
    required this.crossAxisCount,
    required this.length,
    required this.itemBuilder,
    this.shrinkWrap,
    this.physics,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap ?? false,
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
      ),
      mainAxisSpacing: 8,
      crossAxisSpacing: 12,
      itemCount: length,
      itemBuilder: itemBuilder,
    );
  }
}
