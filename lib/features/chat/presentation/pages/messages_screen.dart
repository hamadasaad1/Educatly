import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/chat/presentation/model/receiver_model.dart';
import 'package:template/features/chat/presentation/pages/chat_room_screen.dart';

import '../../../../app/service_locator.dart';
import '../../../../app/singlton.dart';
import '../../../../app/time_ago.dart';
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
import '../widgets/drawer_widget.dart';
import '../widgets/user_data.dart';
import 'users_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with WidgetsBindingObserver {
  late ChatCubit _viewModel;

  List<DocumentSnapshot<Object?>> messages = [];

  bool isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    initAuthModule();
    initialChatModule();

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void deactivate() {
    _viewModel.updateUserStatus(isOnline: false);
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _viewModel.updateUserStatus(isOnline: true);
    } else {
      _viewModel.updateUserStatus(isOnline: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerWidget(),
      appBar: CustomAppBar(
        title: 'Messages',
        onBackPress: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        isCenterTitle: true,
        leadingWidget: Container(
          padding: getPadding(all: AppPadding.p16),
          width: AppSize.s12,
          height: AppSize.s12,
          child: const Icon(Icons.menu, color: ColorManager.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: ColorManager.primary),
            onPressed: () async {
              var result = await changeNavigator(context, UsersScreen());
              if (result != null) {
                _viewModel.getLastMessage();
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: getPadding(all: AppPadding.p16),
        child: BlocProvider<ChatCubit>(
          create: (context) {
            _viewModel = ChatCubit();
            _viewModel.getLastMessage();
            return _viewModel;
          },
          child: BlocConsumer<ChatCubit, ChatState>(
            listener: (context, state) {
              if (state is ChatLastMessageLoaded) {
                messages.addAll(state.messages);
                isLoading = false;
              }
              if (state is ChatLastMessageError) {
                isLoading = false;
                messages = [];
              }
              if (state is ChatLastMessageLoading) {
                messages = [];
                isLoading = true;
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Singleton().userData == null) const UpdateUserData(),
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
                  title: 'No messages yet',
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
        onTap: () async {
          model['receiverId'] == Singleton().userModel?.uid.toString()
              ? model['senderId']
              : model['receiverId'];
          var result = await changeNavigator(
              context,
              ChatRoomScreen(
                receiverModel: ReceiverModel(
                    name: model['receiverId'] ==
                            Singleton().userModel?.uid.toString()
                        ? model['senderName']
                        : model['receiverName'],
                    phone: '',
                    id: model['receiverId'] ==
                            Singleton().userModel?.uid.toString()
                        ? model['senderId']
                        : model['receiverId']),
              ));

          if (result != null) {
            _viewModel.getLastMessage();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                    width: 15,
                    height: 15,
                    imageName: Assets.assetsSvgPerson,
                    color: ColorManager.primary,
                  ),
                ),
                const SizedBox(width: AppSize.s8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model['receiverId'] ==
                                Singleton().userModel?.uid.toString()
                            ? model['senderName'].toString().isNotEmpty
                                ? model['senderName']
                                : 'No name'
                            : model['receiverName'].toString().isNotEmpty
                                ? model['receiverName']
                                : 'No name',
                        style: getSemiBoldStyle(
                            fontSize: FontSize.s12, color: ColorManager.black),
                      ),
                      const SizedBox(height: AppSize.s4),
                      model['imageUrl'] != null && model['imageUrl'] != ''
                          ? const Icon(
                              Icons.camera_alt_outlined,
                              color: ColorManager.grey,
                            )
                          : Text(
                              model['message'],
                              style: getRegularStyle(
                                  fontSize: FontSize.s12,
                                  color: ColorManager.black),
                            ),
                    ],
                  ),
                ),
                Text(
                  TimeAgoFormatter.formatTimeSt(model['time']),
                  style: getRegularStyle(
                      fontSize: FontSize.s12, color: ColorManager.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
