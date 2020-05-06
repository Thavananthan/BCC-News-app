import 'package:flutter/material.dart';

class Loginpage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
        title: new Text('Login demo'),
    ),
    body : new Container(
        child: new Text('hello world!')
    )
    );
  }
}