class Trucks{
  String truckNumberId;
  String truckTruckName;
  String qrcode;
  String carPlates;
  String exit;
  String telephone;
  String id;

  Trucks( this.truckNumberId, this.truckTruckName, this.qrcode, this.carPlates,this.exit, this.telephone,
      this.id);


  Map<String,dynamic>  ToMapDatabase(){
    return <String,dynamic>{
      'truckNumberId':truckNumberId,
      // 'id':id,
      'truckTruckName':truckTruckName,
      'qrcode':qrcode,
      'carPlates':carPlates,
      'exit':exit,
      'telephone':telephone,
      'id':id,
    };
  }


  static  fromMap(Map c) {
    return Trucks(c['truckNumberId'],c['truckTruckName'],c['qrcode'],c['carPlates'],c['exit'],c['telephone'],c['id']);
  }



}