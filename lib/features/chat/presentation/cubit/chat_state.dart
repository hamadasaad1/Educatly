part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {}

class ChatError extends ChatState {
  final Failure failure;

  ChatError({required this.failure});
}

class MessagesLoaded extends ChatState {
  final List<MessageModel> messages;

  MessagesLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}

class ChatSendNotificationLoading extends ChatState {}

class ChatSendNotificationSuccess extends ChatState {}

class ChatSendNotificationError extends ChatState {
  final Failure failure;

  ChatSendNotificationError({required this.failure});
}

class ChatLoadingState extends ChatState {}

class ChatSuccessState extends ChatState {}

class ChatUploadFileSuccessState extends ChatState {
  final String url;

  const ChatUploadFileSuccessState({required this.url});
}

class ChatErrorState extends ChatState {
  final Failure failure;

  const ChatErrorState({required this.failure});
}

class ChatLastMessageLoaded extends ChatState {
  final List<DocumentSnapshot<Object?>> messages;

  const ChatLastMessageLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}

class ChatLastMessageError extends ChatState {
  final Failure failure;

  const ChatLastMessageError({required this.failure});
}

class ChatLastMessageLoading extends ChatState {}

class ChatAllUsersLoaded extends ChatState {
  final List<DocumentSnapshot<Object?>> users;

  const ChatAllUsersLoaded({required this.users});
}

class ChatAllUsersError extends ChatState {
  final Failure failure;

  const ChatAllUsersError({required this.failure});
}

class ChatAllUsersLoading extends ChatState {}
