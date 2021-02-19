import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this._isLoading );
  final void Function(String email, String password, String username,
      bool isLogin, BuildContext ctx) submitFn;
  bool _isLoading;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail, _username, _userPassword = '';

  var _isLogin = true;
  var _isHidden = true;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();

    if (isValid) {
      _formKey.currentState.save();

      //the line below will close the soft keyboard
      FocusScope.of(context).unfocus();

      //  Use values to send auth result
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _username,
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        margin: EdgeInsets.all(
          20.0,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  //  Give the column the exact size it wants
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      key: ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty ||
                            value.length < 4 ||
                            !value.contains('@')) {
                          return "Invalid email address";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                      ),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'Username should be at least 4 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Username'),
                        onSaved: (value) {
                          _username = value;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "Password",
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _isHidden = !_isHidden;
                                });
                              },
                              child: _isHidden
                                  ? Icon(Icons.visibility_off_outlined)
                                  : Icon(Icons.visibility_outlined))),
                      obscureText: _isHidden,
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                    SizedBox(
                      height: 12.0,
                    ),

                    if(widget._isLoading) CircularProgressIndicator(),
                    if(!widget._isLoading)
                    RaisedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      splashColor: Theme.of(context).accentColor,
                    ),
                    if(!widget._isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'Already have an account?'),
                      textColor: Theme.of(context).primaryColor,
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
