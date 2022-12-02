// ignore_for_file: sort_child_properties_last

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:javoh_image_post/pages/all_posts.dart';
import 'package:javoh_image_post/servis/auth_servise.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySignIn extends StatefulWidget {
  const MySignIn({super.key});

  @override
  State<MySignIn> createState() => _MySignInState();
}

class _MySignInState extends State<MySignIn> {
  bool select = false;
  bool _clearText = true;

  final _emailCntr = TextEditingController();
  final _passwordCntr = TextEditingController();

  LoginState _state = LoginState.start;
  String err = "";
  int _onTap = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    _emailCntr.text = prefs.getString("email") ?? "";
    _passwordCntr.text = prefs.getString("password") ?? "";
  }

  Future<bool> SaveLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("email", _emailCntr.text);
    prefs.setString("password", _passwordCntr.text);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _textFromField("Email", false, _emailCntr),
              _textFromField("Password", true, _passwordCntr),
              const SizedBox(height: 10),
              _clearText
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _emailCntr.text = "";
                            _passwordCntr.text = "";
                            _clearText = !_clearText;
                          });
                        },
                        child: const Text(
                          "Clear account",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 49, 26)),
                        ),
                      ),
                    ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_onTap == 1) {
                    await _awesimoDialog(true);
                  }
                  setState(() {
                    _state = LoginState.loading;
                  });
                  AuthServise.signUpUser(_emailCntr.text, _passwordCntr.text)
                      .then((user) {
                    setState(() {
                      _state = LoginState.loaded;
                    });
                    if (user != null) {
                      print("loadddddeeeeeeddd");
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MyAllPosts(),
                        ),
                      );
                    } else {
                      setState(() {
                        _state = LoginState.error;
                      err = errorText1;
                      });
                      // err = "Error: Email and Password.....";
                    }
                  });
                },
                child: _state == LoginState.loading
                    ? const CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.black,
                      )
                    : const Text("Sign In"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 87, 32),
                  fixedSize: const Size(double.maxFinite, 46),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      if (_onTap == 1) {
                        _awesimoDialog(false);
                      } else {
                        setState(() {
                          _state = LoginState.start;
                          _onTap = 0;
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MyAllPosts(),
                          ),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text(
                      "All Page",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 87, 32),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              _state == LoginState.error
                  ? Text(
                      err,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    )
                  : const Text(""),
            ],
          ),
        ),
      ),
    );
  }

  _textFromField(String s, bool icons, TextEditingController controller) {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: TextFormField(
        controller: controller,
        autocorrect: false,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        obscureText: icons ? !select : false,
        onTap: () {
          setState(() {
            _onTap = 1;
            _clearText = !_clearText;
          });
        },
        validator: (value) {
          if (!icons) {
            if (value?.isNotEmpty == true) {
              if (value?.contains("@") == false) {
                return "Error";
              }
            }
          } else {
            if (value?.isNotEmpty == true) {
              if (value![0].codeUnits[0] >= 65 && value[0].codeUnits[0] <= 90) {
              } else {
                return "Error: 'A....Z'";
              }
            }
          }
        },
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: s,
          labelStyle: const TextStyle(color: Colors.grey),
          
          suffixIcon: icons
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      select = !select;
                    });
                  },
                  icon: Icon(
                    select ? Icons.visibility : Icons.visibility_off,color: Colors.grey,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  _awesimoDialog(bool navigator) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      transitionAnimationDuration: const Duration(milliseconds: 600),
      title: 'Save',
      desc: 'Email, Password,',
      buttonsTextStyle: const TextStyle(color: Colors.black),
      showCloseIcon: true,
      btnCancelOnPress: () {
        setState(() {
          _state = LoginState.start;
          _onTap = 0;
        });
        navigator
            ? null
            : Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MyAllPosts(),
                ),
              );
      },
      btnOkOnPress: () {
        SaveLogin();
        Fluttertoast.showToast(
          msg: "Saved",
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 3,
          fontSize: 20,
          gravity: ToastGravity.BOTTOM_LEFT,
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() {
          _state = LoginState.start;
          _onTap = 0;
        });
        navigator
            ? null
            : Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MyAllPosts(),
                ),
              );
      },
    ).show();
  }
}

enum LoginState {
  start,
  loading,
  error,
  loaded,
}
