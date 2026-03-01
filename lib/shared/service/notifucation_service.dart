
import 'package:firebase_messaging/firebase_messaging.dart';

import '../components/constants.dart';
import 'local_notifications_service.dart';

class NotificationService {
  static FirebaseMessaging messaging=FirebaseMessaging.instance;
  static Future<void> init() async{
await messaging.requestPermission();
 token=await messaging.getToken();
print('===============================================');
print(token?? 'null');
FirebaseMessaging.onBackgroundMessage(backgroundMessage);
FirebaseMessaging.onMessage.listen((RemoteMessage message){
  LocalNotificationService.showBasicNotification(message);
});
  }






  static Future<void> backgroundMessage(RemoteMessage message)async{
  }
}