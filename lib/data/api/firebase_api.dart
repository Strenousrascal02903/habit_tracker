import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // Create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Function to initialize notifications
  Future<void> initNotifications() async {
    // Request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // Fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();

    // Print the token (normally you would send this to your server)
    print('Token: $fCMToken');
  }

  // Function to handle received messages

  // Function to initialize foreground and background settings
}
