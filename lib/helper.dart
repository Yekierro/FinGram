import 'package:fingram/button/rounded_button.dart';
import 'package:flutter/material.dart';

class Helper extends StatelessWidget {
  const Helper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/reg2.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Center(
                child: RoundedButton(
              colour: Colors.blueAccent,
              title: 'Далее',
              onPressed: () {
                Navigator.pushNamed(context, 'Уроки');
              },
            )),
          ),
        ],
      ),
    );
  }
}
