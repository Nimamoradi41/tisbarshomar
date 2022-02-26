import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';



import '../ApiService.dart';
import '../modeldatalogin.dart';
import 'DataModelAnbarService.dart';
import 'MainPage.dart';
import 'Trucks.dart';
import 'package:path/path.dart';
class DataBseFile {


  int PageCounterCustomer=0;
  DataBseFile._();
  static final DataBseFile db = DataBseFile._();
   static Database? _database;
  Future<List<DataModelAnbarService>>  GetServicesSaderat() async
  {
    List<DataModelAnbarService> Serviceee = <DataModelAnbarService>[];
    final db=await database;
    var res  =await db!.query("SERVICES_Saderat_Bar");


    var datatemp;
    res.forEach((result) {
      var dd=  result;
      print(dd.toString());
      String enterFunnel=dd['enterFunnel'].toString();
      String exitFunnel=dd['exitFunnel'].toString();
      String enterWarehouse=dd['enterWarehouse'].toString();
      String exitWarehouse=dd['exitWarehouse'].toString();
      String state=dd['state'].toString();
      String truckTruckName=dd['truckTruckName'].toString();
      String carPlates=dd['carPlates'].toString();
      String truckTruckNumberId=dd['truckTruckNumberId'].toString();
      String id=dd['id'].toString();
      String file=dd['file'].toString();
      String Anbar=dd['Anbar'].toString();
      String Anbar_Id=dd['Anbar_Id'].toString();
      String Id_Car=dd['Id_Car'].toString();
      print('Data Nima'+Id_Car);
      var s=DataModelAnbarService(enterFunnel, exitFunnel, enterWarehouse, exitWarehouse,0, truckTruckName, carPlates,
          truckTruckNumberId,id,file,Anbar,Anbar_Id,Id_Car);
      Serviceee.add(s);
    });
    return Serviceee;


    // close();



  }

   Future<bool> Del()async{
     final db=await database;
     await db!.delete('Services');
     return true;
   }

  Future<bool> Del_Saderat()async{
    final db=await database;
    await db!.delete('SERVICES_Saderat_Bar');
    return true;
  }
  Future<Database?> get database async {
    if (_database != null)
      return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await Init();
    return _database;
  }
  DataBseFile();

  static final Trucks_tbl ="Trucks";


   // DataBseFile.init();
   String path='';


   newTrucks(Trucks s)async{
     final db=await database;
        var res=await db!.rawInsert('''
        INSERT INTO Trucks (
        truckNumberId, truckTruckName, qrcode, carPlates, exit, telephone, id    
        ) VALUES (?, ?, ?, ?, ?, ?)
        ''',[s.truckNumberId, s.truckTruckName, s.qrcode, s.carPlates, s.exit, s.telephone, s.id]);
        print(res.toString());
        return res;
   }



  newService(Trucks s)async{
    final db=await database;
    var res=await db!.rawInsert('''
        INSERT INTO Services (
        truckNumberId, truckTruckName, qrcode, carPlates, exit, telephone, id    
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
        ''',[s.truckNumberId, s.truckTruckName, s.qrcode, s.carPlates,s.exit, s.telephone, s.id]);
    print(res.toString());
    return res;
  }


