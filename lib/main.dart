import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/progress.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final progress = await AcademyProgress.load();
  runApp(LumarApp(progress: progress));
}
