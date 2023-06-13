
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:consumer/widgets/common_methods.dart';

class BluetoothScanner extends StatefulWidget {
  const BluetoothScanner({Key? key}) : super(key: key);

  @override
  _BluetoothScannerState createState() => _BluetoothScannerState();
}

class _BluetoothScannerState extends State<BluetoothScanner> {
  final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final List<ScanResult> _devicesList = [];

  // Start scanning for Bluetooth devices
  void _startScan() {
    _flutterBlue.scan(
      timeout: const Duration(seconds: 10),
      scanMode: ScanMode.lowLatency,
    ).listen((scanResult) async {
      setState(() {
        _devicesList.add(scanResult);
      });

      showNotification(
          context,
          1,
          "Alert !!",
          scanResult.advertisementData.localName);
    });
  }


  @override
  void initState() {
    super.initState();
    // Start scanning for devices when the widget is initialized
    _startScan();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _devicesList.clear();
    });
    _flutterBlue.stopScan();
    await Future.delayed(const Duration(seconds: 1));
    _startScan();
  }

  @override
  void dispose() {
    // Stop scanning when the widget is disposed
    _flutterBlue.stopScan();
    super.dispose();
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the stored hashed credentials from local storage
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');
    bool? isLoggedIn;
    if (storedUsername != null && storedPassword != null) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
    return isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Bluetooth Devices'),
          backgroundColor: Colors.green.shade700,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green.shade400, Colors.blue.shade400],
            ),
          ),
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.builder(
              itemCount: _devicesList.length,
              itemBuilder: (context, index) {
                Map<int, List<int>> manufacturerData =
                    _devicesList[index].advertisementData.manufacturerData;
                String uuidString = 'Error Fetching';

                if (manufacturerData.isNotEmpty) {
                  List<int> bytes = manufacturerData.values.first;
                  if (bytes.isNotEmpty) {
                    try {
                      uuidString = Uuid.unparse(bytes).toUpperCase();
                    } catch (e) {
                      print('Error parsing UUID: $e');
                    }
                  }
                }
                return Card(
                  color: Colors.white.withOpacity(0.7),
                  elevation: 8.0,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(_devicesList[index].device.name ?? ''),
                    subtitle: Text(uuidString),
                    trailing: Text("rssi: ${_devicesList[index].rssi} dB"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(_devicesList[index].device.name ?? ''),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Mac ID: ${_devicesList[index].device.id}'),
                                const SizedBox(height: 8),
                                Text('Type: ${_devicesList[index].device.type}'),
                                const SizedBox(height: 8),
                                Text('Local Name: ${_devicesList[index].advertisementData.localName}'),
                                const SizedBox(height: 8),
                                Text('Manufacturer Data: ${uuidString.toUpperCase()}'),
                                const SizedBox(height: 8),
                                Text('Service UUIDs: ${_devicesList[index].advertisementData.serviceUuids.toString()}'),
                                const SizedBox(height: 8),
                                Text('RSSI: ${_devicesList[index].rssi.toString()}'),
                                const SizedBox(height: 8),
                                Text('TX Power Level: ${_devicesList[index].advertisementData.txPowerLevel?.toString() ?? "N/A"}'),
                                const SizedBox(height: 8),
                                Text('MTU: _${_devicesList[index].device.mtu}'),
                                const SizedBox(height: 8),
                                Text('Services: _${_devicesList[index].device.services}'),
                                const SizedBox(height: 8),
                                const Text('Advertisement:'),
                                const SizedBox(height: 8),
                                if (_devicesList[index].advertisementData.serviceUuids.isNotEmpty && _devicesList[index].advertisementData.serviceUuids[0] == "0000fef5-0000-1000-8000-00805f9b34fb")
                                  Image.network('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                                if (_devicesList[index].advertisementData.serviceUuids.isEmpty || _devicesList[index].advertisementData.serviceUuids[0] != "0000fef5-0000-1000-8000-00805f9b34fb")
                                  const Text('No data'),
                              ],
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
