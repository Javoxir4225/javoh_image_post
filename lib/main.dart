import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:javoh_image_post/pages/all_posts.dart';
import 'package:javoh_image_post/pages/welcome_page.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.cardoTextTheme()),
     debugShowCheckedModeBanner: false,
      home: const MyWelcomePage(),
    );
  }
}
