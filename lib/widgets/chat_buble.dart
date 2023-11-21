import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/widgets/show_photo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voice_message_package/voice_message_package.dart';
import '../constants.dart';
import '../models/massages_model.dart';

class ChatBuble extends StatelessWidget {
  const ChatBuble({
    super.key,
    required this.massage,
  });
  final MassageModel massage;

  @override
  Widget build(BuildContext context) {
    if (massage.type == 2) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            color: kPrimerColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 5, top: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ShowPhoto.id,
                          arguments: massage.massage);
                    },
                    child: CachedNetworkImage(
                      imageUrl: massage.massage,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: Text(
                  DateFormat.Hm().format(massage.sentAt.toDate()).toString(),
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (massage.type == 3) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            color: Colors.white,
          ),
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              VoiceMessage(
                audioSrc: massage.massage,
                played: true, // To show played badge or not.
                me: true, // Set message side.
                onPlay: () {}, // Do something when voice played.
              ),
              Positioned(
                right: 10,
                bottom: 5,
                child: Text(
                  DateFormat.Hm().format(massage.sentAt.toDate()).toString(),
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            color: kPrimerColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 5, top: 10),
                child: Text(
                  massage.massage,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: Text(
                  DateFormat.Hm().format(massage.sentAt.toDate()).toString(),
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class ChatBubleForFriend extends StatelessWidget {
  const ChatBubleForFriend({super.key, required this.massage});
  final MassageModel massage;
  @override
  Widget build(BuildContext context) {
    if (massage.type == 2) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              color: Color(0xff260326)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 5, top: 10),
                  child: CachedNetworkImage(
                    imageUrl: massage.massage,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: Text(
                  DateFormat.Hm().format(massage.sentAt.toDate()).toString(),
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (massage.type == 3) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            color: Colors.white,
          ),
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              VoiceMessage(
                audioSrc: massage.massage,
                played: true, // To show played badge or not.
                me: true, // Set message side.
                onPlay: () {}, // Do something when voice played.
              ),
              Positioned(
                right: 10,
                bottom: 5,
                child: Text(
                  DateFormat.Hm().format(massage.sentAt.toDate()).toString(),
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              color: Color(0xff260326)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 5, top: 10),
                child: Text(
                  massage.massage,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: Text(
                  DateFormat.Hm().format(massage.sentAt.toDate()).toString(),
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
