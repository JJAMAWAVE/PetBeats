import 'dart:async';
import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class IotService extends GetxService {
  // final RxList<ScanResult> scanResults = <ScanResult>[].obs;
  final RxList<dynamic> scanResults = <dynamic>[].obs; // Mock type
  final RxBool isScanning = false.obs;
  final RxBool isConnected = false.obs;
  final RxInt heartRate = 0.obs;
  
  // BluetoothDevice? connectedDevice;
  dynamic connectedDevice;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _heartRateSubscription;

  // Heart Rate Service UUID (Standard)
  final String HEART_RATE_SERVICE_UUID = "180D";
  final String HEART_RATE_CHARACTERISTIC_UUID = "2A37";

  @override
  void onInit() {
    super.onInit();
    // FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  }

  Future<void> startScan() async {
    if (isScanning.value) return;

    isScanning.value = true;
    scanResults.clear();

    // Mock Scan
    await Future.delayed(Duration(seconds: 2));
    isScanning.value = false;
    
    /*
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        scanResults.value = results;
      });

      await Future.delayed(const Duration(seconds: 5));
      await stopScan();
    } catch (e) {
      print("Scan Error: $e");
      isScanning.value = false;
    }
    */
  }

  Future<void> stopScan() async {
    /*
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      print("Stop Scan Error: $e");
    } finally {
      isScanning.value = false;
    }
    */
    isScanning.value = false;
  }

  Future<void> connectToDevice(dynamic device) async {
    /*
    try {
      await device.connect();
      connectedDevice = device;
      isConnected.value = true;

      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        if (service.uuid.toString().toUpperCase().contains(HEART_RATE_SERVICE_UUID)) {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid.toString().toUpperCase().contains(HEART_RATE_CHARACTERISTIC_UUID)) {
              await _subscribeToHeartRate(characteristic);
            }
          }
        }
      }
    } catch (e) {
      print("Connection Error: $e");
      Get.snackbar("연결 실패", "기기 연결 중 오류가 발생했습니다.");
    }
    */
    // Mock Connection
    isConnected.value = true;
    simulateHeartRate();
  }

  Future<void> _subscribeToHeartRate(dynamic characteristic) async {
    /*
    await characteristic.setNotifyValue(true);
    _heartRateSubscription = characteristic.lastValueStream.listen((value) {
      if (value.isNotEmpty) {
        // Parse Heart Rate Measurement (Standard)
        // First byte flags, usually 8-bit or 16-bit format
        int hr = value[1]; // Simplified parsing
        heartRate.value = hr;
      }
    });
    */
  }

  void disconnect() async {
    /*
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      isConnected.value = false;
      connectedDevice = null;
      heartRate.value = 0;
    }
    */
    isConnected.value = false;
    heartRate.value = 0;
  }

  // Simulation Mode for Testing without Device
  void simulateHeartRate() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isConnected.value && scanResults.isNotEmpty) { // Stop if disconnected, but keep if mock connected
         // timer.cancel();
      }
      // Random heart rate between 60 and 100
      heartRate.value = 60 + Random().nextInt(40);
    });
  }
}
