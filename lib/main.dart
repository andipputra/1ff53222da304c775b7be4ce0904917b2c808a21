import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/app_module.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/presenter/product_screen/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  final appModule = AppModule();

  initializeDateFormatting().then((_) {
    appModule.setup();

    runApp(
      FutureBuilder(
        future: AppModule.injector.allReady(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return appModule.configureBloc(MyApp());
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  });

  // runApp(MultiBlocProvider(
  //   providers: [
  //
  //   ],
  //   child: MyApp(),
  // ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          // primarySwatch: Colors.blue,
          textTheme: GoogleFonts.openSansTextTheme(),
          appBarTheme: AppBarTheme(color: Colors.white)),
      home: ProductScreen(),
    );
  }
}
