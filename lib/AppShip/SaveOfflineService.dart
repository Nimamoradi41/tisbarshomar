 class SaveOfflineService {
   String enter;
   String exit;
   String truckId;
   String seoId;

   SaveOfflineService( this.enter, this.exit, this.truckId, this.seoId);


   Map<String,dynamic>  ToMapDatabase(){
     return <String,dynamic>{
       'enter':enter,
       'exit':exit,
       // 'id':id,
       'truckId':truckId,
       'seoId':seoId,
     };
   }


   static  fromMap(Map c) {
     return SaveOfflineService(c['enter'],c['exit'],c['truckId'],c['seoId']);
   }
 }