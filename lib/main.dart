import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insulin_calculate/product/calculate/viewmodel/calculate_viewmodel.dart';
import 'package:insulin_calculate/product/calendar/viewmodel/calendar_viewmodel.dart';
import 'package:insulin_calculate/product/main_page/view/main_page_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CalculateViewModel>(
            create: (context) => CalculateViewModel()),
        ChangeNotifierProvider<CalendarViewModel>(
            create: (context) => CalendarViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainPageView(),
      ),
    );
  }
}
