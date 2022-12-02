// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:javoh_image_post/models/post_model.dart';
import 'package:javoh_image_post/pages/add_post.dart';
import 'package:javoh_image_post/pages/mesengers.dart';
import 'package:javoh_image_post/servis/db_servise.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyAllPosts extends StatefulWidget {
  const MyAllPosts({super.key});

  @override
  State<MyAllPosts> createState() => _MyAllPostsState();
}

class _MyAllPostsState extends State<MyAllPosts> {
  int selecOnTap = 0;
  List<PostModel> posts = [];
  double percent = 1;
  @override
  void initState() {
    DBService.getPosts().then((value) {
      setState(() {
        posts = value;
      });
      print("inintstat:getPosts========>>>>>>>>");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            selecOnTap = value;
          });
          if (value == 4) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MyAddPost(),
              ),
            );
            setState(() {
              selecOnTap = 0;
            });
          }
        },
        currentIndex: selecOnTap,
        items: [
          _buildBottomNavigationBarItam(CupertinoIcons.home),
          _buildBottomNavigationBarItam(CupertinoIcons.search),
          _buildBottomNavigationBarItam(CupertinoIcons.videocam),
          _buildBottomNavigationBarItam(CupertinoIcons.heart),
          _buildBottomNavigationBarItam(CupertinoIcons.add),
        ],
      ),
    );
  }

  buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      title: Text(
        "Instagram",
        style: GoogleFonts.dancingScript(fontSize: 30),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () async {
            final result =
                await ImagePicker().pickImage(source: ImageSource.camera);
          },
          icon: Icon(CupertinoIcons.camera, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MyMesenger(),
              ),
            );
          },
          icon: const Icon(CupertinoIcons.chat_bubble_text),
        ),
      ],
    );
  }

  _buildBody() {
    return RefreshIndicator(
      onRefresh: () => onRefresh(),
      child: posts.isEmpty == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemBuilder: (context, index) => index == 0
                  ? Container(
                      height: 110,
                      padding: const EdgeInsets.only(left: 8),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index1) => SizedBox(
                          width: 96,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _buildShowDialog(posts[index1].image ?? "");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    _buildCirculerPercentIndicator(42, 3),
                                    _buildCircleAvatar(
                                        35,
                                        (posts[index1].image != null
                                                ? NetworkImage(posts[index1].image!)
                                                : AssetImage(
                                                    "assets/images/placeholder1.jpg"))
                                            as ImageProvider),
                                  ],
                                ),
                              ),
                              _buildTextSize(posts[index1].fullname ?? "", 12),
                            ],
                          ),
                        ),
                        separatorBuilder: (context, index1) =>
                            const SizedBox(width: 6),
                        itemCount: posts.length,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _buildShowDialog(
                                      posts[index - 1].image ?? "");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    _buildCirculerPercentIndicator(20, 2),
                                    _buildCircleAvatar(
                                      16,
                                      (posts[index - 1].image != null
                                              ? NetworkImage(
                                                  posts[index - 1].image!)
                                              : AssetImage(
                                                  "assets/images/placeholder1.jpg"))
                                          as ImageProvider,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        _buildText(
                                            posts[index - 1].fullname ?? ""),
                                        SizedBox(width: 10),
                                        Expanded(
                                            child: _buildText(
                                                posts[index - 1].listname ??
                                                    "")),
                                        Expanded(child: SizedBox()),
                                        GestureDetector(
                                          onTap: () {
                                            _buildAwesimoDialog(index - 1,
                                                () async {
                                              final res =
                                                  await DBService.deletPost(
                                                      posts[index - 1].id);
                                              if (res) {
                                                setState(() {
                                                  posts.removeAt(index - 1);
                                                });
                                                _buildFlutterToast(
                                                    "Delet Post", Colors.green);
                                              } else {
                                                _buildFlutterToast(
                                                    "No Delet Post",
                                                    Colors.red);
                                              }
                                            });
                                          },
                                          child: Icon(
                                            CupertinoIcons.delete,
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.location_solid,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        _buildText(
                                            posts[index - 1].location ?? ""),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Container(
                            height: 350,
                            width: double.infinity,
                            color: Colors.grey,
                            child: Image(
                              image: (posts[index - 1].image != null
                                      ? NetworkImage(
                                          posts[index - 1].image ?? "",
                                        )
                                      : AssetImage(
                                          "assets/images/placeholder1.jpg"))
                                  as ImageProvider,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image(
                                  image: AssetImage(
                                      "assets/images/placeholder1.jpg"),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                return loadingProgress != null
                                    ? Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      )
                                    : child;
                              },
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildText("Date:"),
                                  _buildText("Content:"),
                                ],
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildText(posts[index - 1].date ?? ""),
                                    _buildText(posts[index - 1].content ?? ""),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: posts.length + 1,
            ),
    );
  }

  _buildBottomNavigationBarItam(IconData iconData) {
    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        size: 28,
      ),
      label: "",
      backgroundColor: Colors.black,
    );
  }

  _buildCirculerPercentIndicator(double radius, double lineWidth) {
    return CircularPercentIndicator(
      radius: radius,
      animation: true,
      animationDuration: 2000,
      lineWidth: lineWidth,
      percent: percent,
      linearGradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.yellow.shade800,
          Colors.pink,
        ],
      ),
      circularStrokeCap: CircularStrokeCap.round,
    );
  }

  _buildCircleAvatar(double radius, ImageProvider x) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: x,
    );
  }

  _buildText(String s) {
    return Text(
      s,
      style: TextStyle(color: Colors.white),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Future onRefresh() async {
    final res = await DBService.getPosts();
    if (res.isNotEmpty) {
      setState(() {
        posts = res;
        // percent = 0;
      });
    }
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      percent = 1;
    });
  }

  _buildShowDialog(String s) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 350,
          width: 350,
          child: Image(
            image: (s != null
                ? NetworkImage(s)
                : AssetImage("assets/placeholder")) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  _buildTextSize(String s, double i) {
    return Text(
      s,
      style: TextStyle(color: Colors.white, fontSize: i),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  void _buildAwesimoDialog(int index, VoidCallback onDelet) {
    AwesomeDialog(
      context: context,
      btnCancelOnPress: () {},
      btnOkOnPress: onDelet,
      alignment: Alignment.center,
      animType: AnimType.leftSlide,
      dialogType: DialogType.question,
      headerAnimationLoop: false,
      showCloseIcon: true,
      title: "Delete: post${index + 1}",
      titleTextStyle: const TextStyle(
        color: Colors.red,
        fontSize: 20,
      ),
      desc: "Name:  ${posts[index].fullname} ${posts[index].listname} ",
      descTextStyle: const TextStyle(
        fontSize: 16,
      ),
    ).show();
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
}
