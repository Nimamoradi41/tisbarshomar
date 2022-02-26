

import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);
  void StartServinPalt() async
  {
    if (Platform.isAndroid) {
      var met=MethodChannel("com.example.testuitest");
      String s= await  met.invokeMethod("startService");
      print('data Is   '+ s);

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true,
        backgroundColor: Colors.green,
        leading: GestureDetector(
            onTap: (){
              StartServinPalt();
            },
            child: Icon(Icons.refresh,color: Colors.white,size: 30,)),
        title:Text('', textAlign: TextAlign.center)),
        body:Column(
          children: [
            Container(
              color: Colors.red,
            ),
            Expanded(child: Container(color: Colors.amber,))
          ],
        ));
  }
}
