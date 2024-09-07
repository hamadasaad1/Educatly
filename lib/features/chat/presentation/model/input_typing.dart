
class InputTypingStatus {
  final String senderId;
  final String receiverId;
  final bool isTyping;
  InputTypingStatus({
    required this.senderId,
    required this.receiverId,
    required this.isTyping,
  });
}
