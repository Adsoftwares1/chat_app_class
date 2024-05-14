class Message {
  bool deleteByReceiver;
  bool deleteBySender;
  String fromId;
  String message;
  String messageId;

  String toId;

  Message({
    required this.deleteByReceiver,
    required this.deleteBySender,
    required this.fromId,
    required this.message,
    required this.messageId,
    required this.toId,
  });

  // Factory method to create a Message object from a map
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      deleteByReceiver: json['deleteByReceiver'] ?? false,
      deleteBySender: json['deleteBySender'] ?? false,
      fromId: json['fromId'] ?? '',
      message: json['message'] ?? '',
      messageId: json['messageId'] ?? '',
      toId: json['toId'] ?? '',
    );
  }

  // Method to convert Message object to a map
  Map<String, dynamic> toJson() {
    return {
      'deleteByReceiver': deleteByReceiver,
      'deleteBySender': deleteBySender,
      'fromId': fromId,
      'message': message,
      'messageId': messageId,
      'toId': toId,
    };
  }
}
