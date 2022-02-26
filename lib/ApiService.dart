import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';


import 'AppShip/DataBseFile.dart';
import 'AppShip/DataModelAnbarService.dart';
import 'AppShip/LoginScreen.dart';
import 'AppShip/MainPage.dart';
import 'AppShip/MainPage_Saderat.dart';
import 'AppShip/SaveOfflineService.dart';
import 'AppShip/Trucks.dart';
import 'AppShip/enter_Service.dart';
import 'modeldatalogin.dart';
import 'package:http/http.dart'as http;

class ApiService{
  static ShowSnackbar(String Msg){
    if(Msg.contains('No host specified in URI'))
    {
      Msg='آدرس سرور اشتباه وارد شده است';
    }
    Fluttertoast.showToast(
        msg: Msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }
  static Future Login(String userName,String password,BuildContext context2,ProgressDialog pr) async{
    Modeldatalogin? login=null;

    if(!pr.isShowing())
    {
      pr.style(
        textAlign: TextAlign.center,
        message: 'درحال ارتباط با سرور..',
        messageTextStyle: TextStyle(
            fontFamily:  'iranyekanbold',
            fontSize: 14,
            color: Colors.black87),
      );
      await  pr.show();
    }
    var map = new Map<String, dynamic>();
    map['body'] = jsonEncode({
      "pass":password,
      "meliCode":userName,
      "phone":'10',
      "seriall":'postmanReza',
      "appVersion":'1',
      "confirmCode":'',
      "osType":'1'}) ;
    print(map.toString());
    final url = Uri.parse('http://31.7.67.183:2020/Api/Account/ConfirmByPass');
    // print(url.toString());
    // final url = Uri.parse('http://91.108.148.38:33221/CRM'+'/'+'Api/Atiran/login/login');
    print(url.toString());
    try{
      Response response = await http.post(url,  body:map,
      )
          .timeout(
        Duration(seconds: 15),
        onTimeout: () {
          // pr.hide();
          return   ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
        },
      )
          .catchError((error) {
        pr.hide();
        print('eRROR IS'+error.toString());
        // return   ShowSnackbar(error.toString());
        // throw("some arbitrary error");
      }) ;

      print('Resi'+response.toString());
      if(response.statusCode==200)
      {
        print('Its Ok Request Nima');
        String data=response.body;
        var body=json.decode(data);
        var data1=body['data'];
        if(data1!=null)
          {
            var securityKey=data1['securityKey'];
            if(securityKey!=null)
              {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('securityKey',securityKey);
                Login_2(securityKey,context2,pr);
              }else{
              pr.hide();
              ShowSnackbar('کاربر یافت نشد');
            }

          }else{
          pr.hide();
          ShowSnackbar('کاربر یافت نشد');
        }
        print(body);
        // Modeldatalogin DATA=modeldataloginFromJson(data);
        // print(DATA.toJson());
        // login=DATA;
        // if(DATA.isSuccess==true)

      }else{
        pr.hide();
        print(response.statusCode.toString());
        print(response.body.toString());

      }
    } on SocketException catch (e)
    {
      print('I am Here'+e.toString());
      pr.hide();
      login= null;
    }
    on TimeoutException catch (e) {
      pr.hide();
      print('Error issssssssswwwwww: $e');

    } on Error catch (e) {
      pr.hide();
      print('Error isssssssss: $e');
    }

    // pr.hide();
    // return login;
  }




  static Future Login_2(String securityKey,BuildContext context,ProgressDialog pr) async{
    Modeldatalogin? login=null;


















    // if(!pr.isShowing())
    // {
    //   pr.style(
    //     textAlign: TextAlign.center,
    //     message: 'درحال ارتباط با سرور..',
    //     messageTextStyle: TextStyle(
    //         fontFamily:  'iranyekanbold',
    //         fontSize: 14,
    //         color: Colors.black87),
    //   );
    //   await  pr.show();
    // }
    var map = new Map<String, dynamic>();
    map['body'] = jsonEncode({
      "securityKey":securityKey,
      "deviceType":'1',
      "imei":'postmanReza',
      "seriall":'postmanReza',
      "appVersion":'1',}) ;
    print(map.toString());
    final url = Uri.parse('http://31.7.67.183:2020/Api/Account/Login');
    // print(url.toString());
    // final url = Uri.parse('http://91.108.148.38:33221/CRM'+'/'+'Api/Atiran/login/login');
    print(url.toString());
    try{
      Response response = await http.post(url,  body:map,
      ).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          pr.hide();
          return   ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
        },
      ).catchError((error) {
        pr.hide();
        print('eRROR IS'+error.toString());
        // return   ShowSnackbar(error.toString());
        // throw("some arbitrary error");
      }) ;

      print('Resi'+response.toString());
      if(response.statusCode==200)
      {
        print('Its Ok Request Nima');
        String data=response.body;
        var body=json.decode(data);
        print(data);
        var data1=body['data'];
        if(data1!=null)
        {
          var token=data1['token'];
          var securityKey=data1['securityKey'];
          print('111');
          if(token!=null)
          {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('token',token);
            prefs.setString('securityKey',securityKey);
            print('222');
            GetTrucks_Saderat(token.toString(),context,pr);
            // ShowSnackbar('ورود با موففقیت انجام شد');
          }else{
            pr.hide();
            ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
          }

        }else{
          pr.hide();
          ShowSnackbar('کاربر یافت نشد');
        }
        print(body);
        // Modeldatalogin DATA=modeldataloginFromJson(data);
        // print(DATA.toJson());
        // login=DATA;
        // if(DATA.isSuccess==true)

      }





      else if(response.statusCode==403)
      {
        pr.hide();
        ShowSnackbar('کاربر یافت نشد');
      }
      else{
        pr.hide();
        ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده');
        print(response.statusCode.toString());

      }
    } on SocketException catch (e)
    {
      print('I am Here'+e.toString());
      pr.hide();
      login= null;
    }
    on TimeoutException catch (e) {
      pr.hide();
      print('Error issssssssswwwwww: $e');

    } on Error catch (e) {
      pr.hide();
      print('Error isssssssss: $e');
    }

