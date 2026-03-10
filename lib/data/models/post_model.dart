import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {

  final int comments;
  final DateTime? date;
  final String description;
  final String email;
  final String image;
  final double latitude;
  final int likes;
  final double longitude;
  final String phone;
  final String tag;
  final String title;
  final String userUid;

  PostModel({
    required this.comments,
    required this.date,
    required this.description,
    required this.email,
    required this.image,
    required this.latitude,
    required this.likes,
    required this.longitude,
    required this.phone,
    required this.tag,
    required this.title,
    required this.userUid,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      comments: json['comments'] ?? 0,
      date: (json['date'] as Timestamp?)?.toDate(),
      description: json['discription'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      likes: json['likes'] ?? 0,
      longitude: (json['longitude'] ?? 0).toDouble(),
      phone: json['phone'] ?? '',
      tag: json['tag'] ?? '',
      title: json['title'] ?? '',
      userUid: json['userUid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "comments": comments,
      "date": date != null ? Timestamp.fromDate(date!) : null,
      "discription": description,
      "email": email,
      "image": image,
      "latitude": latitude,
      "likes": likes,
      "longitude": longitude,
      "phone": phone,
      "tag": tag,
      "title": title,
      "userUid": userUid,
    };
  }
}