import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../ApiService.dart';
import 'MainPage.dart';
import 'MainPageSaderatOffline.dart';
import 'const.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ShowSnackbar(String Msg){
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

  Future<String>  Conv(String S) async{
    var dd = '';
// ۱۲۳۴۵۶۷۸۹
    List<String> Departments = <String>[];
// for (i in S) {
    for (int i=0;i<S.length;i++) {
      if (S[i] == '۱') {
        dd = dd + '1';

      } else if (S[i] == '۲') {

        dd = dd + '2';

      } else if (S[i] == '۳') {
        dd = dd + '3';

      } else if (S[i] == '۰') {
        dd = dd + '0';

      } else if (S[i] == '۴') {
        dd = dd + '4';

      } else if (S[i] == '۵') {
        dd = dd + '5';

      } else if (S[i] == '۶') {
        dd = dd + '6';

      } else if (S[i] == '۷') {
        dd = dd + '7';


      } else if (S[i] == '۸') {
        dd = dd + '8';

      } else if (S[i] == '۹') {
        dd = dd + '9';
      } else {
        dd = dd + S[i].toString();
      }


    }
    return  dd;
  }
  Future Login_APP(String USERNAME,String Password,ProgressDialog pr) async
  {
    if(USERNAME.isEmpty)
    {
      ShowSnackbar('نام کاربری را وارد کنید');
      return;
    }


    if(Password.isEmpty)
    {
      ShowSnackbar('رمز عبور را وارد کنید');
      return;
    }









    FocusScope.of(context).unfocus();




    String txt_user=  await Conv(USERNAME);
    String txt_pass=  await Conv(Password);


    var Loginchaeck=await ApiService.Login(txt_user, txt_pass,context,pr);

    // if(Loginchaeck!=null)
    // {
    //   if(Loginchaeck.isSuccess)
    //   {
    //     // print('Check_Remember'+Check_Remember.toString());
    //     // USERNAME= await USERNAME.toString().replaceAll('ک', 'ك');
    //     // USERNAME= await USERNAME.toString().replaceAll('ی', 'ي');
    //     // Password= await Password.toString().replaceAll('ک', 'ك');
    //     // Password= await Password.toString().replaceAll('ی', 'ي');
    //     // USERNAME =await Conv(USERNAME);
    //     // Password =await Conv(Password);
    //     // await Save(context,Loginchaeck.result,USERNAME,Password,Check_Remember,Loginchaeck.Token);
    //     // Navigator.pushAndRemoveUntil(
    //     //   context,
    //     //   MaterialPageRoute(builder: (context) => ScreenMain()),
    //     //       (Route<dynamic> route) => false,
    //     // );
    //   }else{
    //     print('A');
    //     // ShowSnackbar(Loginchaeck.msg);
    //   }
    // }else{
    //   ShowSnackbar('مشکلی در ارتباط با سرور به وجود آمده');
    // }
  }


  var text_1=TextEditingController();
  var text_2=TextEditingController();


 bool LoginApp=false;

  Future GetData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      LoginApp=   prefs.getBool('LoginBarshomar')!;
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetData();
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Align(
            alignment: Alignment.topRight,
            child: Text('مجوز',textAlign: TextAlign.right,)),
        content:
        SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const <Widget>[
                Text('? برای خروج   اطمینان دارید',textAlign: TextAlign.end,),
              ],
            ),
          ),
        )
        ,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child:  Text('نه',style: TextStyle(fontSize: 16)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child:  Text('بله',style: TextStyle(fontSize: 16),),
          ),
        ],
      ),
    )) ?? false;
  }
  var pr;
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
           body: Container(
             height: double.infinity,
             width: double.infinity,
             decoration: BoxDecoration(
                 color: Color(0xff091119),

             ),
             child: Column(
               children: [
                 Expanded(
                   flex: 14,
                   child: SingleChildScrollView(
                     child: Column(
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(top: 48.0),
                           child:  Image.asset('assets/png/logoapp.png',width: 220,height: 220,),
                         ),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('شرکت  حمل و نقل  هیرمان',style: TextStyle(
                               color: Colors.white,
                               fontSize: 12,
                               fontWeight: FontWeight.bold
                           ),),
                         ),
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8),
                           child: Container(
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(16),
                               color: Color(0xff333C42),
                             ),
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: TextField(
                                   controller: text_1,
                                   style: TextStyle(color: Colors.white),
                                   textAlign: TextAlign.end,
                                   decoration: InputDecoration(
                                       contentPadding: EdgeInsets.all(8),
                                       border: InputBorder.none,
                                       hintStyle: TextStyle(color: Colors.white),
                                       hintText: 'نام کاربری')
                               ),
                             ),
                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8),
                           child: Container(
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(16),
                               color: Color(0xff333C42),
                             ),
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: TextField(
                                   style: TextStyle(color: Colors.white),
                                   controller: text_2,
                                   textAlign: TextAlign.end,
                                   decoration: InputDecoration(
                                       contentPadding: EdgeInsets.all(8),
                                       border: InputBorder.none,
                                       hintStyle: TextStyle(color: Colors.white),
                                       hintText: 'رمز عبور')
                               ),
                             ),
                           ),
                         ),
                         GestureDetector(
                           onTap: (){
                             Navigator.pushAndRemoveUntil(
                               context,
                               MaterialPageRoute(builder: (context) => MainPage()),
                                   (Route<dynamic> route) => false,
                             );
                           },
                           child: GestureDetector(
                             onTap: (){
                               Login_APP(text_1.text, text_2.text,pr);
                             },
                             child: Container(
                               width: double.infinity,
                               height: 65,
                               margin: EdgeInsets.symmetric(horizontal: 64,vertical: 32),
                               decoration: BoxDecoration(
                                   color:BaseColor,
                                   boxShadow: [
                                     BoxShadow(
                                       color: BaseColor.withOpacity(0.35),
                                       spreadRadius: 3,
                                       blurRadius: 4,
                                       offset: Offset(0, 0), // changes position of shadow
                                     ),
                                   ],
                                   borderRadius: BorderRadius.circular(16)
                               ),
                               child: Center(child: Text('ورود',style: TextStyle(
                                   color: Colors.white,
                                   fontWeight: FontWeight.bold,
                                   fontSize: 18
                               ),)),
                             ),
                           ),
                         ),
                         LoginApp?
                         GestureDetector(
                           onTap: () async{
                             SharedPreferences prefs = await SharedPreferences.getInstance();
                          int? transportType1=   prefs.getInt('transportType1');
                             if(transportType1==1)
                             {
                               print('transportType1 is 1');
                               pr.hide();
                               Navigator.pushAndRemoveUntil(
                                 context,
                                 MaterialPageRoute(builder: (context)
                                 => MainPageSaderatOffline()),
                                     (Route<dynamic> route) => false,
                               );
                             }else{
                               print('transportType1 is 2');
                               Navigator.pushAndRemoveUntil(
                                 context,
                                 MaterialPageRoute(builder: (context) => MainPage()),
                                     (Route<dynamic> route) => false,
                               );
                               // pr.hide();
                               // Navigator.pushAndRemoveUntil(
                               //   context,
                               //   MaterialPageRoute(builder: (context) => MainPage()),
                               //       (Route<dynamic> route) => false,
                               // );
                             }

                           },
                           child: Padding(
                             padding: const EdgeInsets.all(16.0),
                             child: Text('ورود افلاین',style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold
                             ),),
                           ),
                         ):Container()
                       ],
                     ),
                   ),
                 ),
                 Expanded(
                     flex: 1,
                     child: Container(
                       width: double.infinity,
                       color: BaseColor,
                       child:  Row(
                         children: [
                           Expanded(
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text('بارشمار',
                                 textAlign: TextAlign.end,
                                 style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 18,
                                     fontWeight: FontWeight.bold
                                 ),),
                             ),
                           ),
                         ],
                       ),
                     ))

               ],
             ),
           ),
        ),
      ),
    );
  }
}
