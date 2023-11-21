import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SendingPhoto extends StatelessWidget {
  SendingPhoto({
    super.key,
  });

  static String id = 'SendingPhoto';

  final CollectionReference massages =
      FirebaseFirestore.instance.collection(kMassagesCollectionReference);
  @override
  Widget build(BuildContext context) {
    var url = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: url.toString(),
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[850]!,
              highlightColor: Colors.grey[800]!,
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.7,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
          IconButton(
              onPressed: () {
                if (url != null) {
                  massages.add({
                    kMassage: url,
                    kSentAt: DateTime.now(),
                    'id': FirebaseAuth.instance.currentUser!.uid,
                    'type': 2
                  });
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                Icons.send,
                size: 30,
                color: kPrimerColor,
              ))
        ],
      ),
    );
  }
}
