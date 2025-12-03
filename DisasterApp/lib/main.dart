import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/data_import_service.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'bootstrap/boot.dart';

/// Nylo - Framework for Flutter Developers
/// Docs: https://nylo.dev/docs/6.x

/// Main entry point for the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeAppData();
  await Nylo.init(
    setup: Boot.nylo,
    setupFinished: Boot.finished,


  );
}

Future<void> _initializeAppData()async{
  try {
    bool success = await DataImportService().importDisasterTypes();
    if (success) {
      print('✅ [INIT] App data initialized successfully');
    } else {
      print('⚠️ [INIT] Failed to import disaster types');
    }
  }catch (e) {
    print('❌ [INIT] Error initializing app data: $e');
  }
}
