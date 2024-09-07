import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/app/extensions.dart';
import 'package:template/shared/common/widget/custom_image_widget.dart';
import 'package:template/shared/resources/assets_manager.dart';
import 'package:template/shared/resources/styles_manager.dart';

import '../../../../app/media/media_service_interface.dart';
import '../../../../app/service_locator.dart';
import '../../../../app/singlton.dart';
import '../../../../shared/common/widget/component.dart';
import '../../../../shared/common/widget/custom_loading_screen.dart';
import '../../../../shared/common/widget/image_picker_action_sheet.dart';
import '../../../../shared/common/widget/text_filed_widget.dart';
import '../../../../shared/resources/color_manager.dart';
import '../../../../shared/resources/font_manager.dart';
import '../../../../shared/resources/manager_values.dart';
import '../../../../shared/resources/size_config.dart';
import '../cubit/chat_cubit.dart';
import '../model/message_model.dart';
import '../model/receiver_model.dart';
import 'receiver_item_widget.dart';
import 'sender_item_widget.dart';
import 'typing_widget.dart';

class ChatWidget extends StatefulWidget {
  final ReceiverModel? receiverModel;

  const ChatWidget({
    Key? key,
    this.receiverModel,
  }) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final _messageController = TextEditingController();
  final _key = GlobalKey<FormState>();
  late ChatCubit _viewModel;

  bool isLoading = true;

  final MediaServiceInterface _mediaService = locator<MediaServiceInterface>();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    initialChatModule();

    super.initState();
  }

  @override
  void deactivate() {
    updateTyping(false);
    super.deactivate();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatCubit>(
      create: (context) {
        _viewModel = ChatCubit();
        return _viewModel;
      },
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            showSnackBar(context, state.failure.message);
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: ColorManager.black,
                  padding: getPadding(all: AppPadding.p16),
                  child: buildChatList(),
                ),
              ),
              buildSendBottom()
            ],
          );
        },
      ),
    );
  }

  void scroll() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget buildChatList() {
    return StreamBuilder(
        stream:
            _viewModel.getMessages(receiverId: widget.receiverModel?.id ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              isLoading) {
            if (snapshot.data != null) {
              isLoading = snapshot.data!.docs.isEmpty;
            }

            return const Center(child: CustomLoadingScreen());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              scroll();
            });
          }

          return buildGroupChat(snapshot);
        });
  }

  buildGroupChat(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    Map<String, List<QueryDocumentSnapshot<Object?>>> groupedMessages =
        groupDocsByDate(snapshot.data!.docs);

    return ListView(
      controller: _scrollController,
      children: groupedMessages.entries.map((entry) {
        String date = entry.key;
        List<QueryDocumentSnapshot<Object?>> dailyMessages = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  date,
                  style: getBoldStyle(
                    fontSize: FontSize.s14,
                    color: Colors.white.withOpacity(.3),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ...List.generate(dailyMessages.length, (index) {
              var message = dailyMessages[index];
              String currentSenderId = message['senderId'];

              bool isLastMessage = index == dailyMessages.length - 1;

              bool isDifferentSender = false;
              if (!isLastMessage) {
                String nextSenderId = dailyMessages[index + 1]['senderId'];
                isDifferentSender = currentSenderId != nextSenderId;
              }

              if (currentSenderId != Singleton().userModel?.uid.toString()) {
                return SenderItemWidget(
                  documentSnapshot: message,
                  showTail: isDifferentSender || isLastMessage,
                );
              } else {
                return ReceiverItemWidget(
                  documentSnapshot: message,
                  showTail: isDifferentSender || isLastMessage,
                );
              }
            }),
          ],
        );
      }).toList(),
    );
  }

  Map<String, List<QueryDocumentSnapshot<Object?>>> groupDocsByDate(
      List<QueryDocumentSnapshot<Object?>> docs) {
    Map<String, List<QueryDocumentSnapshot<Object?>>> groupedMessages = {};

    for (var doc in docs) {
      Timestamp timestamp = doc['time'];
      DateTime dateTime = timestamp.toDate();

      String date = dateTime.toFormattedDate();

      if (!groupedMessages.containsKey(date)) {
        groupedMessages[date] = [];
      }
      groupedMessages[date]!.add(doc);
    }

    return groupedMessages;
  }

  Widget buildSendBottom() {
    return Container(
      color: const Color(0xFF1B1A1F),
      padding: getPadding(all: AppPadding.p16),
      child: Form(
        key: _key,
        child: Row(
          children: [
            InkWell(
                onTap: () {
                  _pickImageSource();
                },
                child: CustomSvgImage(imageName: Assets.assetsSvgVector)),
            const SizedBox(width: AppSize.s8),
            Expanded(
              child: CustomTextField(
                borderRadius: AppPadding.p32,
                disabledBorder: true,
                hintText: 'Message',
                color: ColorManager.black,
                textStyle: getRegularStyle(color: const Color(0xFF808080)),
                controller: _messageController,
                onChangedCallback: (text) {
                  bool isTyping = text.isNotEmpty;
                  updateTyping(isTyping);
                },
                suffixIcon: Container(
                  padding: getPadding(all: AppPadding.p8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                          onTap: () {
                            if (_key.currentState!.validate()) {
                              _viewModel.sendMessage(
                                model: MessageModel(
                                    message: _messageController.text,
                                    senderId: Singleton().userModel?.uid ?? '',
                                    receiverId: widget.receiverModel?.id ??
                                        ''.toString(),
                                    receiverName:
                                        widget.receiverModel?.name ?? '',
                                    senderName:
                                        Singleton().userData?['fullName'] ?? '',
                                    time: Timestamp.now()),
                              );

                              _messageController.clear();
                              updateTyping(false);
                            }
                          },
                          child: CustomSvgImage(
                              imageName: Assets.assetsSvgIconSticker)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSize.s8),
            CustomSvgImage(imageName: Assets.assetsSvgIconMicrophone)
          ],
        ),
      ),
    );
  }

  void updateTyping(bool isTyping) {
    _viewModel.updateTyping(
        isTyping: isTyping, receiverId: widget.receiverModel?.id ?? '');
  }

  Future<AppImageSource?> _pickImageSource() async {
    AppImageSource? appImageSource = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => ImagePickerActionSheet(),
    );
    if (appImageSource != null) {
      _getImage(appImageSource);
    }
  }

  Future _getImage(AppImageSource _appImageSource) async {
    final pickedImageFile =
        await _mediaService.uploadImage(context, _appImageSource);

    if (pickedImageFile != null) {
      _viewModel.uploadFile(
          file: pickedImageFile,
          model: MessageModel(
              message: '',
              senderId: Singleton().userModel?.uid ?? '',
              receiverId: widget.receiverModel?.id ?? '',
              receiverName: widget.receiverModel?.name ?? '',
              senderName: Singleton().userData?['fullName'] ?? '',
              time: Timestamp.now()));
    }
  }
}
