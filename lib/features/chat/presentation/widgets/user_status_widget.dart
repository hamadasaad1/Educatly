import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:template/features/chat/presentation/widgets/typing_widget.dart';
import 'package:template/shared/resources/styles_manager.dart';

import '../../../../shared/resources/color_manager.dart';
import '../../../../shared/resources/font_manager.dart';

class UserStatusWidget extends StatelessWidget {
  final String receiverId;
  const UserStatusWidget({
    Key? key,
    required this.receiverId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (_, state) {
        return StreamBuilder<DocumentSnapshot?>(
          stream: context.read<ChatCubit>().getUserData(userId: receiverId),
          builder: (context, snapshot) {
            DocumentSnapshot? userData = snapshot.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  userData?.get('fullName') ?? 'No name',
                  style: getMediumStyle(color: ColorManager.white),
                ),
                Text(
                  (userData != null &&
                          (userData.data() as Map<String, dynamic>)
                              .containsKey('isOnline'))
                      ? (userData.get('isOnline') ?? false)
                          ? 'Online'
                          : 'Offline'
                      : 'Offline',
                  style: getRegularStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.white.withOpacity(.5)),
                ),
                TypingWidget(receiverId: receiverId),
              ],
            );
          },
        );
      },
    );
  }
}
