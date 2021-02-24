import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  User user;
  var _isLoading = false;
  void _submitAuthForm(String email, String password, String username, File image,
      bool isLogin, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        //  Login user

        user = (await _auth.signInWithEmailAndPassword(
                email: email, password: password))
            .user;
      } else {

        user = (await _auth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user;

        //  Sign user up
        //First upload the profile image to storage before adding other details
        final ref =  FirebaseStorage.instance.ref().child('smartChatUsersImage').child(user.uid + '.jpg');

        await ref.putFile(image);



        final profileUrl = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('smartChatUsers')
            .doc(user.uid)
            .set({'email': email, 'username': username, 'imageUrl' : profileUrl});
      }
    } on PlatformException catch (error) {
      var message = 'An error occurred, please check your credentials';

      if (error.message != null) {
        message = error.message;
      }
      Fluttertoast.showToast(msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: "Something went wrong, please check your credentials and try again",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
