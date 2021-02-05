
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/app.dart';
import 'package:mkombozi_mobile/data/offline_database.dart';
import 'package:mkombozi_mobile/services/account_service.dart';
import 'package:mkombozi_mobile/services/login_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final app = MyApp();
  final database = OfflineDatabase();
  await database.open();
  final root = MultiProvider(
    providers: [
      Provider(create: (_) => database),
      Provider(create: (_) => LoginService(database)),
      Provider(create: (_) => AccountService(database))
    ],
    child: app,
  );

  runApp(root);
}