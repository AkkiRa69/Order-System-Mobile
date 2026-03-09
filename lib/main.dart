import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store/pages/splash_screen.dart';
import 'package:grocery_store/providers/address_provider.dart';
import 'package:grocery_store/providers/card_provider.dart';
import 'package:grocery_store/providers/comment_provider.dart';
import 'package:grocery_store/providers/fruit_provider.dart';
import 'package:grocery_store/providers/order_provider.dart';
import 'package:grocery_store/providers/randomuser_provider.dart';
import 'package:grocery_store/providers/search_provider.dart';
import 'package:grocery_store/providers/table_order_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPathProvider();
  runApp(const MyApp());
}

Future<void> initPathProvider() async {
  await getApplicationDocumentsDirectory(); // Initialize path_provider
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FruitProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddressProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CardProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RandomuserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CommentProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TableOrderProvider(),
        ),
      ],
      child: const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
