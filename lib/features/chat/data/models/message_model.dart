import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel(
      {required super.action,
      required super.location,
      required super.messageType,
      required super.text,
      required super.image,
      required super.sentBy,
      required super.timeSent,
      required super.isViewed,
      required super.messageId,
      required super.sentTo,
      required super.messageTypeId});

  factory MessageModel.fromJson(Map<String, dynamic> map) {
    LatitudeLongitude? latitudeLongitude;
    final position = map['position'];
    if (position != null) {
      final GeoPoint geoPoint = position['geopoint'];
      latitudeLongitude = GeoFlutterFireConversion.fromGeoPoint(geoPoint);
    }

    return MessageModel(
        action: map['action'],
        location: latitudeLongitude == null
            ? null
            : Location(
                latitude: latitudeLongitude.latitude,
                longitude: latitudeLongitude.longitude,
                address: map['address']),
        messageType: getMessageTypeFromString(map['messageType']),
        text: map['text'],
        image: map['image'],
        sentBy: map['sentBy'],
        sentTo: map['sentTo'],
        timeSent: map['timeSent'].toDate(),
        isViewed: map['isViewed'],
        messageId: map['messageId'],
        messageTypeId: map['messageTypeId']);
  }

  factory MessageModel.fromMessage(Message message) {
    return MessageModel(
        action: message.action,
        messageType: message.messageType,
        text: message.text,
        image: message.image,
        sentBy: message.sentBy,
        sentTo: message.sentTo,
        timeSent: message.timeSent,
        isViewed: message.isViewed,
        messageId: message.messageId,
        location: message.location,
        messageTypeId: message.messageTypeId);
  }

  Map<String, dynamic> toJson() {
    return {
      'messageType': getMessageTypeAsString(messageType),
      'text': text,
      'image': image,
      'sentBy': sentBy,
      'timeSent': timeSent,
      'isViewed': isViewed,
      'messageId': messageId,
      'sentTo': sentTo,
      'action': action,
      'position': location == null
          ? null
          : GeoFlutterFireConversion.toFirePoint(
                  location!.latitude, location!.longitude)
              .data,
      'address': location?.address,
      'messageTypeId': messageTypeId
    };
  }

  // Function to convert MessageType enum to string
  String getMessageTypeAsString(MessageType messageType) {
    switch (messageType) {
      case MessageType.image:
        return 'image';
      case MessageType.text:
        return 'text';
      case MessageType.imageWithText:
        return 'imageWithText';
      case MessageType.request:
        return 'request';
      case MessageType.donation:
        return 'donation';
      default:
        throw ArgumentError('Invalid enum value');
    }
  }

  // Function to convert string to MessageType enum
  static MessageType getMessageTypeFromString(String messageType) {
    switch (messageType) {
      case 'image':
        return MessageType.image;
      case 'text':
        return MessageType.text;
      case 'imageWithText':
        return MessageType.imageWithText;
      case 'request':
        return MessageType.request;
      case 'donation':
        return MessageType.donation;
      default:
        throw ArgumentError('Invalid string value');
    }
  }
}
