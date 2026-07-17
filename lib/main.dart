import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'app.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();

  // window_manager sadece masaüstünde (Windows/macOS/Linux) çalışır.
  // Web'de kIsWeb true olduğu için bu bloğu atlıyoruz, aksi halde
  // uygulama tarayıcıda açılmadan hata verir.
  if (!kIsWeb) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      size: Size(1280, 800),
      minimumSize: Size(1024, 700),
      center: true,
      title: 'Dershane Yönetim Paneli',
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const DershaneApp());
}
