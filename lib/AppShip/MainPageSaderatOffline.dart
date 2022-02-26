import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../ApiService.dart';
import 'DataBseFile.dart';
import 'DataModelAnbarService.dart';
import 'MainPage.dart';
import 'SaveOfflineService.dart';
import 'Trucks.dart';
import 'const.dart';

class MainPageSaderatOffline extends StatefulWidget {


  @override
  State<MainPageSaderatOffline> createState() => _MainPageSaderatOfflineState();

}

class _MainPageSaderatOfflineState extends State<MainPageSaderatOffline> {




  Future  GetSer() async{
    var  data= await   DataBseFile.db.GetService();
    if(data.length>0)
      {
         setState(() {
           DataBaseTrucks=data;
         });
      }
  }

  Future Run(String datatemp)async{

    if(datatemp.isEmpty)
      {
        ShowSnackbar('کد کامیون را وارد کنید');
        return;
      }


    FocusScope.of(context).unfocus();

    var  data= await   DataBseFile.db.GetCustomers();
     print(data.toString());
    var rr=  data.where((element) =>element.truckNumberId.toString().contains(datatemp)).toList();
    if(datatemp.isNotEmpty)
      {
        if(rr.length>0)
          {
            setState(()  {
              print(rr[0].ToMapDatabase().toString());
              data_truck=rr[0];
            });
          }else{
          data_truck.truckNumberId='-77';
        }
      }
    else{
      setState(() {
        data_truck.truckNumberId='-77';
      });
    }
  }
  String Input_Time='';
  String Input_Date='';
  String OutPut_Time='';
  String OutPut_Date='';

