class DataModelAnbarService{
  String enterFunnel;
  String exitFunnel;
  String enterWarehouse;
  String exitWarehouse;
  int state;
  String truckTruckName;
  String carPlates;
  String truckTruckNumberId;
  String id;
  String file;
  String Anbar;
  String Anbar_Id;
  String Id_Car;

  DataModelAnbarService( this.enterFunnel, this.exitFunnel, this.enterWarehouse, this.exitWarehouse, this.state,
      this.truckTruckName, this.carPlates,this.truckTruckNumberId,this.id,this.file,this.Anbar,this.Anbar_Id,this.Id_Car);


  Map<String,dynamic>  ToMapDatabase(){
    return <String,dynamic>{
      'enterFunnel':enterFunnel,
      // 'id':id,
      'exitFunnel':exitFunnel,
      'enterWarehouse':enterWarehouse,
      'exitWarehouse':exitWarehouse,
      'state':state,
      'truckTruckName':truckTruckName,
      'carPlates':carPlates,
      'truckTruckNumberId':truckTruckNumberId,
      'id':id,
      'file':file,
      'Anbar':Anbar,
      'Anbar_Id':Anbar_Id,
      'Id_Car':Id_Car,
    };
  }


  // static  fromMap(Map c) {
  //   return DataModelAnbarService(c['enterFunnel'],c['exitFunnel'],c['enterWarehouse'],c['exitWarehouse'],
  //     c['state'],c['truckTruckName'],
  //       c['truckPlateNumber'],
  //       c['truckTruckNumberId'],);
  //       c['id']);
  // }
}