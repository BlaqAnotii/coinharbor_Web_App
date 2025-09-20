import 'dart:async';

import 'package:coinharbor/config/config.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/resources/events.dart';
import 'package:coinharbor/resources/routes.dart';
import 'package:coinharbor/resources/theme.dart';
import 'package:coinharbor/services/app_cache.dart';
import 'package:coinharbor/views/welcome_screen.dart';
import 'package:coinharbor/widgets/responsive.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'services/locator.dart';
import 'services/navigation_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  run();
}

Future run() async {
  Config.appFlavor = Flavor.DEVELOPMENT;
  setupLocator();
  getIt<AppData>().init();
  runApp(const MyApp());

  //setup dependency injector
}

var keyako = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? subscription;
  String appTitle = 'Welcome To ';

  void listenForTitle() {
    getIt<AppData>().eventBus!.on<ApplicationEvent>().listen(
        (event) {
      if (event.type == 'app_title') {
        setState(() {
          appTitle = "${event.message} | ";
        });
      }
    }, onError: (e) {
      debugPrint(e.toString());
    }, onDone: () => debugPrint("done with bus"));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenForTitle();
  }

  @override
  Widget build(BuildContext context) {
    //getIt<NavigationService>().materialC = context;
    return OKToast(
        child: ScreenUtilInit(
      //setup to fit into bigger screens
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: MaterialApp.router(
            routerConfig: getIt<AppRouteConfig>().getRoutes(),
            debugShowCheckedModeBanner: false,
            title: "${appTitle}Coinharbor",
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: ThemeMode.system,
            // BottomNav(selectedIndex: 0),
          ),
        );
      },
    ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  bool _chatLoaded = false;
  bool _chatOpen = false;

  void _toggleChat() {
    if (!_chatLoaded) {
      // Inject Tawk.to script once
      final script = html.ScriptElement()
        ..id = "tawk-script"
        ..src =
            'https://embed.tawk.to/68ce5320f6dadc19215a519c/1j5iv9es8' // replace with your Tawk.to link
        ..async = true;
      html.document.body?.append(script);

      // Mark as loaded
      setState(() => _chatLoaded = true);

      // Open after load
      Future.delayed(const Duration(seconds: 2), () {
        js.context.callMethod('eval', ['Tawk_API.maximize();']);
        setState(() => _chatOpen = true);
      });
    } else {
      // Toggle open/close using Tawk API
      if (_chatOpen) {
        js.context.callMethod('eval', ['Tawk_API.minimize();']);
      } else {
        js.context.callMethod('eval', ['Tawk_API.maximize();']);
      }
      setState(() => _chatOpen = !_chatOpen);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: ResponsiveWidget.isSmallScreen(context)
          ? Drawer(
              child: Container(
                color: const Color(0xfffffffff),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: Image.asset(
                        'assets/image/logo.png',
                        scale: 6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      color: Colors.blueGrey[400],
                      thickness: 0.5,
                    ),
                    const SizedBox(height: 30),
                    ListTile(
                      onTap: () {
                        context.go('/home');
                      },
                      leading: const Icon(
                        Iconsax.home_1,
                        size: 22,
                        color: Color(0xff4779A3),
                      ),
                      title: const Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Iconsax.people,
                        size: 22,
                        color: Color(0xff4779A3),
                      ),
                      title: const Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        //  navigationService.push(const WithdrawMoneyScreen());
                        //   context.go('/about-us');

                        // Navigate or handle logic for withdrawing money
                      },
                    ),
                    ListTile(
                      onTap: () {
                        //context.go('/contact_us');
                      },
                      leading: const Icon(
                        Iconsax.call_add,
                        size: 22,
                        color: Color(0xff4779A3),
                      ),
                      title: const Text(
                        'Contact Us',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Copyright © 2024 | Coinharbor',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            )
          : null,
      body: const WelcomeScreen(),
      floatingActionButton: InkWell(
        onTap: _toggleChat,
        child: CircleAvatar(
          backgroundColor: AppColors.primary,
          radius: 30,
          child: _chatOpen
              ? const Icon(
                  Icons.close,
                  color: AppColors.white,
                )
              : const Icon(
                  Iconsax.message5,
                  color: AppColors.white,
                ),
        ),
      ),
    );
  }
}