  List<Trucks> DataBaseTrucks=[];




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
  var txt=TextEditingController();
    Trucks data_truck=new Trucks('-77', 'truckName', '', '','', '', '');
    // Trucks data_truck=new Trucks('-77888', 'truckName', '', '', '', '');
    Future getda() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getInt('completedServices')!=null){
      completedServices=prefs.getInt('completedServices')!;
    }  ;


      if(prefs.getInt('shipName')!=null){
        shipName=prefs.getString('shipName')!;
      }  ;




    }



    Future  Run_Add_Tasc(ProgressDialog progressDialog,String truckId) async{











      String ss_1=Input_Date+' '+Input_Time;

      // String ss_2=OutPut_Date+' '+OutPut_Time;

      print('Data Is'+truckId);
      _showMyDialog(progressDialog,truckId,ss_1);



    }

 Future   Run_Act(ProgressDialog progressDialog,String truckId,String enterDate) async
    {


      print('Data is'+enterDate);
      print('Data is'+data_truck.truckNumberId);
      print('Data is'+data_truck.truckTruckName);
      print('Data is'+data_truck.carPlates);
      print('Data is'+data_truck.id);

      DataModelAnbarService service=DataModelAnbarService(enterDate,enterDate,'','',0,data_truck.truckTruckName,data_truck.carPlates,
      data_truck.truckNumberId,'','','','',data_truck.id);
       var dad= await DataBseFile.db.newSaderat(service);
       setState(() {
         txt.clear();
         data_truck.truckNumberId='-77';
       });
       ShowSnackbar('سرویس با موفقیت ثبت شد');
    }




  Future   Run_Act_All(ProgressDialog progressDialog,) async
  {
    List<SaveOfflineService>  dat=[];

    String  datae='[';
    if(DataBaseTrucks.length>0)
      {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? id=  prefs.getString('id');
        DataBaseTrucks.forEach((element) {
          String exit=element.exit;
          String id2=element.id;
            datae=datae+
                '\n{\n  "enter" : "1400/08/30 14:02",\n  "exit" : "1400/08/30 14:16",\n '
                    ' "truckId": "09a1186e-3e57-ec11-b448-2c337a716e30",\n'
                    '  "seoId": "96734a1c-3e57-ec11-b448-2c337a716e30",\n  "warehouseId"'
                    ' : "a9e3f922-3c57-ec11-b448-2c337a716e30"\n},\n ';



        });

        datae= datae.substring(1, datae.length-1);
        datae='['+datae+']';
        print(datae.toString());
        bool test=  await ApiService.Add_Tasck_ALL(progressDialog,datae,context) ;
        if(test)
        {
          completedServices=completedServices+DataBaseTrucks.length;
          await DataBseFile.db.Del();
          ShowSnackbar('عملیات با موفقیت انجام شد');
          setState(() {
            data_truck.truckNumberId='-77';
            completedServices=completedServices+DataBaseTrucks.length;
            DataBaseTrucks.clear();
            OutPut_Date='';
            OutPut_Time='';
            txt.clear();
          });
        }
      }


  }





  Future<void> _showMyDialog(ProgressDialog progressDialog,String truckId,String enterDate) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Align(
              alignment: Alignment.topRight,
              child: Text('مجوز')),
          content: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const <Widget>[
                  Text('آيا عملیات انجام شود؟',textAlign: TextAlign.end,),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('بله'),
              onPressed: () {
                Navigator.of(context).pop();
                Run_Act(progressDialog,truckId,enterDate);
              },
            ),
            TextButton(
              child: const Text('خیر'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }
  Future<void> _showMyDialog_All(ProgressDialog progressDialog) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Align(
              alignment: Alignment.topRight,
              child: Text('مجوز')),
          content: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const <Widget>[
                  Text('آيا عملیات انجام شود؟',textAlign: TextAlign.end,),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('بله'),
              onPressed: () {
                Navigator.of(context).pop();
                Run_Act_All(progressDialog);
              },
            ),
            TextButton(
              child: const Text('خیر'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }


  String    Convert_DATE(String day,String month,String year)
  {
    var temp_day="";
    var temp_mont="";
    if (day.length==1)
    {
      temp_day="0"+day;
    }else{
      temp_day=day;
    }
    if (month.length==1)
    {
      temp_mont="0"+month;
    }else{
      temp_mont=month;
    }





    return  (year+"/"+temp_mont+"/"+temp_day).toString();


  }


  var pr;
  String shipName='';
  var waterfrontName='';
  String transportationCompanyCompanyName='';
  String equipmentCompanyCompanyName='';
  String counterCompanyCompanyName='';
  String productOwnerCompanyCompanyName='';
  String productCategoryName='';
  String productName='';
  String tonnageStr='';
  String dischargedTonnageStr='';
  String remainingTonnage='';
  String shipEntranceDate='';
  String shipEvacuationDate='';
  int seoVersion=0;
  int completedServices=0;






  Future GetSData() async
    {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
          // shipName=prefs.getString('shipName')!;
          if(prefs.getString('waterfrontName')!=null)
            {
              waterfrontName=prefs.getString('waterfrontName')!;
            }

          transportationCompanyCompanyName=prefs.getString('transportationCompanyCompanyName')!;
          equipmentCompanyCompanyName=prefs.getString('equipmentCompanyCompanyName')!;
          counterCompanyCompanyName=prefs.getString('counterCompanyCompanyName')!;
          productOwnerCompanyCompanyName=prefs.getString('productOwnerCompanyCompanyName')!;
          productCategoryName=prefs.getString('productCategoryName')!;
          productName=prefs.getString('productName')!;
          tonnageStr=prefs.getString('tonnageStr')!;
          dischargedTonnageStr=prefs.getString('dischargedTonnageStr')!;
          remainingTonnage=prefs.getString('remainingTonnage')!;
          shipEntranceDate=prefs.getString('shipEntranceDate')!;
          shipEvacuationDate=prefs.getString('shipEvacuationDate')!;
          shipName=prefs.getString('shipName')!;
          seoVersion=prefs.getInt('seoVersion')!;
          completedServices=prefs.getInt('completedServices')!;

      });


    }
  String Flag_Page='0';
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetSData();
    GetTrucksDatabase();
    pr = ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: false);
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
  List<Trucks> tr=[];
  Future  GetTrucksDatabase() async{
    print('AAAA');

    var  data= await   DataBseFile.db.GetCustomers();


    if(data.length>0)
    {
      print('BBBB');
      setState(() {
        tr=data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xff091119),
          ),
          child:Column(
            children: [
              Flag_Page=='0'?
              Main_Page():
              Flag_Page=='2'?
              Expanded(
                  flex: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff091119),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8)
                                ),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors:[
                                      Color(0xff0A131D),
                                      Color(0xff1F2B38)
                                    ]
                                )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 24.0,right: 8),
                                            child: Image.asset('assets/png/shipp.png',),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16.0,right: 16.0,left: 24),
                                            child: Text(
                                              // widget.datamain[item].truckTruckName==null?'نامشخص':
                                              // widget.datamain[item].truckTruckName,
                                              'صادرات',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color: BaseColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 16,),
                                              child: Text(
                                                shipName.isEmpty?'بدون نام':
                                                shipName,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                ),),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(completedServices.toString(),style: TextStyle(
                                                      color: Color(0xffF7FF00),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text('سرویس های انجام شده',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(
                                                      shipName==null||shipName.isEmpty?
                                                       'نامشخص':
                                                      shipName
                                                      ,style: TextStyle(
                                                      color: Color(0xffF7FF00),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(' کشتی',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(
                                                      waterfrontName==null||waterfrontName.isEmpty?
                                                        'نامشخص':
                                                      waterfrontName
                                                      ,style: TextStyle(
                                                      color: Color(0xffF7FF00),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(' اسکله',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(
                                                      transportationCompanyCompanyName==null||transportationCompanyCompanyName.isEmpty?
                                                      'نامشخص':
                                                      transportationCompanyCompanyName
                                                    ,style: TextStyle(
                                                      color: Color(0xffF7FF00),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(' شرکت حمل و نقل',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(
                                                      equipmentCompanyCompanyName==null||equipmentCompanyCompanyName.isEmpty?
                                                      'نامشخص':
                                                      equipmentCompanyCompanyName
                                                    ,style: TextStyle(
                                                      color: Color(0xffF7FF00),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(' شرکت تجهیزاتی',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(
                                                      productCategoryName==null||productCategoryName.isEmpty?
                                                      'نامشخص':
                                                      productCategoryName
                                                      ,style: TextStyle(
                                                      color: Color(0xffF7FF00),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(' دسته بندی کالا',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(
                                                      productName==null||productName.isEmpty?
                                                      'نامشخص':
                                                      productName
                                                      ,style: TextStyle(
                                                      color: Color(0xffF7FF00),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(' اسم کالا',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(
                                                      tonnageStr==null||tonnageStr.isEmpty?
                                                      'نامشخص':
                                                      tonnageStr
                                                      ,style: TextStyle(
                                                      color: Color(0xffF7FF00),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(' تناژ',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(
                                                      dischargedTonnageStr==null||dischargedTonnageStr.isEmpty?
                                                      'نامشخص':
                                                      dischargedTonnageStr
                                                      ,style: TextStyle(
                                                      color: Color(0xffF7FF00),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(' تناژ تخلیه شده',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(
                                                      remainingTonnage==null||remainingTonnage.isEmpty?
                                                      'نامشخص':
                                                      remainingTonnage
                                                      ,style: TextStyle(
                                                      color: Color(0xffF7FF00),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(' تناژ باقی مانده',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(
                                                      shipEntranceDate==null||shipEntranceDate.isEmpty?
                                                      'نامشخص':
                                                      shipEntranceDate
                                                      ,style: TextStyle(
                                                      color: Color(0xffF7FF00),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(' تاریخ ورود کشتی',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(
                                                      shipEvacuationDate==null||shipEvacuationDate.isEmpty?
                                                      'نامشخص':
                                                      shipEvacuationDate
                                                      ,style: TextStyle(
                                                      color: Color(0xffF7FF00),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(' تاریخ شروع تخلیه',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(
                                                      seoVersion==null?
                                                      'نامشخص':
                                                      seoVersion.toString()
                                                      ,style: TextStyle(
                                                      color: Color(0xffF7FF00),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                                    child: Text(' ورژن سئو',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
                                    child: Text('لیست کامیون های فعال',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white
                                      ),),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: ListView.builder(
                                      itemCount: tr.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (ctx,item){
                                        return NewWidget(
                                            tr[item].truckTruckName.toString(),
                                            tr[item].truckNumberId.toString(),
                                            tr[item].carPlates.toString(),
                                            tr[item].telephone.toString());
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )):
              Flag_Page=='1'?
              Expanded(
                  flex: 8,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8)
                              ),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors:[
                                    Color(0xff0A131D),
                                    Color(0xff1F2B38)
                                  ]
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 24.0,right: 8),
                                      child: Image.asset('assets/png/shipp.png',),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0,right: 16.0,left: 24),
                                      child: Text(
                                        // widget.datamain[item].truckTruckName==null?'نامشخص':
                                        // widget.datamain[item].truckTruckName,
                                        'صادرات',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          color: BaseColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 16,),
                                        child: Text(
                                          shipName.isEmpty?'بدون نام':
                                          shipName,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0,right: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                              child: Text(completedServices.toString(),style: TextStyle(
                                                color: Color(0xffF7FF00),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                              child: Text('سرویس های انجام شده',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0,right: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                              child: Text('سرویس های ایجاد شده در دستگاه',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  color:Color(0xffF7FF00),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        DataBaseTrucks.length>0
                            ?
                        GestureDetector(
                          onTap: (){
                            _showMyDialog_All(pr);
                          },
                          child: Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color:
                                Color(0xffF7FF00),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                child: Text('  ارسال همه اطلاعات  ',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),),
                              ),
                            ),
                          ),
                        ):Container(),
                        Expanded(child: Container(
                          child:ListView.builder(
                            itemCount: DataBaseTrucks.length,
                          itemBuilder: (ctx,item){
                            return  Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Color(0xff242F3A),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end ,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16,right: 16,left: 16),
                                        child:Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Color(0xffF7FF00),
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 7,
                                                child: Center(
                                                  child: Text(  DataBaseTrucks[item].truckNumberId.isEmpty?
                                                  ' نامشخص ':
                                                  DataBaseTrucks[item].truckNumberId,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xff242F3A),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 24,
                                                    ),),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text( 'کد کامیون',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),),
                                              )
                                            ],
                                          ) ,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 16.0,right: 16.0),
                                                child: Text(  DataBaseTrucks[item].truckTruckName.isEmpty?
                                                ' نامشخص ':
                                                DataBaseTrucks[item].truckTruckName,
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    color: Color(0xffF7FF00),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 16.0,right: 16.0),
                                                child: Text(  DataBaseTrucks[item].telephone.isEmpty?
                                                '  شماره تماس :'+ ' نامشخص ':
                                                '  شماره تماس :'+ DataBaseTrucks[item].telephone
                                                  ,
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 16.0,right: 16.0),
                                                child: Text(
                                                  DataBaseTrucks[item].carPlates.isEmpty?
                                                  '  شماره پلاک :'+ ' نامشخص ':
                                                  '  شماره پلاک :'+ DataBaseTrucks[item].carPlates

                                                  ,
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),),
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4,bottom: 2,right: 16,left: 16),
                                    child: Divider(color: Colors.white,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          DataBaseTrucks[item].exit.isEmpty?
                                          ' نامشخص ':
                                          DataBaseTrucks[item].exit
                                           ,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: Color(0xffF7FF00),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),),
                                        Text(
                                          ' : زمان ایجاد سرویس  ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },) ,
                        ))
                      ],
                    ),
                  )):
              Flag_Page=='3'?
              Expanded(
                  flex: 1,
                  child:
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8)
                          ),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors:[
                                Color(0xff0A131D),
                                Color(0xff1F2B38)
                              ]
                          )
                      ),
                    child: Row(
                      children: [
                        Expanded(child: GestureDetector(
                             onTap: (){
                               if(Flag_Page!='0')
                               {
                                 setState(() {
                                   Flag_Page='0';
                                 });
                               }

                             },
                            child: SvgPicture.asset('assets/png/truck_new.svg',
                              width: 50,
                              height: 50,
                              color:
                            Flag_Page=='0'?Colors.white:Color(0xff74808C),))),
                        Expanded(child: GestureDetector(
                            onTap: () async{
                              if(Flag_Page!='1')
                              {
                                setState(() {
                                  GetSer();
                                  Flag_Page='1';
                                });
                              }
                            },
                            child:
                           Icon(Icons.menu,
                               size: 50,
                               color:
                           Flag_Page=='1'?Colors.white:Color(0xff74808C)),)),
                        Expanded(child: GestureDetector(
                          onTap: (){
                            if(Flag_Page!='2')
                            {
                              setState(() {
                                Flag_Page='2';
                              });
                            }
                          },
                          child:
                              SvgPicture.asset('assets/png/info.svg',width: 50,height: 50,color:
                              Flag_Page=='2'?Colors.white:Color(0xff74808C),)
                         )),
                      ],
                    ),
                  )):Container()
            ],
          ) ,
        ),
      )),
    );
  }
  Expanded Main_Page() {
    return Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        colors:[
                          Color(0xff0A131D),
                          Color(0xff1F2B38)
                        ]
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 24.0,right: 8),
                                child: Image.asset('assets/png/shipp.png',),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0,right: 16.0,left: 24),
                                child: Text(
                                  // widget.datamain[item].truckTruckName==null?'نامشخص':
                                  // widget.datamain[item].truckTruckName,
                                  'صادرات',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: BaseColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16,),
                                  child: Text(
                                    shipName.isEmpty?'بدون نام':
                                    shipName,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0,right: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                        child: Text(completedServices.toString(),style: TextStyle(
                                          color: BaseColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                        child: Text('سرویس های انجام شده',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4,vertical: 8),
                            decoration: BoxDecoration(
                                color: Color(0xff242F3A),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: TextField(
                              controller:txt,
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 14,color: Colors.white),
                                hintText: '... جستجو کنید',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Run(txt.text);
                          },
                          child: Container(
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color:  BaseColor,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset('assets/png/ssdd.svg',color: Colors.white,),
                            ) ,
                          ),
                        )
                      ],
                    ),
                  ),
                  data_truck!=null&&data_truck.truckNumberId!='-77'?
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Color(0xff242F3A),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child:Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    color:  BaseColor,
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Center(
                                        child: Text(  data_truck.truckNumberId.isEmpty?
                                         ' نامشخص ':
                                         data_truck.truckNumberId,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text( 'کد کامیون',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),),
                                    )
                                  ],
                                ) ,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16.0,right: 16.0),
                                      child: Text(  data_truck.truckTruckName.isEmpty?
                                      ' نامشخص ':
                                      data_truck.truckTruckName,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          color:  BaseColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16.0,right: 16.0),
                                      child: Text(  data_truck.telephone.isEmpty?
                                      '  شماره تماس :'+ ' نامشخص ':
                                      '  شماره تماس :'+ data_truck.telephone
                                        ,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16.0,right: 16.0),
                                      child: Text(
                                        data_truck.carPlates.isEmpty?
                                        '  شماره پلاک :'+ ' نامشخص ':
                                        '  شماره پلاک :'+ data_truck.carPlates

                                        ,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),),
                                    ),
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(right: 8,left: 8,top: 8,bottom: 4),
                        decoration: BoxDecoration(
                            color: Color(0xff465563),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                topLeft: Radius.circular(8)
                            )
                        ),
                        // color: Color(0xff465563),
                        child:  Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: (){
                                    Jalali j = Jalali.now();
                                    setState(() {
                                      Input_Date=j.year.toString()+'/'+j.month.toString()+'/'+j.day.toString();
                                      DateTime now = DateTime.now();
                                      Input_Time= DateFormat('kk:mm:ss').format(now);
                                      print(data_truck.id.toString());
                                      Run_Add_Tasc(pr,data_truck.id);

                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:

                                        BaseColor ,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8),
                                          topLeft: Radius.circular(8)
                                        )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                                      child: Center(
                                        child: Text('ثبت سرویس',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),),
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 8,left: 8,),
                        height: 70,
                        color: Color(0xff213343),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  Input_Date='';
                                  OutPut_Time='';
                                  OutPut_Date='';
                                  Input_Time='';
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 8,bottom: 8,right: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                    ),
                                    color: BaseColor
                                ),
                                child:  Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text('انصراف سرویس',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8),
                              color: BaseColor,
                              child:  Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text('ثبت تخلف',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 8,bottom: 8,left: 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(8)
                                  ),
                                  color: BaseColor
                              ),
                              child:  Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text('اعلام خرابی',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ):Container()

                ],
              ),
            ),
          );
  }
}

