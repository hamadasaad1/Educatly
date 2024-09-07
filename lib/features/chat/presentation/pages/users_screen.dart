import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/app/singlton.dart';
import 'package:template/features/chat/presentation/model/receiver_model.dart';
import 'package:template/features/chat/presentation/pages/chat_room_screen.dart';

import '../../../../app/service_locator.dart';
import '../../../../shared/common/widget/component.dart';
import '../../../../shared/common/widget/custom_app_bar.dart';
import '../../../../shared/common/widget/custom_empty_widget.dart';
import '../../../../shared/common/widget/custom_image_widget.dart';
import '../../../../shared/common/widget/custom_loading_screen.dart';
import '../../../../shared/resources/assets_manager.dart';
import '../../../../shared/resources/color_manager.dart';
import '../../../../shared/resources/font_manager.dart';
import '../../../../shared/resources/manager_values.dart';
import '../../../../shared/resources/size_config.dart';
import '../../../../shared/resources/styles_manager.dart';
import '../cubit/chat_cubit.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late ChatCubit _viewModel;

  List<DocumentSnapshot<Object?>> messages = [];

  bool isLoading = true;

  @override
  void initState() {
    initialChatModule();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Users',
        isCenterTitle: true,
        onBackPress: () {
          Navigator.pop(context, true);
        }
      ),
      body: Padding(
        padding: getPadding(all: AppPadding.p16),
        child: BlocProvider<ChatCubit>(
          create: (context) {
            _viewModel = ChatCubit();
            _viewModel.getAllUsers();
            return _viewModel;
          },
          child: BlocConsumer<ChatCubit, ChatState>(
            listener: (context, state) {
              if (state is ChatAllUsersLoaded) {
                 messages.addAll(state.users.where((element) => element.id != Singleton().userModel?.uid).toList());
                //messages.addAll(state.users);
                isLoading = false;
              }
              if (state is ChatAllUsersError) {
                isLoading = false;
                messages = [];
              }
              if (state is ChatAllUsersLoading) {
                messages = [];
                isLoading = true;
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: buildChatList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildChatList() {
    return isLoading
        ? const Center(child: CustomLoadingScreen())
        : messages.isEmpty
            ? const Center(
                child: CustomEmptyScreen(
                  title: 'No users yet',
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, index) =>
                    buildItemOfList(documentSnapshot: messages[index]),
                itemCount: messages.length,
              );
  }

  Widget buildItemOfList({required DocumentSnapshot documentSnapshot}) {
    Map<String, dynamic> model =
        documentSnapshot.data() as Map<String, dynamic>;
    return Container(
      padding: getPadding(all: AppPadding.p16),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFF2F2F2), width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSize.s8)),
      margin: getPadding(bottom: AppPadding.p10),
      child: InkWell(
        onTap: ()  {
         changeNavigator(
              context,
              ChatRoomScreen(
                receiverModel: ReceiverModel(
                    name: model['fullName'], phone: '', id: model['uid']),
              ));

         
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            const SizedBox(width: AppSize.s8),
            Text(
              model['fullName'],
              style: getSemiBoldStyle(
                  fontSize: FontSize.s12, color: ColorManager.black),
            ),
          ],
        ),
      ),
    );
  }
}
