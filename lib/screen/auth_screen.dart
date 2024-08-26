

import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              )
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  AuthCard()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


enum AuthMode {SIGNUP, LOGIN}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<StatefulWidget> createState() => _AuthCard();
}

class _AuthCard extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.LOGIN;
  final Map<String, String> _authData = {'email': '', 'password': ''};
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    print(_authData['email']);
    print(_authData['password']);
    setState(() { _isLoading = true; });

    if (_authMode == AuthMode.LOGIN) {
      /// login
    } else {
      /// register
    }
    setState(() { _isLoading = false; });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.LOGIN) {
      setState(() { _authMode = AuthMode.SIGNUP; });
    } else {
      setState(() { _authMode = AuthMode.LOGIN; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8.0,
      child: Container(
        width: deviceSize.width * 0.75,
        height: _authMode == AuthMode.SIGNUP ? 320 : 260,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                  onSaved: (value) {_authData['email'] = value!;},
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Invalid password';
                    }
                    return null;
                  },
                  onSaved: (value) {_authData['password'] = value!;},
                ),
                if (_authMode == AuthMode.SIGNUP)
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.SIGNUP
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Password not match';
                          }
                          return null;
                        }
                      : null,
                  ),
                const SizedBox(height: 20,),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('LOGIN')
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text('${_authMode == AuthMode.LOGIN ? 'SIGNUP': 'LOGIN'} INSTEAD'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}