class SendAll extends StatefulWidget {
    SendAll({
    Key? key,
    required this.shipName,
    required this.completedServices,
  }) : super(key: key);

  final String shipName;
  final int completedServices;
    var pr;

  @override
  State<SendAll> createState() => _SendAllState();
}

class _SendAllState extends State<SendAll> {




  FocusNode focusNode = FocusNode();

  FocusNode focusNode2 = FocusNode();

  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();

  String txt1='';
  String txt2='';
  String txt3='';
  String txt4='';


  TextEditingController xx=new TextEditingController();
  TextEditingController xx2=new TextEditingController();
  TextEditingController xx3=new TextEditingController();
  TextEditingController xx4=new TextEditingController();
   var pr ;

  @override
  Widget build(BuildContext context) {
   pr= ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: false);
    return Expanded(
        flex: 8,
        child: Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors:[
                          Color(0xff0A131D),
                          Color(0xff1F2B38)
                        ]
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0,right: 8),
                        child: Image.asset('assets/png/shipp.png',),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16,),
                              child: Text(
                                widget.shipName.isEmpty?'بدون نام':
                                widget.shipName,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                    child: Text(widget.completedServices.toString(),style: TextStyle(
                                      color: Color(0xffF7FF00),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                    child: Text('سرویس های انجام شده',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0,right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                    child: Text('سرویس های ایجاد شده در دستگاه',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color:Color(0xffF7FF00),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16,top: 16),
                child: Text('پلاک کامیون را وارد کنید',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color:Color(0xffF7FF00),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
              ),
               Container(
                 margin: EdgeInsets.symmetric(vertical: 16),
                 height: 70,
                 child: Row(
                   children: [
                     Expanded(
                         flex: 4,
                         child: Container(
                           height: 70,
                           decoration: BoxDecoration(
                              color: Color(0xff1F2B38),
                               border: Border.all(color: BaseColor,width: 2),
                             borderRadius: BorderRadius.circular(8)
                           ),
                           margin: EdgeInsets.symmetric(horizontal: 16),
                           child: Center(
                             child: TextField(
                               controller: xx,
                               keyboardType: TextInputType.number,
                               focusNode:   focusNode ,
                               decoration: InputDecoration(
                                 border: InputBorder.none,
                               ),
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 32,
                               ),
                               textAlign: TextAlign.center,
                               onChanged: (val){
                                 if(val.isNotEmpty)
                                   {
                                     var s=val.trim().toString().length;
                                     if(s>1)
                                       {

                                           txt1=val.trim().toString();


                                         focusNode2.requestFocus();
                                       }
                                   }
                               },
                             ),
                           ),)),
                     Expanded(
                         flex: 3,
                         child: Container(
                             height: 70,
                             decoration: BoxDecoration(
                                 color: Color(0xff1F2B38),
                                 border: Border.all(color: BaseColor,width: 2),
                                 borderRadius: BorderRadius.circular(8)
                             ),
                             margin: EdgeInsets.symmetric(horizontal: 16),
                             child: TextField(
                                controller: xx2,
                               keyboardType: TextInputType.text,
                               focusNode:   focusNode2 ,
                               decoration: InputDecoration(
                                 border: InputBorder.none,
                               ),
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 32,
                               ),
                               textAlign: TextAlign.center,
                               onChanged: (val){
                                 if(val.isNotEmpty)
                                 {
                                   var s=val.trim().toString().length;
                                   if(s>0)
                                   {

                                       txt2=val.trim().toString();


                                     focusNode3.requestFocus();
                                   }
                                 }
                               },
                             ),)),
                     Expanded(
                         flex: 6,
                         child: Container(
                           height: 70,
                             decoration: BoxDecoration(
                                 color: Color(0xff1F2B38),
                                 border: Border.all(color: BaseColor,width: 2),
                                 borderRadius: BorderRadius.circular(8)
                             ),
                             margin: EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: xx3,
                                maxLength: 3,
                                keyboardType: TextInputType.number,
                                focusNode:   focusNode3,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                ),
                                onChanged: (val){
                                  if(val.isNotEmpty)
                                  {
                                    var s=val.trim().toString().length;

                                    if(s>2)
                                    {
                                      txt3=val.trim().toString();
                                      focusNode4.requestFocus();
                                    }
                                  }
                                },
                                textAlign: TextAlign.center,

                              ),)),

                     Expanded(
                         flex: 4,
                         child: Container(
                           height: 70,
                           decoration: BoxDecoration(
                               color: Color(0xff1F2B38),
                               border: Border.all(color: BaseColor,width: 2),
                               borderRadius: BorderRadius.circular(8)
                           ),
                           margin: EdgeInsets.symmetric(horizontal: 16),
                           child: TextField(
                             controller: xx4,
                             maxLength: 2,
                             keyboardType: TextInputType.number,
                             focusNode:   focusNode4,
                             decoration: InputDecoration(
                               border: InputBorder.none,
                             ),
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 32,
                             ),
                             onChanged: (val){
                               if(val.isNotEmpty)
                               {
                                 var s=val.trim().toString().length;
                                 txt4=val.trim().toString();
                                 if(s==0)
                                 {

                                   focusNode2.requestFocus();
                                 }
                               }
                             },
                             textAlign: TextAlign.center,

                           ),)),
                   ],
                 ),
               ),
              GestureDetector(
                onTap: () async{
                  print(txt1.trim().length.toString());
                  print(txt2.trim().length.toString());
                  print(txt3.trim().length.toString());
                  if(txt1.trim().length<2)
                    {
                      ShowSnackbar('پلاک به درستی وارد نشده است');
                      return;
                    }
                  if(txt2.trim().length==0)
                  {
                    ShowSnackbar('پلاک به درستی وارد نشده است');
                    return;
                  }
                  if(txt3.trim().length<3)
                  {
                    ShowSnackbar('پلاک به درستی وارد نشده است');
                    return;
                  }


                  if(txt4.trim().length<2)
                  {
                    ShowSnackbar('پلاک به درستی وارد نشده است');
                    return;
                  }


                   bool Flag= await ApiService.SendAll(pr, txt1, txt2, txt3, txt4,context);

                      if(Flag)
                        {
                          xx.clear();
                          xx2.clear();
                          xx3.clear();
                          xx4.clear();
                          txt1='';
                          txt2='';
                          txt3='';
                          txt4='';
                        }


                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                      color:
                      Color(0xffF7FF00) ,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Text('ثبت',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
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
}
