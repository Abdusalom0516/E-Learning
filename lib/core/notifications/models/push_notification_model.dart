/// Model class for push notifications
class PushNotificationModel {
  final String title;
  final String body;
  final String? imageUrl;
  final String? payload;

  PushNotificationModel({
    required this.title,
    required this.body,
    this.imageUrl,
    this.payload,
  });

  factory PushNotificationModel.fromJson(Map<String, dynamic> json) {
    return PushNotificationModel(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      imageUrl: json['imageUrl'],
      payload: json['payload'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'payload': payload,
    };
  }
}
