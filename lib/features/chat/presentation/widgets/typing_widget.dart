import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/app/singlton.dart';
import 'package:template/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:template/shared/resources/styles_manager.dart';

import '../../../../shared/resources/font_manager.dart';

class TypingWidget extends StatelessWidget {
  final String receiverId;
  const TypingWidget({
    Key? key,
    required this.receiverId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (_, state) {
          return StreamBuilder<String?>(
            stream: context
                .watch<ChatCubit>()
                .getTypingStatus(receiverId: receiverId),
            builder: (context, snapshot) {
              String? typingUserId = snapshot.data;
              if (typingUserId != null &&
                  typingUserId != Singleton().userModel?.uid) {
                return Text(
                  'Typing...',
                  style: getRegularStyle(
                    fontSize:  FontSize.s12,
                    color: Colors.white.withOpacity( .5),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
