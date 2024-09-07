import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';
import '../../resources/styles_manager.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String text;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedSize(
              // vsync: this,

              duration: const Duration(milliseconds: 500),
              child: ConstrainedBox(
                  constraints: isExpanded
                      ? const BoxConstraints()
                      : const BoxConstraints(maxHeight: 50.0),
                  child: Text(widget.text,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: getRegularStyle(color: ColorManager.textColor)))),
          isExpanded
              ? InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Read Less',
                          style: getRegularStyle(color: ColorManager.primary)),
                      //  Icon(Icons.keyboard_arrow_up,
                      //     size: AppSize.s20, color:ColorManager.primary)
                    ],
                  ),
                  onTap: () => setState(() => isExpanded = !isExpanded))
              : InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Read More',
                          style: getRegularStyle(color: ColorManager.primary)),
                      //  Icon(Icons.keyboard_arrow_down,
                      //     size: AppSize.s20, color:ColorManager.primary)
                    ],
                  ),
                  onTap: () => setState(() => isExpanded = !isExpanded))
        ]);
  }
}