  newSaderat(DataModelAnbarService s)async{
    final db=await database;
    var res=await db!.rawInsert('''
        INSERT INTO SERVICES_Saderat_Bar (
        enterFunnel, exitFunnel, enterWarehouse, exitWarehouse, state, truckTruckName, carPlates, truckTruckNumberId, id, file, Anbar, Anbar_Id, Id_Car     
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',[s.enterFunnel, s.exitFunnel, s.enterWarehouse, s.exitWarehouse, s.state, s.truckTruckName, s.carPlates,
      s.truckTruckNumberId,
      s.id,
      s.file,
      s.Anbar,
      s.Anbar_Id,
      s.Id_Car]);
    print(res.toString());
    return res;
  }



  Init({String dbname:'appdatabase.db'})  async {
    return await openDatabase(join(await getDatabasesPath(),dbname),onCreate:( Database  db, int version)async{
      await db.execute('''
              CREATE TABLE Trucks (
              truckNumberId text,
              truckTruckName text not null,
              qrcode text not null,
              carPlates text not null,
              exit text not null,
              telephone text not null,
              id text not null)
                           ''');
      await db.execute('''
              CREATE TABLE Services (
              id_database INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              truckNumberId text,
              truckTruckName text not null,
              qrcode text not null,
              carPlates text not null,
              exit text not null,
              telephone text not null,
              id text not null)
                           ''');

      await db.execute('''
              CREATE TABLE SERVICES_Saderat_Bar (
              enterFunnel text,
              exitFunnel text not null,
              enterWarehouse text not null,
              exitWarehouse text not null,
              state text not null,
              truckTruckName text not null,
              carPlates text not null,
              truckTruckNumberId text not null,
              id text not null,
              file text not null,
              Anbar text not null,
              Anbar_Id text not null,
              Id_Car text not null)
                           ''');





    },version: 1);

  }






  Future<List<Trucks>>  GetCustomers() async
  {
    List<Trucks> Customers = <Trucks>[];
    final db=await database;
   var res  =await db!.query("Trucks");


    var datatemp;
    res.forEach((result) {
      var dd=  result;
      print(dd.toString());
      String truckNumberId=dd['truckNumberId'].toString();
      String truckName=dd['truckTruckName'].toString();
      String qrcode=dd['qrcode'].toString();
      String carPlates=dd['carPlates'].toString();
      String exit=dd['exit'].toString();
      String telephone=dd['telephone'].toString();
      String id=dd['id'].toString();
      var s=Trucks(truckNumberId, truckName, qrcode, carPlates,exit, telephone, id);
      Customers.add(s);
    });
    return Customers;


    // close();



  }





  Future<List<Trucks>>  GetService() async
  {
    List<Trucks> Service = <Trucks>[];
    final db=await database;
    var res  =await db!.query("Services");


    var datatemp;
    res.forEach((result) {
      var dd=  result;
      print(dd.toString());
      String truckNumberId=dd['truckNumberId'].toString();
      String truckName=dd['truckTruckName'].toString();
      String qrcode=dd['qrcode'].toString();
      String carPlates=dd['carPlates'].toString();
      String exit=dd['exit'].toString();
      String telephone=dd['telephone'].toString();
      String id=dd['id'].toString();
      var s=Trucks(truckNumberId, truckName, qrcode, carPlates,exit, telephone, id);
      Service.add(s);
    });
    return Service;


    // close();



  }







  Future SendRequestCustomer(String Token,BuildContext context,ProgressDialog progressDialog) async
  {
    var Flag2=false;

    var Data=await ApiService.GetTrucks_Saderat(Token,context,progressDialog);


    var  ss=await  Insert_Allof_Customer(Data,context,progressDialog);


    print('fINISHEED');


  }



  Future Save_Service(Trucks trucks) async
  {





    var  ss=await  db.newService(trucks);


    print(ss.toString());


  }





  Future  Insert_Allof_Customer(List<Trucks> model,BuildContext context,ProgressDialog pr) async
  {

       final db=await database;


       // if()
       //  print('is Trureeeee');
        await db!.delete(Trucks_tbl);


    var dd=  await Future.wait(model.map((e) async {
      var ress=  await db.insert(Trucks_tbl,e.ToMapDatabase(),conflictAlgorithm: ConflictAlgorithm.ignore);
      print('Id is '+ress.toString());
      return ress.toString();
    }));



       pr.hide();

       Navigator.pushAndRemoveUntil(
         context,
         MaterialPageRoute(builder: (context) => MainPage()),
             (Route<dynamic> route) => false,
       );


       // Navigator.pushAndRemoveUntil(
       //   context,
       //   MaterialPageRoute(builder: (context) => MainPage_Saderat()),
       //       (Route<dynamic> route) => false,
       // );





    // final db=await database;
    // var page= 9;
    // var pageCounter=0;
    // if(page==0)
    //   {
    //     var res2  =await db!.delete('Customer');
    //   }
    //
    // if(pageCounter<page)
    // {
    //     var dd=  await Future.wait(model.map((e) async {
    //       var uuid = Uuid();
    //       e.id=uuid.v1().toString();
    //       var ress=  await db!.insert(Customer_tbl,e.ToMapDatabase(),conflictAlgorithm: ConflictAlgorithm.replace);
    //       print('Id is '+ress.toString());
    //       return ress.toString();
    //     }));
    //     print(dd.toString());
    //     pageCounter=pageCounter+1;
    //     print('Conter is'+pageCounter.toString());
    //     return pageCounter.toString();
    //     Insert_Allof_Customer(model);
    //
    //   }




  // close();



  }



  Future  Insert_Allof_Customer_Saderat(List<Trucks> model,BuildContext context,ProgressDialog pr) async
  {

    final db=await database;


    // if()
    //  print('is Trureeeee');
    await db!.delete(Trucks_tbl);


    var dd=  await Future.wait(model.map((e) async {
      var ress=  await db.insert(Trucks_tbl,e.ToMapDatabase(),conflictAlgorithm: ConflictAlgorithm.ignore);
      print('Id is '+ress.toString());
      return ress.toString();
    }));






    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => MainPage_Saderat()),
    //       (Route<dynamic> route) => false,
    // );





    // final db=await database;
    // var page= 9;
    // var pageCounter=0;
    // if(page==0)
    //   {
    //     var res2  =await db!.delete('Customer');
    //   }
    //
    // if(pageCounter<page)
    // {
    //     var dd=  await Future.wait(model.map((e) async {
    //       var uuid = Uuid();
    //       e.id=uuid.v1().toString();
    //       var ress=  await db!.insert(Customer_tbl,e.ToMapDatabase(),conflictAlgorithm: ConflictAlgorithm.replace);
    //       print('Id is '+ress.toString());
    //       return ress.toString();
    //     }));
    //     print(dd.toString());
    //     pageCounter=pageCounter+1;
    //     print('Conter is'+pageCounter.toString());
    //     return pageCounter.toString();
    //     Insert_Allof_Customer(model);
    //
    //   }




    // close();



  }













    // close();





  Future close() => _database!.close();

}