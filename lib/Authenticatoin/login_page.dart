import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:funtury/Authenticatoin/login_page_controller.dart';
import 'package:funtury/Service/wallet_service.dart';
import 'package:funtury/assets_path.dart';
import 'package:funtury/route_map.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginPageController loginPageController;

  @override
  void initState() {
    super.initState();
    // if (ReownService.service != null) ReownService.service!.dispose();
    // ReownService.service = ReownService.create(context, setState);

    loginPageController =
        LoginPageController(context: context, setState: setState);
    loginPageController.init();
  }

  @override
  Widget build(BuildContext context) {
    // final walletService = Provider.of<WalletService>(context);
    // loginPageController.walletService = walletService;
    // if(walletService.isConnected){
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.of(context).pushReplacementNamed(RouteMap.homePage);
    //   });
    // }

    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
            0.85,
            1.0,
          ],
              colors: [
            Colors.white,
            Theme.of(context).colorScheme.primary,
          ])),
      child: FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.cover,
          child: Container(
              width: 393,
              height: 852,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.85,
                      1.0,
                    ],
                    colors: [
                      Colors.white,
                      Theme.of(context).colorScheme.primary,
                    ]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 79,
                  ),
                  Container(
                    height: 120,
                    width: 393,
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    child: Text(
                      "Welcom\n Funtury",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    width: 400,
                    child: Image.asset(AssetsPath.loginMainIcon),
                  ),
                  SizedBox(
                    height: 36,
                    width: 303,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  LoginButton(
                    loginMethod: "MetaMask",
                    iconPath: AssetsPath.metaMaskIcon,
                    onPressed: loginPageController.loginWallet,
                    connecting: loginPageController.isConnecting,
                  ),
                ],
              ))),
    ));
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.loginMethod,
    required this.iconPath,
    required this.onPressed,
    required this.connecting,
  });

  final String loginMethod;
  final String iconPath;
  final Function onPressed;
  final bool connecting;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 303,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0x66666666),
          width: 2,
        ),
      ),
      child: connecting
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.white,
            ))
          : TextButton.icon(
              onPressed: () => onPressed(),
              icon: SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
              ),
              iconAlignment: IconAlignment.start,
              label: Text(
                loginMethod,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}
