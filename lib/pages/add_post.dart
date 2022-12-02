import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:javoh_image_post/models/post_model.dart';
import 'package:javoh_image_post/servis/db_servise.dart';

class MyAddPost extends StatefulWidget {
  const MyAddPost({super.key});

  @override
  State<MyAddPost> createState() => _MyAddPostState();
}

class _MyAddPostState extends State<MyAddPost> {
  final _fullnameController = TextEditingController();
  final _listnameController = TextEditingController();
  final _contentnController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  PostCreateState _state = PostCreateState.initial;
  String body = "";
  File? _file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: _buildAppbar(),
      body: buildBody(),
    );
  }

  _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Text("Add Post"),
      centerTitle: true,
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: [
            _buildImageProvider(),
            _buildTextFormField("FirstName", 10, _fullnameController, false

                // value: (value) {
                //   return value?.isNotEmpty == true ? null : "Title must be filled";
                // },
                ),
            const SizedBox(height: 6),
            _buildTextFormField("ListName", 10, _listnameController, false),
            const SizedBox(height: 6),
            _buildTextFormField("Content", 40, _contentnController, false),
            const SizedBox(height: 6),
            _buildTextFormField("location", 15, _locationController, false),
            const SizedBox(height: 6),
            _buildTextFormField("Date", 10, _dateController, true),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _state = PostCreateState.loading;
                });
                if (_fullnameController.text != "") {
                  final post = PostModel(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    fullname: _fullnameController.text,
                    listname: _listnameController.text,
                    content: _contentnController.text,
                    location: _locationController.text,
                    date: _dateController.text,
                    
                  );
                  final res = await DBService.createPost(post,_file);
                  if (res) {
                    setState(() {
                      _state = PostCreateState.loadid;
                      _clearNameContent();
                    });
                    _buildFlutterToast("Create Post", Colors.green);
                  } else {
                    _buildFlutterToast("No Create Post", Colors.red);
                  }
                } else {
                  Timer(
                    const Duration(milliseconds: 1500),
                    () {
                      setState(() {
                        _state = PostCreateState.loadid;
                        _state = PostCreateState.error;
                        body = "FirstName,ListName,Content,Date must be filled";
                        _buildFlutterToast("No Creat Post", Colors.red);
                      });
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 22, 99, 162),
                fixedSize: const Size(double.maxFinite, 46),
              ),
              child: _state == PostCreateState.loading
                  ? const CircularProgressIndicator()
                  : const Text("Add"),
            ),
            const SizedBox(height: 36),
            _state == PostCreateState.error
                ? Text(
                    body,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  )
                : const Text(""),
          ],
        ),
      ),
    );
  }

  _buildTextFormField(
      String s, int length, TextEditingController controller, bool setValidator,
      {String? Function(String? value)? value}) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        controller: controller,
        maxLength: length,
        validator: (value) {
          if (setValidator) {
            if (value?.isNotEmpty == true) {
              if (int.tryParse(value!) == null) {
                return "error";
              }
            }
          }
        },
        decoration: InputDecoration(
          labelText: s,
          // fillColor: Colors.grey,
          labelStyle: const TextStyle(color: Colors.white),
          // filled: true,
          // hintMaxLines: 10,
          // border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.green),
      ),
    );
  }

  void _buildFlutterToast(String t, Color color) {
    Fluttertoast.showToast(
      msg: t,
      // msg: "post failed",
      fontSize: 20,
      backgroundColor: color,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 5,
      gravity: ToastGravity.SNACKBAR,
    );
  }

  void _clearNameContent() {
    _fullnameController.text = "";
    _listnameController.text = "";
    _contentnController.text = "";
    _locationController.text = "";
    _dateController.text = "";
  }

  _buildImageProvider() {
    return GestureDetector(
      onTap: () async {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 200,
              color: Colors.grey.shade800,
              padding: const EdgeInsets.only(right: 24, left: 24),
              child: Column(
                children: [
                  const Icon(
                    Icons.horizontal_rule,
                    color: Colors.white,
                    size: 36,
                  ),
                  const Text(
                    "Select an action",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildElevatedButtonIcon(
                          CupertinoIcons.camera, "Camera", Colors.green,
                          () async {
                        final result =
                            await _picker.pickImage(source: ImageSource.camera);
                        if (result?.path != null) {
                          setState(() {
                            _file = File(result!.path);
                          });
                        }
                      }),
                      _buildElevatedButtonIcon(
                          CupertinoIcons.photo, "Galerya", Colors.red,
                          () async {
                        final result = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (result?.path != null) {
                          setState(() {
                            _file = File(result!.path);
                          });
                        }
                      }),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      child: SizedBox(
        height: 160,
        width: 160,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(80),
          child: (_file != null
              ? Image.file(
                  _file!,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  "assets/images/placeholder1.jpg",
                  fit: BoxFit.cover,
                )),
        ),
      ),
    );
  }

  _buildElevatedButtonIcon(
      IconData iconData, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        size: 36,
      ),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
          fixedSize: const Size(double.infinity, 44), backgroundColor: color),
    );
  }
}

enum PostCreateState {
  initial,
  loading,
  loadid,
  error,
}
