import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:javoh_image_post/models/post_model.dart';
import 'package:javoh_image_post/pages/mesenger_chat.dart';
import 'package:javoh_image_post/servis/db_servise.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMesenger extends StatefulWidget {
  const MyMesenger({super.key});

  @override
  State<MyMesenger> createState() => _MyMesengerState();
}

class _MyMesengerState extends State<MyMesenger> {
  final _dropDownController = TextEditingController();
  List<PostModel> posts = [];
  // String _dropValue = "English";

  @override
  void initState() {
    DBService.getPosts().then((value) {
      setState(() {
        posts = value;
      });
    });
    // getDropValuee();
    super.initState();
  }

  // void getDropValuee() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   _dropDownController.text = prefs.getString("launger") ?? "";
  // }

  // Future<bool> SaveDropValue() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString("launger", _dropDownController.text);
  //   return true;
  // }

  Future refresh() async {
    final result = await DBService.getPosts();
    if (result.isNotEmpty == true) {
      DBService.getPosts().then((value) {
        setState(() {
          posts = value;
        });
      });
    }
    await Future.delayed(
      const Duration(milliseconds: 1000),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppbar(),
      body: buildBody(),
    );
  }

  buildAppbar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Text("mesengers"),
      centerTitle: true,
      actions: [
        const Icon(CupertinoIcons.videocam_circle),
        DropdownButton(
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Colors.black,
          iconSize: 24,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          underline: const SizedBox(),
          elevation: 10,
          items: [
            DropdownMenuItem(
              value: "English",
              onTap: () {
                // EasyLocalization.of(context)?.setLocale(
                //   const Locale("en", "US"),
                // );
              },
              child: const Text("English"),
            ),
            DropdownMenuItem(
              value: "Русский",
              onTap: () {
                // EasyLocalization.of(context)?.setLocale(
                //   const Locale("ru", "RU"),
                // );
              },
              child: const Text("Русский"),
            ),
            DropdownMenuItem(
              value: "O'ZB",
              onTap: () {
                // EasyLocalization.of(context)?.setLocale(
                //   const Locale("uz", "UZ"),
                // );
              },
              child: const Text("O'ZB"),
            ),
          ],
          value: _dropDownController.text.isEmpty == true
              ? null
              : _dropDownController.text,
          onChanged: (value) {
            setState(() {
              // _dropValue = value ?? "not";
              _dropDownController.text = value ?? "";
            });
            // SaveDropValue();
            print("Appbar: actions: DropdownButton => $value");
          },
        ),
        const SizedBox(width: 10),
      ],
      bottom: PreferredSize(
        child: TextFormField(),
        preferredSize: Size(double.infinity, 40),
      ),
    );
  }

  buildBody() {
    return posts.isNotEmpty == true
        ? RefreshIndicator(
            onRefresh: refresh,
            color: Colors.black,
            child: ListView.separated(
              itemBuilder: (context, index) => index == 0
                  ? SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            fillColor: Colors.grey,
                            filled: true,
                            prefixIcon: Icon(Icons.search),
                            hintText: "Search.....",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Material(
                      color: Colors.transparent,
                      child: InkWell(
                        highlightColor: Colors.green,
                        splashColor: Colors.green,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>  MyChat(title: posts[index-1].fullname,image1: posts[index-1].image),
                            ),
                          );
                        },
                        onDoubleTap: () {},
                        child: ListTile(
                          // minVerticalPadding: 18,
                          horizontalTitleGap: 10,
                          leading: GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 33,
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 26,
                                backgroundImage:
                                    NetworkImage(posts[index - 1].image ?? ""),
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                posts[index - 1].fullname ?? "not name",
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                posts[index - 1].listname ?? "not name",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            "online ${Random.secure().nextInt(60) + 1} minutes ago",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                              onPressed: () async{
                                final res = await ImagePicker().pickImage(source: ImageSource.camera);
                              },
                              icon: const Icon(
                                CupertinoIcons.camera,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemCount: posts.length + 1,
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
            color: Colors.red,
          ));
  }

  _buildShowDialog(String s) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 350,
          width: 350,
          child: Image(
            image: AssetImage(s),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
