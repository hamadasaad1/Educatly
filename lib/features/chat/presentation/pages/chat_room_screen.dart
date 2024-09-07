import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/shared/common/widget/custom_image_widget.dart';
import 'package:template/shared/resources/assets_manager.dart';
import 'package:template/shared/resources/color_manager.dart';
import 'package:template/shared/resources/font_manager.dart';
import 'package:template/shared/resources/styles_manager.dart';

import '../../../../shared/common/widget/custom_app_bar.dart';
import '../../../../shared/resources/manager_values.dart';
import '../../../../shared/resources/size_config.dart';
import '../cubit/chat_cubit.dart';
import '../model/receiver_model.dart';
import '../widgets/chat_widget.dart';
import '../widgets/user_status_widget.dart';

class ChatRoomScreen extends StatelessWidget {
  final ReceiverModel? receiverModel;

  const ChatRoomScreen({Key? key, this.receiverModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, 
          statusBarIconBrightness:
              Brightness.light, 
        ),
        child: Scaffold(
            body: Stack(children: [
          
          Container(
            height:
                MediaQuery.of(context).padding.top, 
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(.89),
                  ColorManager.primary.withOpacity(.8)
                ],
              ),
            ),
          ),
          SafeArea(
              child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: getPadding(all: AppPadding.p16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(.89),
                      ColorManager.primary.withOpacity(.8)
                    ],
                  ),
                ),
                child: Row(
                
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context, true),
                      child: CustomSvgImage(
                        imageName: Assets.assetsSvgArrowBack,
                        color: ColorManager.arrowColor,
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Expanded(
                        child: BlocProvider(
                      create: (context) => ChatCubit(),
                      child: UserStatusWidget(
                        receiverId: receiverModel?.id ?? '',
                      ),
                    )),

                    Container(
              width: 35.w,
              height: 35.w,
              padding: getPadding(all: AppPadding.p14),
              decoration: const ShapeDecoration(
                color: Color(0xFFF2F2F2),
                shape: OvalBorder(),
              ),
              child: CustomSvgImage(
                  width: 15, height: 15, imageName: Assets.assetsSvgPerson, color: ColorManager.primary,),
            ),
                  ],
                ),
              ),
              Expanded(
                child: ChatWidget(
                  receiverModel: receiverModel,
                ),
              )
            ],
          ))
        ])));
  }
}
