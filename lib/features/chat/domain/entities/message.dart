import 'package:flutter/material.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

class Message {
  final String messageId;
  final MessageType messageType;
  final String? text;
  final Image? image;
  final String sentBy;
  final String sentTo;
  final DateTime timeSent;
  final bool isViewed;
  final Location? location;
  final bool? action;

  //this is id of request or donation we are sending
  final String? messageTypeId;

  Message({
    required this.messageTypeId,
    String? messageId,
    required this.action,
    required this.location,
    required this.messageType,
    required this.text,
    required this.image,
    required this.sentBy,
    required this.sentTo,
    required this.timeSent,
    required this.isViewed,
  }) : messageId = messageId ?? uuid.v4();
}

enum MessageType { image, text, imageWithText, request, donation }