    // pr.hide();
    // return login;
  }


  static Future<bool> Login_Refresh(String securityKey,BuildContext context,ProgressDialog pr) async{
    bool login=false;



    SharedPreferences prefs = await SharedPreferences.getInstance();














    if(!pr.isShowing())
    {
      pr.style(
        textAlign: TextAlign.center,
        message: 'درحال ارتباط با سرور..',
        messageTextStyle: TextStyle(
            fontFamily:  'iranyekanbold',
            fontSize: 14,
            color: Colors.black87),
      );
      await  pr.show();
    }
    var map = new Map<String, dynamic>();
    map['body'] = jsonEncode({
      "securityKey":securityKey,
      "deviceType":'1',
      "imei":'postmanReza',
      "seriall":'postmanReza',
      "appVersion":'1',}) ;
    print(map.toString());
    final url = Uri.parse('http://31.7.67.183:2020/Api/Account/Login');
    // print(url.toString());
    // final url = Uri.parse('http://91.108.148.38:33221/CRM'+'/'+'Api/Atiran/login/login');
    print(url.toString());
    try{
      Response response = await http.post(url,  body:map,
      ).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          pr.hide();
          return   ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
        },
      ).catchError((error) {
        pr.hide();
        print('eRROR IS'+error.toString());
        // return   ShowSnackbar(error.toString());
        // throw("some arbitrary error");
      }) ;

      print('Resi'+response.toString());
      if(response.statusCode==200)
      {
        print('Its Ok Request Nima');
        String data=response.body;
        var body=json.decode(data);
        var data1=body['data'];
        if(data1!=null)
        {
          var token=data1['token'];
          var securityKey=data1['securityKey'];
          print('111');
          if(token!=null)
          {
            prefs.setString('token',token);
            prefs.setString('securityKey',securityKey);
            print('222');
           login=true;
            // ShowSnackbar('ورود با موففقیت انجام شد');
          }else{
            login=false;
            pr.hide();
            ShowSnackbar('دستگاه دیگری با اطلاعات شما وارد شده است');
            await prefs.clear();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
            );
          }
        }else{
          pr.hide();
          ShowSnackbar('کاربر یافت نشد');
          await prefs.clear();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
          );
        }
        print(body);
        // Modeldatalogin DATA=modeldataloginFromJson(data);
        // print(DATA.toJson());
        // login=DATA;
        // if(DATA.isSuccess==true)

      }else{
        print('Status is '+response.statusCode.toString());
        pr.hide();
        ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده');
        print(response.statusCode.toString());

      }
    } on SocketException catch (e)
    {
      print('I am Here'+e.toString());
      pr.hide();

    }
    on TimeoutException catch (e) {
      pr.hide();
      print('Error issssssssswwwwww: $e');

    } on Error catch (e) {
      pr.hide();
      print('Error isssssssss: $e');
    }

    // pr.hide();
    return login;
  }


  static Future<bool> Add_Tasck(ProgressDialog pr,String truckId,String enterDate,String exitDate,Trucks s,BuildContext context) async{
    Modeldatalogin? login=null;



    bool Finall=false;







    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=  prefs.getString('token');
    String? id=  prefs.getString('id');








    if(!pr.isShowing())
    {
      pr.style(
        textAlign: TextAlign.center,
        message: 'درحال ارتباط با سرور..',
        messageTextStyle: TextStyle(
            fontFamily:  'iranyekanbold',
            fontSize: 14,
            color: Colors.black87),
      );
      await  pr.show();
    }




    var headers = {
      'Authorization': 'Bearer '+token!
    };
    var request = http.MultipartRequest('POST', Uri.parse('http://31.7.67.183:2020/api/Barshomar/UnloadToWarehouse'));
    // request.fields.addAll({
    //   'body': '{\n  "truckId": $truckId,\n  "seoId": $id,\n  "enterDate" : $enterDate,\n  "exitDate" : $exitDate \n\n}'
    // });
    request.fields.addAll({
      'body': '{\n  "truckId": "$truckId",'
          '\n  "seoId": "$id",\n'
          '  "enterDate" : "$exitDate",\n'
          '  "exitDate" : "$exitDate"\n\n}'
    });

    request.headers.addAll(headers);


    try{
      http.StreamedResponse response = await request.send()
          .timeout(
          Duration(seconds: 10));


      if(response!=null)
      {
        if (response.statusCode == 200)
        {
          print('200');
          var data=await response.stream.bytesToString();
          var body=json.decode(data);
          bool isSuccess=body['isSuccess'];
          if(isSuccess)
          {

            ShowSnackbar('سرویس با موفقیت به سرور ارسال شد');
            Finall=true;
          }

        }
        else if(response.statusCode == 500){
          Finall=false;
          print('500');
          String data= await response.stream.bytesToString();
          var body=json.decode(data);
          ShowSnackbar(body['Message']);
        }
        else if(response.statusCode == 401){
           print('401');
           String? securityKey=prefs.getString('securityKey');
           print('Sec Is'+securityKey.toString());
          bool flag= await Login_Refresh(securityKey!, context, pr);
          if(flag)
            {
           Finall= await   Add_Tasck(pr,truckId,enterDate,exitDate,s,context);
            }else{
            Finall=false;
            print('401');
          }


        }
        else {
          Finall=false;
          print(response.reasonPhrase);
        }
      }else{
        Finall=false;
        pr.hide();
        ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
      }
    } on TimeoutException catch (_) {
      Finall=false;
      pr.hide();
      ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
    } on SocketException catch (_) {
      Finall=false;
      pr.hide();
      ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
    }






    pr.hide();

    return Finall;
  }



  static Future<bool> Add_Tasck_Saderat(ProgressDialog pr,String enterDate,BuildContext context,String id2) async{
    Modeldatalogin? login=null;



    bool Finall=false;







    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=  prefs.getString('token');
    String? id=  prefs.getString('id');








    if(!pr.isShowing())
    {
      pr.style(
        textAlign: TextAlign.center,
        message: 'درحال ارتباط با سرور..',
        messageTextStyle: TextStyle(
            fontFamily:  'iranyekanbold',
            fontSize: 14,
            color: Colors.black87),
      );
      await  pr.show();
    }




    var headers = {
      'Authorization': 'Bearer '+token!
    };
    var request = http.MultipartRequest('POST', Uri.parse('http://31.7.67.183:2020/api/Barshomar/EnterToShip'));
    // request.fields.addAll({
    //   'body': '{\n  "truckId": $truckId,\n  "seoId": $id,\n  "enterDate" : $enterDate,\n  "exitDate" : $exitDate \n\n}'
    // });
    request.fields.addAll({
      'body': '{\n  "SeoLoadServiceId": "$id2",\n '
          ' "enterDate" : "$enterDate"\n}\n'
    });

    request.headers.addAll(headers);


    try{
      http.StreamedResponse response = await request.send()
          .timeout(
          Duration(seconds: 10));


      if(response!=null)
      {
        if (response.statusCode == 200)
        {
          print('200');
          var data=await response.stream.bytesToString();
          var body=json.decode(data);
          bool isSuccess=body['isSuccess'];
          if(isSuccess)
          {

            ShowSnackbar('سرویس با موفقیت به سرور ارسال شد');
            Finall=true;
          }

        }
        else if(response.statusCode == 500){
          Finall=false;
          print('500');
          String data= await response.stream.bytesToString();
          var body=json.decode(data);
          ShowSnackbar(body['Message']);
        }
        else if(response.statusCode == 401){
          print('401');
          String? securityKey=prefs.getString('securityKey');
          print('Sec Is'+securityKey.toString());
          bool flag= await Login_Refresh(securityKey!, context, pr);
          if(flag)
          {
          Finall =await  Add_Tasck_Saderat(pr,enterDate,context,id2);
          }else{
            Finall=false;
            print('401');
          }


        }
        else {
          Finall=false;
          print(response.reasonPhrase);
        }
      }else{
        Finall=false;
        pr.hide();
        ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
      }
    } on TimeoutException catch (_) {
      Finall=false;
      pr.hide();
      ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
    } on SocketException catch (_) {
      Finall=false;
      pr.hide();
      ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
    }






    pr.hide();

    return Finall;
  }



  static Future<bool> SendAll(ProgressDialog pr,
      String t1,
  String t2
      ,String t3,String t4,BuildContext context) async{
    Modeldatalogin? login=null;



    bool Finall=false;







    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=  prefs.getString('token');
    String? id=  prefs.getString('id');








    // if(!pr.isShowing())
    // {
    //   pr.style(
    //     textAlign: TextAlign.center,
    //     message: 'درحال ارتباط با سرور..',
    //     messageTextStyle: TextStyle(
    //         fontFamily:  'iranyekanbold',
    //         fontSize: 14,
    //         color: Colors.black87),
    //   );
    //   await  pr.show();
    // }




    var headers = {
      'Authorization': 'Bearer '+token!
    };
    var request = http.MultipartRequest('POST', Uri.parse('http://31.7.67.183:2020/api/Barshomar/UnloadOneTime'));
    // request.fields.addAll({
    //   'body': '{\n  "truckId": $truckId,\n  "seoId": $id,\n  "enterDate" : $enterDate,\n  "exitDate" : $exitDate \n\n}'
    // });

    Jalali j = Jalali.now();

   String   Input_Date=j.year.toString()+'/'+j.month.toString()+'/'+j.day.toString();
      DateTime now = DateTime.now();
    String   Input_Time= DateFormat('kk:mm:ss').format(now);


    String string=Input_Date+' '+Input_Time.toString()
    ;



    request.fields.addAll({
      'body': '{\n'
          ' "seoId": "$id",\n '
          ' "enterDate" : "$string",\n '
          ' "exitDate" : "$string",\n'
          '  "carPlates": {\n   '
          '   "areaCode": $t4,\n  '
          '    "left": $t1,\n    '
          '  "middle": "$t2",\n  '
          '    "right": $t3\n  '
          '  }\n}\n'
    });

    request.headers.addAll(headers);


    try{
      http.StreamedResponse response = await request.send()
          .timeout(
          Duration(seconds: 10));


      if(response!=null)
      {
        if (response.statusCode == 200)
        {
          print('200');
          var data=await response.stream.bytesToString();
          var body=json.decode(data);
          bool isSuccess=body['isSuccess'];
          if(isSuccess)
          {

            ShowSnackbar('سرویس با موفقیت به سرور ارسال شد');
            Finall=true;
          }

        }
        else if(response.statusCode == 500){
          Finall=false;
          print('500');
          String data= await response.stream.bytesToString();
          var body=json.decode(data);
          ShowSnackbar(body['Message']);
        }
        else if(response.statusCode == 401){
          print('401');
          String? securityKey=prefs.getString('securityKey');
          print('Sec Is'+securityKey.toString());
          bool flag= await Login_Refresh(securityKey!, context, pr);
          if(flag)
          {
           Finall = await  SendAll(pr,t1,t2,t3,t4,context);
          }else{
            Finall=false;
            print('401');
          }


        }
        else {
          Finall=false;
          print(response.reasonPhrase);
        }
      }else{
        Finall=false;
        pr.hide();
        ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
      }
    } on TimeoutException catch (_) {
      Finall=false;
      pr.hide();
      ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
    } on SocketException catch (_) {
      Finall=false;
      pr.hide();
      ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
    }






    pr.hide();

    return Finall;
  }

  static Future<bool> Add_Tasck_ALL(ProgressDialog pr,String data,BuildContext context) async{
    Modeldatalogin? login=null;



    bool Finall=false;







    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=  prefs.getString('token');
    String? id=  prefs.getString('id');








    if(!pr.isShowing())
    {
      pr.style(
        textAlign: TextAlign.center,
        message: 'درحال ارتباط با سرور..',
        messageTextStyle: TextStyle(
            fontFamily:  'iranyekanbold',
            fontSize: 14,
            color: Colors.black87),
      );
      await  pr.show();
    }




    var headers = {
      'Authorization': 'Bearer '+token!
    };
    var request = http.MultipartRequest('POST', Uri.parse('http://31.7.67.183:2020/api/Barshomar/SaveOfflineService'));
    // request.fields.addAll({
    //   'body': '{\n  "truckId": $truckId,\n  "seoId": $id,\n  "enterDate" : $enterDate,\n  "exitDate" : $exitDate \n\n}'
    // });



    request.fields.addAll({
      'body':'\n $data'
    });

    request.headers.addAll(headers);


    try{
      http.StreamedResponse response = await request.send().timeout(
          Duration(seconds: 20));



      if(response!=null)
      {
        if (response.statusCode == 200)
        {
          print('200');
          var data=await response.stream.bytesToString();
          var body=json.decode(data);
          bool isSuccess=body['isSuccess'];
          if(isSuccess)
          {

            ShowSnackbar('سرویس با موفقیت به سرور ارسال شد');
            Finall=true;
          }

        }
        else if(response.statusCode == 500){
          Finall=false;
          print('500');
          String data= await response.stream.bytesToString();
          print(data.toString());
          var body=json.decode(data);
          ShowSnackbar(body['Message']);
        }
        else if(response.statusCode == 401){
          print('401');
          String? securityKey=prefs.getString('securityKey');
          print('Sec Is'+securityKey.toString());
          bool flag= await Login_Refresh(securityKey!, context, pr);
          if(flag)
          {
            Finall= await     Add_Tasck_ALL(pr,data,context);
          }else{
            Finall=false;
            print('401');
          }
        }
        else {
          Finall=false;
          print(response.reasonPhrase);
        }
      }else{
        Finall=false;
        pr.hide();
        ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
      }
    } on TimeoutException catch (_) {
      Finall=false;
      pr.hide();
      ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
    } on SocketException catch (_) {
      Finall=false;
      pr.hide();
      ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
    }






    pr.hide();

    return Finall;
  }




  static Future<bool> Add_Tasck_ALL_Saderat(ProgressDialog pr,String data,BuildContext context) async{
    Modeldatalogin? login=null;



    bool Finall=false;







    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=  prefs.getString('token');
    String? id=  prefs.getString('id');








    if(!pr.isShowing())
    {
      pr.style(
        textAlign: TextAlign.center,
        message: 'درحال ارتباط با سرور..',
        messageTextStyle: TextStyle(
            fontFamily:  'iranyekanbold',
            fontSize: 14,
            color: Colors.black87),
      );
      await  pr.show();
    }




    var headers = {
      'Authorization': 'Bearer '+token!
    };
    var request = http.MultipartRequest('POST', Uri.parse('http://31.7.67.183:2020/api/Barshomar/SaveOfflineLoadService'));
    // request.fields.addAll({
    //   'body': '{\n  "truckId": $truckId,\n  "seoId": $id,\n  "enterDate" : $enterDate,\n  "exitDate" : $exitDate \n\n}'
    // });



    request.fields.addAll({
      'body':'\n $data'
    });

    request.headers.addAll(headers);


    try{
      http.StreamedResponse response = await request.send().timeout(
          Duration(seconds: 20));



      if(response!=null)
      {
        if (response.statusCode == 200)
        {
          print('200');
          var data=await response.stream.bytesToString();
          var body=json.decode(data);
          bool isSuccess=body['isSuccess'];
          if(isSuccess)
          {

            ShowSnackbar('سرویس با موفقیت به سرور ارسال شد');
            Finall=true;
          }

        }
        else if(response.statusCode == 500){
          Finall=false;
          print('500');
          String data= await response.stream.bytesToString();
          print(data.toString());
          var body=json.decode(data);
          ShowSnackbar(body['Message']);
        }
        else if(response.statusCode == 401){
          print('401');
          String? securityKey=prefs.getString('securityKey');
          print('Sec Is'+securityKey.toString());
          bool flag= await Login_Refresh(securityKey!, context, pr);
          if(flag)
          {
            Finall= await     Add_Tasck_ALL_Saderat(pr,data,context);
          }else{
            Finall=false;
            print('401');
          }
        }
        else {
          print('401');
          String? securityKey=prefs.getString('securityKey');
          String? token=prefs.getString('token');
          print('Sec Is'+securityKey.toString());
             bool flag=  await     Add_Tasck_ALL_Saderat(pr,data,context);

          if(flag)
            {
              Finall=true;
            }else{
            Finall=false;
          }


          pr.hide();
          print('response.statusCode '+response.statusCode.toString());
          // pr.hide();
        }
      }else{
        Finall=false;
        pr.hide();
        ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
      }
    } on TimeoutException catch (_) {
      Finall=false;
      pr.hide();
      ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
    } on SocketException catch (_) {
      Finall=false;
      pr.hide();
      ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
    }






    pr.hide();

    return Finall;
  }







  static Future<List<Trucks>> GetTrucks_Saderat(String Token,BuildContext context,ProgressDialog pr) async{

    var MainData;
    final url = Uri.parse('http://31.7.67.183:2020/Api/Barshomar/GetBaseInfo');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: unrelated_type_equality_checks
    // pr.style(
    //   textAlign: TextAlign.center,
    //   message: 'در حال دریافت اطلاعات ',
    //   messageTextStyle: TextStyle(
    //       fontFamily:  'iranyekanbold',
    //       fontSize: 14,
    //       color: Colors.black87),
    // );
    // await  pr.show();






    var map = new Map<String, dynamic>();
    // map['token'] = jsonEncode({ "userName":toke.User,
    //   "password":toke.Pass}) ;
    //
    // map['countpage']=jsonEncode(PageCounterCustomer);
    // map['countpage']=PageCounterCustomer;



    // print('sgfsfgsdfgfdsg'+map.toString());

    try{
      Response response = await post(url,headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $Token',
      }
        ,).timeout(
        Duration(seconds: 50),
        onTimeout: () {
          pr.hide();
          return   ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
        },
      ).catchError((error) {
        pr.hide();
        print(error.toString());
        return   ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
        throw("some arbitrary error");
      });;
      if(response.statusCode==200)
      {
        print('Its Ok Request Nima');
        String data=response.body;
        print(data);
        var body=json.decode(data);
        var data1=body['data'];
        if(data1!=null)
        {
          print('Herre 23');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var trucks=data1['trucks'];
          var services=data1['services'];
          var seo=data1['seo'];
          print('My seo is '+ seo.toString());
          var shipName=seo['shipShipName']==null?'':seo['shipShipName'];
          var transportType1=seo['transportType']==null?'':seo['transportType'];
          var waterfrontName=seo['waterfrontWaterfrontName']==null?'':seo['waterfrontWaterfrontName'];
          var transportationCompanyCompanyName=seo['transportationCompanyCompanyName']==null?'':seo['transportationCompanyCompanyName'];
          var equipmentCompanyCompanyName=seo['equipmentCompanyCompanyName']==null?'':seo['equipmentCompanyCompanyName'];
          var counterCompanyCompanyName=seo['counterCompanyCompanyName']==null?'':seo['counterCompanyCompanyName'];
          var productOwnerCompanyCompanyName=seo['productOwnerCompanyCompanyName']==null?'':seo['productOwnerCompanyCompanyName'];
          var productCategoryName=seo['productCategoryName']==null?'':seo['productCategoryName'];
          var productName=seo['productProductName']==null?'':seo['productProductName'];
          var tonnageStr=seo['tonnageStr']==null?'':seo['tonnageStr'];
          var dischargedTonnageStr=seo['dischargedTonnageStr']==null?'':seo['dischargedTonnageStr'];
          var remainingTonnage=seo['remainingTonnage']==null?'':seo['remainingTonnage'];
          var shipEntranceDate=seo['shipEntranceDate']==null?'':seo['shipEntranceDate'];
          var shipEvacuationDate=seo['shipEvacuationDate']==null?'':seo['shipEvacuationDate'];
          var seoVersion=seo['seoVersion']==null?'':seo['seoVersion'];

          print('Trucksss'+trucks.toString());

          prefs.setString('shipName',shipName);
          prefs.setInt('transportType1',transportType1);
          prefs.setString('waterfrontName',waterfrontName);
          prefs.setString('transportationCompanyCompanyName',transportationCompanyCompanyName);
          prefs.setString('equipmentCompanyCompanyName',equipmentCompanyCompanyName);
          prefs.setString('counterCompanyCompanyName',counterCompanyCompanyName);
          prefs.setString('productOwnerCompanyCompanyName',productOwnerCompanyCompanyName);
          prefs.setString('productCategoryName',productCategoryName);
          prefs.setString('productName',productName);
          prefs.setString('tonnageStr',tonnageStr);
          prefs.setString('dischargedTonnageStr',dischargedTonnageStr);
          prefs.setString('remainingTonnage',remainingTonnage);
          prefs.setString('shipEntranceDate',shipEntranceDate);
          prefs.setString('shipEvacuationDate',shipEvacuationDate);
          prefs.setInt('seoVersion',seoVersion);
          if(seo['completedServices']!=null)
            {
              int i=seo['completedServices'];
              String shipId=seo['shipId'];
              String id=seo['id'];
              prefs.setInt('completedServices',i);
              prefs.setString('shipId',shipId);
              prefs.setString('id',id);
            }

          if(seo['shipShipName']!=null)
          {
            String i1=seo['shipShipName'];
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('shipName',i1);
          }



            prefs.setBool('LoginBarshomar',true);



          if(trucks!=null)
          {
            print('1414141414141414141414141');
            List<Trucks> MainData=[];
           for(int i=0;i<trucks.length;i++)
             {
               print(trucks[i]['id'],);

               var truckNumberId='';
               var truckTruckName='';
               var qrcode='';
               var carPlates='';
               var exit='';
               var telephone='';
               var id='';
               print('data is'+trucks[i]['id']);
               if(trucks[i]['truckNumberId']!=null)
                 {
                   truckNumberId=trucks[i]['truckNumberId'];
                 }

               if(trucks[i]['truckTruckName']!=null)
               {
                 truckTruckName=trucks[i]['truckTruckName'];
               }


               if(trucks[i]['qrcode']!=null)
               {
                 qrcode=trucks[i]['qrcode'];
               }


               if(trucks[i]['carPlates']!=null)
               {
                 carPlates=trucks[i]['carPlates'];
               }



               if(trucks[i]['exit']!=null)
               {
                 exit=trucks[i]['exit'];
               }



               if(trucks[i]['telephone']!=null)
               {
                 telephone=trucks[i]['telephone'];
               }


               if(trucks[i]['id']!=null)
               {
                 id=trucks[i]['id'];
               }
               MainData.add(Trucks(truckNumberId, truckTruckName
                   , qrcode, carPlates,exit, telephone,id));
             }



             await  DataBseFile.db.Insert_Allof_Customer(MainData, context, pr);




            List<DataModelAnbarService> MainData1=[];
            // print(services.toString());

            print('0000000000000');
            if(services!=null)
            {

              for(int i=0;i<services.length;i++)
              {


                var exitWarehouse='';
                var enterToShip='';
                var carPlatesAreaCode=0;
                var carPlatesLeft=0;
                var carPlatesMiddle='';
                var carPlatesRight=0;
                var carPlates='';
                var truckTruckNumberId='';
                var truckTruckName='';
                var id='';

                if(services[i]['exitWarehouse']!=null)
                {
                  exitWarehouse=services[i]['exitWarehouse'];
                }

                if(services[i]['enterToShip']!=null)
                {
                  enterToShip=services[i]['enterToShip'];
                }
                //
                //
                if(services[i]['carPlatesAreaCode']!=null)
                {
                  carPlatesAreaCode=services[i]['carPlatesAreaCode'];
                }
                //
                //
                if(services[i]['carPlatesLeft']!=null)
                {
                  carPlatesLeft=services[i]['carPlatesLeft'];
                }
                //
                //
                //
                if(services[i]['carPlatesMiddle']!=null)
                {
                  carPlatesMiddle=services[i]['carPlatesMiddle'];
                }
                //
                //
                //
                if(services[i]['carPlatesRight']!=null)
                {
                  carPlatesRight=services[i]['carPlatesRight'];
                }
                //
                //
                if(services[i]['carPlates']!=null)
                {
                  carPlates=services[i]['carPlates'];
                }
                //
                if(services[i]['truckTruckNumberId']!=null)
                {
                  truckTruckNumberId=services[i]['truckTruckNumberId'];
                }
                //
                if(services[i]['truckTruckName']!=null)
                {
                  truckTruckName=services[i]['truckTruckName'];
                }
                //
                if(services[i]['id']!=null)
                {
                  id=services[i]['id'];
                }

                MainData1.add(DataModelAnbarService('', ''
                    '','',exitWarehouse,0,truckTruckName,carPlates,truckTruckNumberId,id,'','','',''));

              }
















              // ShowSnackbar('ورود با موففقیت انجام شد');
            }




            print('6556655665656556566');


            if(transportType1==1)
            {
              print('022002020202');
              pr.hide();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context)
                => MainPage_Saderat(MainData1)),
                    (Route<dynamic> route) => false,
              );
            }else{
              print('636363636363');
              DataBseFile.db.Insert_Allof_Customer(MainData,context,pr);
              // pr.hide();
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(builder: (context) => MainPage()),
              //       (Route<dynamic> route) => false,
              // );
            }



            // ShowSnackbar('ورود با موففقیت انجام شد');
          }else{
            print('78778878787878787878');
            if(transportType1.toString()=='1')
              {
                pr.hide();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                      (Route<dynamic> route) => false,
                );
              }else{
              pr.hide();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage_Saderat([])),
                    (Route<dynamic> route) => false,
              );
            }

          }
        }
        else{
          pr.hide();
        }
      }else if(response.statusCode==401) {
        print('401');
        String? securityKey=prefs.getString('securityKey');
        print('Sec Is'+securityKey.toString());
        bool flag= await Login_Refresh(securityKey!, context, pr);

          await     GetTrucks_Saderat(Token,context,pr);

        pr.hide();
        print('response.statusCode '+response.statusCode.toString());
        // pr.hide();
      }
      else if(response.statusCode==403) {


        ShowSnackbar('کاربر یافت نشد');
        pr.hide();
        print('response.statusCode '+response.statusCode.toString());
        // pr.hide();
      }

      else{
        print(response.statusCode.toString());
        ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
        MainData= null;
        pr.hide();
      }
    }catch (e)
    {
      print('Eeror is Herer'+e.toString());
      ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
      MainData= null;
      pr.hide();

    }
    return MainData;
  }



  static Future<List<DataModelAnbarService>> GetTrucks_Saderat_Ref(String Token,BuildContext context,ProgressDialog pr) async{

    var MainData;
    final url = Uri.parse('http://31.7.67.183:2020/Api/Barshomar/GetBaseInfo');
    List<DataModelAnbarService> MainData1=[];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: unrelated_type_equality_checks
    pr.style(
      textAlign: TextAlign.center,
      message: 'در حال دریافت اطلاعات ',
      messageTextStyle: TextStyle(
          fontFamily:  'iranyekanbold',
          fontSize: 14,
          color: Colors.black87),
    );
    await  pr.show();






    var map = new Map<String, dynamic>();
    // map['token'] = jsonEncode({ "userName":toke.User,
    //   "password":toke.Pass}) ;
    //
    // map['countpage']=jsonEncode(PageCounterCustomer);
    // map['countpage']=PageCounterCustomer;



    // print('sgfsfgsdfgfdsg'+map.toString());

    try{
      Response response = await post(url,headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $Token',
      }
        ,).timeout(
        Duration(seconds: 50),
        onTimeout: () {
          pr.hide();
          return   ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
        },
      ).catchError((error) {
        pr.hide();
        print(error.toString());
        return   ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
        throw("some arbitrary error");
      });;
      if(response.statusCode==200)
      {
        print('Its Ok Request Nima');
        String data=response.body;
        print(data);
        var body=json.decode(data);
        var data1=body['data'];
        if(data1!=null)
        {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var trucks=data1['trucks'];
          var services=data1['services'];
          var seo=data1['seo'];
          print('My seo is '+ seo.toString());
          var shipName=seo['shipShipName']==null?'':seo['shipShipName'];
          var transportType1=seo['transportType']==null?'':seo['transportType'];
          var waterfrontName=seo['waterfrontWaterfrontName']==null?'':seo['waterfrontWaterfrontName'];
          var transportationCompanyCompanyName=seo['transportationCompanyCompanyName']==null?'':seo['transportationCompanyCompanyName'];
          var equipmentCompanyCompanyName=seo['equipmentCompanyCompanyName']==null?'':seo['equipmentCompanyCompanyName'];
          var counterCompanyCompanyName=seo['counterCompanyCompanyName']==null?'':seo['counterCompanyCompanyName'];
          var productOwnerCompanyCompanyName=seo['productOwnerCompanyCompanyName']==null?'':seo['productOwnerCompanyCompanyName'];
          var productCategoryName=seo['productCategoryName']==null?'':seo['productCategoryName'];
          var productName=seo['productProductName']==null?'':seo['productProductName'];
          var tonnageStr=seo['tonnageStr']==null?'':seo['tonnageStr'];
          var dischargedTonnageStr=seo['dischargedTonnageStr']==null?'':seo['dischargedTonnageStr'];
          var remainingTonnage=seo['remainingTonnage']==null?'':seo['remainingTonnage'];
          var shipEntranceDate=seo['shipEntranceDate']==null?'':seo['shipEntranceDate'];
          var shipEvacuationDate=seo['shipEvacuationDate']==null?'':seo['shipEvacuationDate'];
          var seoVersion=seo['seoVersion']==null?'':seo['seoVersion'];


          prefs.setString('shipName',shipName);
          prefs.setInt('transportType1',transportType1);
          prefs.setString('waterfrontName',waterfrontName);
          prefs.setString('transportationCompanyCompanyName',transportationCompanyCompanyName);
          prefs.setString('equipmentCompanyCompanyName',equipmentCompanyCompanyName);
          prefs.setString('counterCompanyCompanyName',counterCompanyCompanyName);
          prefs.setString('productOwnerCompanyCompanyName',productOwnerCompanyCompanyName);
          prefs.setString('productCategoryName',productCategoryName);
          prefs.setString('productName',productName);
          prefs.setString('tonnageStr',tonnageStr);
          prefs.setString('dischargedTonnageStr',dischargedTonnageStr);
          prefs.setString('remainingTonnage',remainingTonnage);
          prefs.setString('shipEntranceDate',shipEntranceDate);
          prefs.setString('shipEvacuationDate',shipEvacuationDate);
          prefs.setInt('seoVersion',seoVersion);
          if(seo['completedServices']!=null)
          {
            int i=seo['completedServices'];
            String shipId=seo['shipId'];
            String id=seo['id'];
            prefs.setInt('completedServices',i);
            prefs.setString('shipId',shipId);
            prefs.setString('id',id);
          }

          if(seo['shipShipName']!=null)
          {
            String i1=seo['shipShipName'];
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('shipName',i1);
          }



          prefs.setBool('LoginBarshomar',true);

          if(trucks!=null)
          {
            List<Trucks> MainData=[];
            for(int i=0;i<trucks.length;i++)
            {
              print(trucks[i]['id'],);

              var truckNumberId='';
              var truckTruckName='';
              var qrcode='';
              var carPlates='';
              var exit='';
              var telephone='';
              var id='';
              print('data is'+trucks[i]['id']);
              if(trucks[i]['truckNumberId']!=null)
              {
                truckNumberId=trucks[i]['truckNumberId'];
              }

              if(trucks[i]['truckTruckName']!=null)
              {
                truckTruckName=trucks[i]['truckTruckName'];
              }


              if(trucks[i]['qrcode']!=null)
              {
                qrcode=trucks[i]['qrcode'];
              }


              if(trucks[i]['carPlates']!=null)
              {
                carPlates=trucks[i]['carPlates'];
              }



              if(trucks[i]['exit']!=null)
              {
                exit=trucks[i]['exit'];
              }



              if(trucks[i]['telephone']!=null)
              {
                telephone=trucks[i]['telephone'];
              }


              if(trucks[i]['id']!=null)
              {
                id=trucks[i]['id'];
              }


              MainData.add(Trucks(truckNumberId, truckTruckName
                  , qrcode, carPlates,exit, telephone,id));
            }


            print(services.toString());
            if(services!=null)
            {

              for(int i=0;i<services.length;i++)
              {


                var exitWarehouse='';
                var enterToShip='';
                var carPlatesAreaCode=0;
                var carPlatesLeft=0;
                var carPlatesMiddle='';
                var carPlatesRight=0;
                var carPlates='';
                var truckTruckNumberId='';
                var truckTruckName='';
                var id='';

                if(services[i]['exitWarehouse']!=null)
                {
                  exitWarehouse=services[i]['exitWarehouse'];
                }

                if(services[i]['enterToShip']!=null)
                {
                  enterToShip=services[i]['enterToShip'];
                }


                if(services[i]['carPlatesAreaCode']!=null)
                {
                  carPlatesAreaCode=services[i]['carPlatesAreaCode'];
                }


                if(services[i]['carPlatesLeft']!=null)
                {
                  carPlatesLeft=services[i]['carPlatesLeft'];
                }



                if(services[i]['carPlatesMiddle']!=null)
                {
                  carPlatesMiddle=services[i]['carPlatesMiddle'];
                }



                if(services[i]['carPlatesRight']!=null)
                {
                  carPlatesRight=services[i]['carPlatesRight'];
                }


                if(services[i]['carPlates']!=null)
                {
                  carPlates=services[i]['carPlates'];
                }

                if(services[i]['truckTruckNumberId']!=null)
                {
                  truckTruckNumberId=services[i]['truckTruckNumberId'];
                }

                if(services[i]['truckTruckName']!=null)
                {
                  truckTruckName=services[i]['truckTruckName'];
                }

                if(services[i]['id']!=null)
                {
                  id=services[i]['id'];
                }
                MainData1.add(DataModelAnbarService('', ''
                    '','',exitWarehouse,0,truckTruckName,carPlates,truckTruckNumberId,id,'','','',''));

              }
















              // ShowSnackbar('ورود با موففقیت انجام شد');
            }




            if(transportType1==1)
            {
              pr.hide();

            }else{
              DataBseFile.db.Insert_Allof_Customer(MainData,context,pr);
              // pr.hide();
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(builder: (context) => MainPage()),
              //       (Route<dynamic> route) => false,
              // );
            }



            // ShowSnackbar('ورود با موففقیت انجام شد');
          }else{
            pr.hide();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
                  (Route<dynamic> route) => false,
            );
          }
        }
        else{
          pr.hide();
        }
      }else if(response.statusCode==401) {
        print('401');
        String? securityKey=prefs.getString('securityKey');
        print('Sec Is'+securityKey.toString());
        bool flag= await Login_Refresh(securityKey!, context, pr);
        String? Token2=prefs.getString('token');
        if(flag)
          {
            await     GetTrucks_Saderat_Ref(Token2!,context,pr);
          }else{
          pr.hide();
          await  prefs.clear();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
          );
        }


        pr.hide();
        print('response.statusCode '+response.statusCode.toString());
        // pr.hide();
      }
      else if(response.statusCode==403) {


        ShowSnackbar('کاربر یافت نشد');
        pr.hide();
        print('response.statusCode '+response.statusCode.toString());
        // pr.hide();
      }
    }catch (e)
    {
      print('Eeror is Herer'+e.toString());
      ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده است');
      MainData1= [];
      pr.hide();

    }
    return MainData1;
  }
}