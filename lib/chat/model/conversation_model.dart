class Conversational {
  bool deleteByReceiver;
  bool deleteBySender;
  String initiatorId;
  String receiverId;
  String receiverImageUrl;
  String senderImageUrl;
  String chatInitiatorName;
  String chatReciverName;
  String lastMessage;
  String lastMessageTime;

  Conversational({
    required this.deleteByReceiver,
    required this.deleteBySender,
    required this.initiatorId,
    required this.receiverId,
    required this.receiverImageUrl,
    required this.senderImageUrl,
    required this.chatInitiatorName,
    required this.chatReciverName,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  // Factory method to create a Message object from a map
  factory Conversational.fromJson(Map<String, dynamic> json) {
    return Conversational(
      deleteByReceiver: json['deleteByReceiver'] ?? false,
      deleteBySender: json['deleteBySender'] ?? false,
      initiatorId: json['initiatorId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      receiverImageUrl: json['receiverImageUrl'] ?? '',
      senderImageUrl: json['senderImageUrl'] ?? '',
      chatInitiatorName: json['chatInitiatorName'] ?? '',
      chatReciverName: json['chatReciverName'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: json['lastMessageTime'] ?? '',
    );
  }

  // Method to convert Message object to a map
  Map<String, dynamic> toJson() {
    return {
      'deleteByReceiver': deleteByReceiver,
      'deleteBySender': deleteBySender,
      'initiatorId': initiatorId,
      'receiverId': receiverId,
      'receiverImageUrl': receiverImageUrl,
      'senderImageUrl': senderImageUrl,
      'chatInitiatorName': chatInitiatorName,
      'chatReciverName': chatReciverName,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }
}
