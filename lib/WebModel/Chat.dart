import 'package:flutter/material.dart';

class Chat {
  final String image, name, subject, body, time;
  final bool isAttachmentAvailable, isChecked;
  final Color tagColor;

  Chat({
    this.time,
    this.isChecked,
    this.image,
    this.name,
    this.subject,
    this.body,
    this.isAttachmentAvailable,
    this.tagColor,
  });
}

List<Chat> chats = List.generate(
  demo_data.length,
      (index) => Chat(
    name: demo_data[index]['name'],
    image: demo_data[index]['image'],
    subject: demo_data[index]['subject'],
    isAttachmentAvailable: demo_data[index]['isAttachmentAvailable'],
    isChecked: demo_data[index]['isChecked'],
    tagColor: demo_data[index]['tagColor'],
    time: demo_data[index]['time'],
    body: emailDemoText,
  ),
);

List demo_data = [
  {
    "name": "Ahmed Magdy",
    "image": "images/person.png",
    "subject": "iPhone 12 is here",
    "isAttachmentAvailable": false,
    "isChecked": true,
    "tagColor": null,
    "time": "Now"
  },
  {
    "name": "Elvia Atkins",
    "image": "images/person.png",
    "subject": "Inspiration for our new home",
    "isAttachmentAvailable": true,
    "isChecked": false,
    "tagColor": null,
    "time": "15:32"
  },
  {
    "name": "Monem Salem",
    "image": "images/person.png",
    "subject": "Business-focused empowering the world",
    "isAttachmentAvailable": true,
    "isChecked": false,
    "tagColor": null,
    "time": "14:27",
  },
  {
    "name": "Tom Bale",
    "image": "images/person.png",
    "subject": "The fastest way to Design",
    "isAttachmentAvailable": false,
    "isChecked": true,
    "tagColor": Color(0xFF23CF91),
    "time": "10:43"
  },
  {
    "name": "Adedayo Akoide",
    "image": "images/person.png",
    "subject": "New job opportunities",
    "isAttachmentAvailable": false,
    "isChecked": false,
    "tagColor": Color(0xFF3A6FF7),
    "time": "9:58"
  }
];

String emailDemoText =
    "Corporis illo provident. Sunt omnis neque et aperiam. Nemo ut dolorum fugit eum sed. Corporis illo provident. Sunt omnis neque et aperiam. Nemo ut dolorum fugit eum sed. Corporis illo provident. Sunt omnis neque et aperiam. Nemo ut dolorum fugit eum sed";