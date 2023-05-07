import 'package:flutter/material.dart';
import 'package:manav_sewa/FrontEnd/constants/bottom_bar.dart';
import 'package:manav_sewa/FrontEnd/constants/globalvariables.dart';
import 'package:manav_sewa/FrontEnd/provider/ngo_provider.dart';
import 'package:manav_sewa/FrontEnd/provider/Donor_provider.dart';
import 'package:manav_sewa/FrontEnd/screens/carousal_slider/carousal_slider.dart';
import 'package:manav_sewa/FrontEnd/services/AuthService.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  SharedPreferences.getInstance();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => DonorProvider(),
    ),
    ChangeNotifierProvider(create: (context) => NGOProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  @override
  void initState() {
    configeonesignal();
    super.initState();
    authService.getUserData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DonorProvider>(
      builder: (context, donorProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ManavSewa',
          theme: ThemeData(
            scaffoldBackgroundColor: GlobalVariables.backgroundColor,
            colorScheme: const ColorScheme.light(
              primary: GlobalVariables.secondaryColor,
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
            useMaterial3: true, // can remove this line
          ),
          home: donorProvider.donor.token.isNotEmpty
              ? BottomBar()
              : ScreenSlider(),
        );
      },
    );
  }

  void configeonesignal() async {
    await OneSignal.shared.setAppId('b3f6bbb6-34cb-47aa-9308-f36ba09d1129');
    OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
      OSNotificationDisplayType.notification;
    });
  }
}
