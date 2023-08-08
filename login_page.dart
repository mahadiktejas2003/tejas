import 'package:flutter/material.dart';
import 'package:flutter_sqflite/data/database_helper.dart';
import 'package:flutter_sqflite/data/pages/login/login_presenter.dart';
import 'package:flutter_sqflite/models/user.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginPageContract {
  late BuildContext _ctx;
  late bool _isLoading;
  final formKey = new GlobalKey<FormState>();
  final scafflodKey = new GlobalKey<ScaffoldState>();
  String  _username, _password;
 LoginPagePresenter _presenter;

  LoginPageState() {
    _presenter = new LoginPagePresenter(this);
  }

  void _submit() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();

      if (_username != null && _password != null) {
        setState(() {
          _isLoading = true;
          _presenter.doLogin(_username!, _password!);
        });
      }
    }
  }

  void _showSnackBar(String text) {
    // scafflodKey.currentState.showSnackBar(new SnackBar(
    //   content: new Text(text),
    // ));=>Deprecated method

    //new method:
    final snackBar = SnackBar(
      content: Text(text),
    );
    ScaffoldMessenger.of(_ctx).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = new ElevatedButton(
      onPressed: _submit,
      child: new Text("Login"),
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
      ),
    );

    var loginForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(
          "Sqflite App Login",
          textScaleFactor: 2.0,
        ),
        new Form(
          key: formKey,
          child: new Column(children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new TextFormField(
                onSaved: (val) => _username = val,
                decoration: new InputDecoration(labelText: "Username"),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new TextFormField(
                onSaved: (val) => _password = val,
                decoration: new InputDecoration(labelText: "Password"),
              ),
            ),
          ]),
        ),
        loginBtn,
      ],
    );
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login Page"),
      ),
      key: scafflodKey,
      body: new Container(
        child: new Center(
          child: loginForm,
        ),
      ),
    );
  }

  @override
  void onLoginError(String error) {
    _showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
    // TODO: implement onLoginError
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar(user.toString());
    setState(() {
      _isLoading = false;
    });

    var db = new DatabaseHelper();
    await db.saveUser(user);
  }
}
