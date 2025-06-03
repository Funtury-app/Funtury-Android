import 'package:flutter/material.dart';
import 'package:funtury/Data/browser_event.dart';
import 'package:funtury/Service/ganache_service.dart';

class BrowserPageController {
  BrowserPageController({
    required this.context,
    required this.setState,
  });
  late BuildContext context;
  late void Function(VoidCallback) setState;
  // ReownAppKitModal appKitModal = ReownService.service!.appKitModal!;
  GanacheService ganacheService = GanacheService();

  List<BrowserEvent> events = [];

  bool isLoading = false;

  Future<void> init() async {
    if(isLoading) return;
    setState(() {
      isLoading = true;
    });
    
    try {
      final result = await Future.wait([
        ganacheService.queryAllMarkets(),
      ]);

      events.clear();

      for (int i = 0; i < result[0].length; i++) {
        events.add(BrowserEvent.fromData(result[0][i]));
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error"),
                content:
                    const Text("Failed to load market data. Please try again."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            });
      }
      debugPrint("BrowserPageController init error: $e");
    }

    // events.add(BrowserEvent(marketAddress: EthereumAddress.fromHex("0x82Be6C4b686dF7908aB0771f18b4e3C134e923FD"), yesProbability: 20, noProbability: 80));
    // events.add(BrowserEvent(marketAddress: EthereumAddress.fromHex("0x82Be6C4b686dF7908aB0771f18b4e3C134e923FD"), yesProbability: 40, noProbability: 60));

    if (context.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> refresh() async {
    await init();
  }
}