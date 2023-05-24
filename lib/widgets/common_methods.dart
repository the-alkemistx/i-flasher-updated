import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mysql1/mysql1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void showNotification(BuildContext context, int id, String? title, String? body) async {
  final status = await Permission.notification.request();
  if (status != PermissionStatus.granted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Denied")),
    );
    return;
  }

  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  const androidInitializationSetting = AndroidInitializationSettings('icon_notif');
  const darwinInitializationSetting = DarwinInitializationSettings();
  final initializationSettings = InitializationSettings(
    android: androidInitializationSetting,
    iOS: darwinInitializationSetting,
  );
  await flutterLocalNotificationPlugin.initialize(initializationSettings);

  const androidNotificationDetails = AndroidNotificationDetails(
    "high_imp",
    "pop-up",
    importance: Importance.max,
    priority: Priority.high,
  );
  const iosNotificationDetails = DarwinNotificationDetails(badgeNumber: 1);
  final notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails,
  );

  flutterLocalNotificationPlugin.show(id, title, body, notificationDetails);
}

bool validateEmail(String email) {
  String pattern = r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(email);
}

String hashData(String data) {
  var bytes = utf8.encode(data); // Encode the data as UTF-8
  var digest = sha256.convert(bytes); // Hash the data using SHA-256
  return digest.toString(); // Return the hashed data as a string
}

Future<bool> authenticate(String username, String password) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: '103.174.148.69',
    port: 3306,
    user: 'admin',
    password: 'iflasher@1234',
    db: 'user_app_db_main',
  ));

  final results = await conn.query(
    'SELECT email, password FROM user_app_auth WHERE email = ?',
    [username],
  );

  await conn.close();

  if (results.isNotEmpty) {
    final row = results.first;
    final storedPassword = row['password'];
    if (password == storedPassword) {
      return true; // Authentication successful
    }
  }
  return false; // Authentication failed
}

Future<bool> insertion(String username, String password,String fullname ,int phone, String email) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: '103.174.148.69',
    port: 3306,
    user: 'admin',
    password: 'iflasher@1234',
    db: 'user_app_db_main',
  ));

  try {
    await conn.query(
      'INSERT INTO `user_app_auth` (`username`, `name`, `email`, `phone`, `password`) '
          'VALUES (?, ?, ?, ?, ?)',
      [username, fullname, email, phone, password],
    );
    await conn.close();
    return true; // Insertion successful
  } catch (e) {
    await conn.close();
    print('Error inserting user: $e');
    return false; // Insertion failed
  }
}

Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve the stored hashed credentials from local storage
  String? storedUsername = prefs.getString('username');
  String? storedPassword = prefs.getString('password');
  bool? isLoggedIn = null;
  if(storedUsername != null && storedPassword != null) {
    isLoggedIn = true;
  }
  else{
    isLoggedIn= false;
  }
  return isLoggedIn;
}

Future<String?> urlfetch(String uuid) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: '103.174.148.69',
    port: 3306,
    user: 'admin',
    password: 'iflasher@1234',
    db: 'beacons',
  ));

  final results = await conn.query(
    'SELECT url FROM `ble_beacons` WHERE uuid = ?',
    [uuid],
  );

  await conn.close();

  if (results.isNotEmpty) {
    final row = results.first;
    final storedurl = row['url'];
    return storedurl;
  } else {
  return null;} // Authentication failed
}

Future<String?> uuidfetch(String uuid) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: '103.174.148.69',
    port: 3306,
    user: 'admin',
    password: 'iflasher@1234',
    db: 'beacons',
  ));

  final results = await conn.query(
    'SELECT uuid FROM `ble_beacons`',
  );


  if (results.isNotEmpty) {
    for (var row in results) {
      final storedUuid = row['uuid'] as String;
      if (storedUuid == uuid) {
        await conn.close();
        return storedUuid; // UUID found in the database
      }else{return null;}
    }
  }else{
  return null; // UUID not found in the database
}}