import 'dart:math';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:funtury/Service/ganache_service.dart';
import 'package:funtury/route_map.dart';
import 'package:funtury/secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:reown_appkit/reown_appkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Checking user identity
  try {
    final result = await Future.wait([
      SecureStorage.read(StoreKey.userPrivateKey),
      SecureStorage.read(StoreKey.userWalletAddress),
    ]);
    if (result[0] == null || result[1] == null) {
      throw Exception('User identity not found in secure storage');
    } else {
      final privateKey = EthPrivateKey.fromHex(result[0]!);
      final walletAddress = EthereumAddress.fromHex(result[1]!);

      GanacheService.setPrivateKeyWalletAddress(privateKey, walletAddress);
    }
  } catch (e) {
      // Generate a unique for user
      final privateKey = EthPrivateKey.createRandom(Random.secure());
      final walletAddress = privateKey.address;

      SecureStorage.store(StoreKey.userPrivateKey, privateKey.privateKeyInt.toRadixString(16));
      SecureStorage.store(StoreKey.userWalletAddress, walletAddress.hexEip55);
      GanacheService.setPrivateKeyWalletAddress(privateKey, walletAddress);
  }

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     // ChangeNotifierProvider(create: (_) => WalletService())
    //   ],
    //   child:
    return MaterialApp(
      title: 'Funtury',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD030),
          primary: const Color(0xFFFFD030),
          secondary: const Color(0xFF000000),
          tertiary: const Color(0xFFFFFFFF),
        ),
        textTheme:
            GoogleFonts.instrumentSansTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ).copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeThroughPageTransitionsBuilder(),
          TargetPlatform.linux: FadeThroughPageTransitionsBuilder(),
          TargetPlatform.windows: FadeThroughPageTransitionsBuilder(),
        },
      )),
      routes: RouteMap.routes,
      initialRoute: RouteMap.homePage,
    );
    // );
  }
}
