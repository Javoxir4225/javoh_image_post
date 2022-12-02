import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyChat extends StatefulWidget {
  MyChat({super.key, required this.title, required this.image1});
  String? title;
  String? image1;
  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  bool setTextField = true;
  final _textController = TextEditingController();
  @override
  void initState() {
    _textController.addListener(() {
      if (_textController.text.isEmpty) {
        setState(() {
          setTextField = true;
        });
      } else {
        setState(() {
          setTextField = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppbar(),
      bottomSheet: Container(
        color: Colors.black,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 6),
          child: TextFormField(
            controller: _textController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "send a message",
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(
                CupertinoIcons.camera_circle,
                color: Colors.white,
                size: 44,
              ),
              suffixIcon: SizedBox(
                width: 120,
                height: 44,
                child: setTextField == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(CupertinoIcons.mic,
                              color: Colors.white, size: 30),
                          SizedBox(width: 8),
                          Icon(CupertinoIcons.photo,
                              color: Colors.white, size: 30),
                          SizedBox(width: 8),
                          Icon(CupertinoIcons.smiley,
                              color: Colors.white, size: 30),
                          SizedBox(width: 8),
                        ],
                      )
                    : const Center(
                        child: Text(
                          "Send",
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromARGB(255, 40, 115, 177)),
                        ),
                      ),
              ),
              fillColor: Colors.grey.shade800,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
      ),
    );
  }

  _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: ListTile(
        leading: GestureDetector(
          onTap: () {},
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 18,
              backgroundImage: NetworkImage(widget.image1.toString()),
            ),
          ),
        ),
        title: Text(
          widget.title.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "online ${Random.secure().nextInt(60)} min,ago",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.phone),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.video_camera),
        ),
      ],
    );
  }
}
