import 'package:flutter/material.dart';

import '../../resources/manager_values.dart';

class CustomListView extends StatelessWidget {
  final int length;

  final Widget Function(BuildContext, int) itemBuilder;

  CustomListView({
    Key? key,
    required this.length,
    required this.itemBuilder,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: itemBuilder,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSize.s16),
        itemCount: length);
  }
}
