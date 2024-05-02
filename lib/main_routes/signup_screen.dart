import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:fingram/button/rounded_button.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Введите email'),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Введите пароль'),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Введите имя'),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                ],
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Введите возраст'),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[1-9][0-9]?$|^100$')),
                ],
              ),
              const SizedBox(height: 24.0),
              RoundedButton(
                colour: Colors.blueAccent,
                title: 'Зарегистрироваться',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final UserCredential userCredential =
                        await _auth.createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    if (userCredential.user != null) {
                      await FirebaseDatabase.instance
                          .ref('users/${userCredential.user!.uid}/information')
                          .set({
                        'name': _nameController.text,
                        'age': _ageController.text,
                      });
                      Navigator.pushNamed(context, 'helper');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Произошла ошибка: $e")));
                  } finally {
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
