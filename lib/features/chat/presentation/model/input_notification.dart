class NotificationInput {
  String body;
  
  String title;
 
  String? senderId;

  NotificationInput({
    required this.body,
    required this.title,
   
  
    this.senderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'title': title,
      
     
      'senderId': senderId,
    };
  }
}

class DataInput {
  Map<String, dynamic> toJson() {
    return {
      'click_action': "FLUTTER_NOTIFICATION_CLICK",
      'id': DateTime.now().millisecond,
      'status': 'done',
    };
  }
}

class NotificationRequest {
  NotificationInput notification;

  String toToken;

  NotificationRequest({
    required this.notification,
    required this.toToken,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'notification': notification.toJson(),
      //'priority': 'high',
      'data': notification.toJson(),
      'to': toToken,
    };
  }
}
