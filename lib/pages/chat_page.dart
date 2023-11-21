import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:record/record.dart';

import 'package:chat_app/models/massages_model.dart';
import 'package:chat_app/pages/sending_photo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/chat_buble.dart';

class ChatPage extends StatefulWidget {
  static String id = 'ChatPage';

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Record audioRecord = Record();
  bool isRecording = false;
  final listController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final CollectionReference massages =
      FirebaseFirestore.instance.collection(kMassagesCollectionReference);
  bool isLoading = false;
  String? url;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    File file;
    return StreamBuilder<QuerySnapshot>(
        stream: massages.orderBy(kSentAt, descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MassageModel> massagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              massagesList.add(MassageModel.fromJson(
                snapshot.data!.docs[i],
              ));
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: kPrimerColor,
                automaticallyImplyLeading: false,
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_sharp,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Chat',
                    )
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.id, (route) => false);
                    },
                    icon: const Icon(Icons.exit_to_app_outlined),
                    color: Colors.white,
                  )
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      controller: listController,
                      itemCount: massagesList.length,
                      itemBuilder: (context, index) {
                        return massagesList[index].id ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? ChatBuble(massage: massagesList[index])
                            : ChatBubleForFriend(massage: massagesList[index]);
                      },
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? photo = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (photo != null) {
                            setState(() {
                              isLoading = true;
                            });

                            file = File(photo.path);
                            var imagename = basename(photo.path);
                            var refStorage =
                                FirebaseStorage.instance.ref(imagename);
                            await refStorage.putFile(file);
                            url = await refStorage.getDownloadURL();
                          }
                          Navigator.of(context)
                              .pushNamed(SendingPhoto.id, arguments: url);
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.photo,
                            size: 30,
                            color: kPrimerColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width - 55,
                          child: TextField(
                            controller: controller,
                            onSubmitted: (value) {
                              massages.add({
                                kMassage: value,
                                kSentAt: DateTime.now(),
                                'id': FirebaseAuth.instance.currentUser!.uid,
                                'type': 1
                              });
                              controller.clear();
                              listController.jumpTo(0);
                            },
                            decoration: InputDecoration(
                              prefixIcon: GestureDetector(
                                onLongPress: () async {
                                  // Check and request permission if needed
                                  try {
                                    if (await audioRecord.hasPermission()) {
                                      AssetsAudioPlayer.newPlayer().open(
                                        Audio("assets/audio/Notification.mp3"),
                                        autoStart: false,
                                        showNotification: false,
                                      );
                                      // Start r  ecording to file
                                      await audioRecord.start();
                                      setState(() {
                                        isRecording = true;
                                      });
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                onLongPressEnd: (_) async {
                                  final path = await audioRecord.stop();
                                  setState(() {
                                    isRecording = false;
                                  });
                                  if (path != null) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    file = File(path);
                                    var imagename = basename(path);
                                    var refStorage =
                                        FirebaseStorage.instance.ref(imagename);
                                    await refStorage.putFile(file);
                                    url = await refStorage.getDownloadURL();
                                    if (url != null) {
                                      massages.add({
                                        kMassage: url,
                                        kSentAt: DateTime.now(),
                                        'id': FirebaseAuth
                                            .instance.currentUser!.uid,
                                        'type': 3
                                      });
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  }
                                },
                                child: Icon(
                                  Icons.mic,
                                  color: kPrimerColor,
                                  size: isRecording ? 40 : 25,
                                ),
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    massages.add({
                                      kMassage: controller.text,
                                      kSentAt: DateTime.now(),
                                      'id': FirebaseAuth
                                          .instance.currentUser!.uid,
                                      'type': 1
                                    });
                                    controller.clear();
                                    listController.jumpTo(0);
                                  },
                                  icon: Icon(Icons.send, color: kPrimerColor)),
                              hintText: isLoading
                                  ? 'loading.......................'
                                  : 'Send Massage',
                              contentPadding: const EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const ModalProgressHUD(
              inAsyncCall: true,
              child: Scaffold(),
            );
          }
        });
  }
}
