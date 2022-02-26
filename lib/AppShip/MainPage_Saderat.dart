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
import 'DetailSaderat.dart';
import 'MainPage.dart';
import 'Trucks.dart';
import 'const.dart';

class MainPage_Saderat extends StatefulWidget {
  // List<DataModelAnbarService> datamain;
  List<DataModelAnbarService> MainData1=[];
  MainPage_Saderat(this.MainData1);
  // MainPage_Saderat(this.datamain);
  @override
  State<MainPage_Saderat> createState() => _MainPageStateSaderaat();
}

class _MainPageStateSaderaat extends State<MainPage_Saderat> {







  String Input_Time='';
  String Input_Date='';
  String OutPut_Time='';
  String OutPut_Date='';










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
    Trucks data_truck=new Trucks('-77', 'truckName', '', '', '', '','');
    Future getda() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getInt('completedServices')!=null){
      completedServices=prefs.getInt('completedServices')!;
    };


      if(prefs.getInt('shipName')!=null){
        shipName=prefs.getString('shipName')!;
      };




    }




  Future Run(ProgressDialog  pr)async{

    String  datae='[';
    if(datamain_DataBase.length>0)
    {
      var  data= await   DataBseFile.db.GetCustomers();
      print(data.toString());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id=  prefs.getString('id');
      datamain_DataBase.forEach((element) {

        String exitWarehouse=element.exitWarehouse;
        String enterFunnel=element.enterFunnel;
        print('Teeeeeeeeeeeee'+enterFunnel);
        String Anbar=element.Anbar_Id;
        String Id_Car=element.Id_Car;
        datae=datae+
            '\n{\n"enter":"$enterFunnel",\n'
                '"exit":"$enterFunnel",\n'
                '"seoId":"$id",\n'
                '"truckId":"$Id_Car"\n},\n';



      });

      datae= datae.substring(1, datae.length-1);
      datae='['+datae+']';
      print(datae.toString());

      var dataa= await ApiService.Add_Tasck_ALL_Saderat(pr,datae,context);

      if(dataa)
      {

        await DataBseFile.db.Del_Saderat();
        setState(() {
          ShowSnackbar('عملیات با موفقیت انجام شد');
          completedServices=completedServices+datamain_DataBase.length;
          datamain_DataBase.clear();

        });
      }

    }



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
          seoVersion=prefs.getInt('seoVersion')!;
          shipName=prefs.getString('shipName')!;
          completedServices=prefs.getInt('completedServices')!;


      });


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
                Run(pr);
                // Run_Act(progressDialog,truckId,enterDate,exitDate);
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


  String Flag_Page='0';
  List<DataModelAnbarService> datamain_DataBase=[];

  Future  GetSer() async{
    print('AAAA');
    var  data= await   DataBseFile.db.GetServicesSaderat();


    if(data.length>0)
    {
      setState(() {
        datamain_DataBase=data;
      });
    }
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
  Future  GetSer_Main() async{
    print('AAAA');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=  prefs.getString('token');
    var  data= await   ApiService.GetTrucks_Saderat_Ref(token!,context, pr);

    if(data.length>0)
    {
      print('BBBB');
      setState(() {
        widget.MainData1=data;
      });
    }
  }
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
              Main_Page_2():
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
                                                      color:BaseColor,
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
                                                      color: BaseColor,
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
                                                      color: BaseColor,
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
                                                      color: BaseColor,
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
                                                      color: BaseColor,
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
                                                      color: BaseColor,
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
                                                      color:BaseColor,
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
                                                      color: BaseColor,
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
                                                      color: BaseColor,
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
                                                      color: BaseColor,
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
                                                      color: BaseColor,
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
                                                      color: BaseColor,
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
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0,right: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16),
                                              child: Text('سرویس های ذخیره شده در دستگاه',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  color: BaseColor,
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
                        datamain_DataBase.length>0?
                        GestureDetector(
                          onTap: (){
                            _showMyDialog_All(pr);
                          },
                          child: Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color:
                                BaseColor,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                child: Text('  ارسال به سرور ',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),),
                              ),
                            ),
                          ),
                        ):
                        Container(),
                        Expanded(child: Container(
                          child:ListView.builder(
                            itemCount:datamain_DataBase.length,
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
                                                color:BaseColor,
                                                borderRadius: BorderRadius.circular(8)
                                            ),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex: 7,
                                                  child: Center(
                                                    child: Text(
                                                      datamain_DataBase[item].truckTruckNumberId.isEmpty?
                                                    ' نامشخص ':
                                                      datamain_DataBase[item].truckTruckNumberId,
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
                                                  child: Text(
                              datamain_DataBase[item].truckTruckName.isEmpty?
                              ' نامشخص ':
                              datamain_DataBase[item].truckTruckName,
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                      color: BaseColor,
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
                                                    datamain_DataBase[item].Anbar.isEmpty? '  انبار :'+' نامشخص ':
                                                     '  :انبار '+datamain_DataBase[item].Anbar
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
                                                    datamain_DataBase[item].carPlates.isEmpty?
                                                    '  شماره پلاک :'+ ' نامشخص ':
                                                    '  شماره پلاک :'+ datamain_DataBase[item].carPlates
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
                                                    datamain_DataBase[item].exitWarehouse.isEmpty?
                                                    '  زمان آغاز سرویس :'+ ' نامشخص ':
                                                    '  زمان آغاز سرویس :'+ datamain_DataBase[item].exitWarehouse
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
                                            datamain_DataBase[item].enterFunnel.isEmpty?
                                            ' نامشخص ':
                                            datamain_DataBase[item].enterFunnel

                                            ,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: BaseColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),),
                                          Text(
                                            ' : زمان اتمام سرویس  ',
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
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
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
                            onTap: (){
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
                  ))
            ],
          ) ,
        ),
      )),
    );
  }

  Expanded Main_Page_2() {
    return Expanded(
            flex: 8,
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
                GestureDetector(
                  onTap: (){
                    GetSer_Main();
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color:
                        BaseColor,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text('  دریافت سرویس های ایجاد شده  ',
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
                  child: ListView.builder(
                      // itemCount: widget.datamain.length,
                      itemCount: widget.MainData1.length,
                  itemBuilder: (ctx,item){
                    return    GestureDetector(
                      onTap: () async{
                        DataModelAnbarService flag= await   Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => DetailSaderat(
                               widget.MainData1[item],
                        )));
                         print(flag.toString());
                         if(flag!=null)
                           {
                            await DataBseFile.db.newSaderat(widget.MainData1[item]);
                           }else{
                           setState(() {
                             completedServices=completedServices+1;
                           });
                         }


                      setState(() {
                        widget.MainData1.removeAt(item);
                      });

                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Color(0xff242F3A),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child:Container(
                                    height: 80,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: BaseColor,
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Center(
                                      // child: Text(    widget.MainData1[item].truckTruckNumberId,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(    widget.MainData1[item].truckTruckNumberId,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                            ),),
                                          Text(    'کد کامیون',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),),
                                        ],
                                      ),
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
                                          padding: const EdgeInsets.only(top: 32.0,right: 16.0),
                                          child: Text(
                                            widget.MainData1[item].truckTruckName==null?'نامشخص':
                                          widget.MainData1[item].truckTruckName,
                                            // 'نیما مرادی',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: BaseColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0,right: 16.0),
                                          child: Text(
                                            widget.MainData1[item].carPlates.isEmpty?'پلاک'+' : نامشخص ':
                                            ' : پلاک '+widget.MainData1[item].carPlates,
                                            // 'انبار اکسون',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: BaseColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16.0),
                                        child: Divider(
                                          height: 1,
                                          color: Colors.white,
                                        ),
                                      )

                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10,top: 2,bottom: 2,left: 10),
                                    child: Text(
                                    widget.MainData1[item].exitWarehouse.isEmpty?  ': زمان ایجاد سرویس'+'نامسخص':
                                    '  زمان ایجاد سرویس : '+  widget.MainData1[item].exitWarehouse,
                                      // '14/4/7 14:12 : زمان ایجاد سرویس',
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
                      ),
                    );
                  }),
                )

              ],
            ),
          );
  }
}
