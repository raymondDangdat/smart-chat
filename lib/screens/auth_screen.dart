import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  User user;
  var _isLoading = false;
  void _submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx) async {


    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        //  Login user

        user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password)).user;
      } else {
        //  Sign user up
        user = (await  _auth.createUserWithEmailAndPassword(
            email: email, password: password)).user;
        await FirebaseFirestore.instance
            .collection('smartChatUsers')
            .doc(user.uid)
            .set({'email': email, 'username': username});
      }
    } on PlatformException catch (error) {
      var message = 'An error occurred, please check your credentials';

      if (error.message != null) {
        message = error.message;
      }

      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
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
