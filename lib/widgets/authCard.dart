import 'package:firebase_test/screens/authScreen.dart';
import 'package:firebase_test/screens/firstScreen.dart';
import 'package:firebase_test/utils/sign_in.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
//  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();


  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 375 : 260,
        constraints:
        BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: <Widget>[
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  enabled: _authMode == AuthMode.Signup,
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
              TextFormField(
                decoration: InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return '';
                },
                onSaved: (value) {
                  _authData['email'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value.isEmpty || value.length < 8) {
                    return 'Password is too short!';
                  }
                  return '';
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  enabled: _authMode == AuthMode.Signup,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match!';
                    }
                    return '';
                  }
                      : null,
                ),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                RaisedButton(
                  child:
                  Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                  onPressed: () {
                    if (_authMode == AuthMode.Login) {
                      signIn(context, _emailController.text,
                          _passwordController.text);
                    } else if (_authMode == AuthMode.Signup) {
                      signUp(context, _nameController.text, _emailController.text,
                          _passwordController.text);
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                  EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                ),
              FlatButton(
                child: Text(
                    '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                onPressed: _switchAuthMode,
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}