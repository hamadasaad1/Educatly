import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../shared/common/widget/cach_image.dart';
import '../../../../shared/resources/color_manager.dart';
import '../../../../shared/resources/font_manager.dart';
import '../../../../shared/resources/manager_values.dart';
import '../../../../shared/resources/size_config.dart';
import '../../../../shared/resources/styles_manager.dart';

class SenderItemWidget extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
final bool showTail;
  const SenderItemWidget({
    Key? key,
    required this.documentSnapshot,
    required this.showTail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildItemSend();
  }

  Widget buildItemSend() {
    Map<String, dynamic> model =
        documentSnapshot.data() as Map<String, dynamic>;

    return
    showTail?
     ChatBubble(
      elevation: 0,
      margin: getMargin(top: AppMargin.m8),
      clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
      backGroundColor: ColorManager.primary,
      alignment: Alignment.centerRight,
      child: buildBody(model),
    ): Align(
      alignment: Alignment.centerRight,
      child: Container(
              margin: getMargin(top: AppMargin.m8),
              padding: getPadding(all: AppPadding.p8),
              
              decoration: const BoxDecoration(
                  color: ColorManager.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSize.s18),
                    topRight: Radius.circular(AppSize.s18),
                    bottomRight: Radius.circular(AppSize.s8),
                    bottomLeft: Radius.circular(AppSize.s18),
                  )),
              child: buildBody(model),
            ),
    )
    
    ;
  }

  Container buildBody(Map<String, dynamic> model) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: ScreenUtil().screenWidth * 0.7,
      ),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            model['imageUrl'] != null && model['imageUrl'] != ''
                ? CachedImage(
                    url: model['imageUrl'],
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(AppSize.s8),
                  )
                : Text(
                    model['message'],
                    style: getRegularStyle(color: ColorManager.white),
                  ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(),
                Text(
                  DateFormat('hh:mm a').format(model['time'].toDate()),
                  style: getRegularStyle(
                      fontSize: FontSize.s11,
                      color: ColorManager.white.withOpacity(.5)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
