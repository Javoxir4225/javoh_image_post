import 'dart:async';

import 'package:flutter/material.dart';
import 'package:javoh_image_post/pages/sign_in.dart';

class MyWelcomePage extends StatefulWidget {
  const MyWelcomePage({super.key});

  @override
  State<MyWelcomePage> createState() => _MyWelcomePageState();
}

class _MyWelcomePageState extends State<MyWelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    super.initState();

    Timer(
      const Duration(milliseconds: 4000),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MySignIn(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller.repeat(reverse: true);
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Image.asset(
            "assets/images/instagram.jpg",
            height: 300,
            width: 300,
          ),
        ),
      ),
    );
  }
}
