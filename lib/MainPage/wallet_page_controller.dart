import 'package:flutter/material.dart';
import 'package:funtury/Data/user_transfer_record.dart';
import 'package:funtury/Data/wallet_event.dart';
import 'package:funtury/Service/Path/user_path.dart';
import 'package:funtury/Service/ganache_service.dart';
import 'package:funtury/Service/network.dart';
import 'package:web3dart/credentials.dart';

class WalletPageController {
  WalletPageController({
    required this.context,
    required this.setState,
  });

  BuildContext context;
  void Function(VoidCallback) setState;

  late EthereumAddress walletAddress;
  late double balance;
  List<WalletEvent> userPosition = [];
  List<UserTransferRecord> userOrderHistory = [];

  GanacheService ganacheService = GanacheService();

  bool balanceLoading = false;
  bool claimedLoading = false;
  bool alreadyClaimed = false;
  bool positionLoading = false;
  bool orderHistoryLoading = false;
  bool orderHistoryLoadingFailed = false;

  void updateBalance(double newBalance) {
    setState(() {
      balance = newBalance;
    });
  }

  Future<void> init() async {
    setState(() {
      balanceLoading = true;
      claimedLoading = true;
    });

    try {
      getAllUserPosition();

      getAllUserOrderHistory();

      final result = await ganacheService.getBalance();
      balance = result;
      // balance = 20.0;
      alreadyClaimed = await ganacheService.checkFreeTokenClaimed();
      walletAddress = GanacheService.userAddress;
    } catch (e) {
      debugPrint("WalletPageController init error: $e");
    }

    if (context.mounted) {
      setState(() {
        balanceLoading = false;
        claimedLoading = false;
      });
    }
  }

  Future<void> getAllUserPosition() async {
    setState(() {
      positionLoading = true;
    });

    try {
      final result = await ganacheService.queryAllMarkets();

      userPosition.clear();
      for (var data in result) {
        WalletEvent event = WalletEvent.fromData(data);
        final position =
            await ganacheService.getUserPosition(event.marketAddress);
        if (position.$1 != 0 || position.$2 != 0) {
          event.yesShares = position.$1.toInt();
          event.noShares = position.$2.toInt();
          userPosition.add(event);
        }
      }
      // userPosition[
      //     EthereumAddress.fromHex("0x82Be6C4b686dF7908aB0771f18b4e3C134e923FD")] =
      //     (20.0, 80.0);

      debugPrint("WalletPageController getAllUserPosition success");
    } catch (e) {
      debugPrint("WalletPageController getAllUserPosition error: $e");
    }

    if (context.mounted) {
      setState(() {
        positionLoading = false;
      });
    }
  }

  Future<void> getAllUserOrderHistory() async {
    if (orderHistoryLoading == true) return;
    setState(() {
      orderHistoryLoading = true;
    });

    try {
      final result = await Network.manager.sendRequest(
          method: RequestMethod.get,
          path: UserPath.getUserTransactions,
          pathMid: [GanacheService.userAddress.hexEip55]);
      
      if (result["status"] == "error") {
        throw Exception(result["data"]["message"]);
      } else if (result["status"] == "failed") {
        throw Exception(result["data"]["message"]);
      } else if (result["status"] == "success") {
        final data = result["data"] as List<dynamic>;
        userOrderHistory.clear();
        for (var item in data) {
          UserTransferRecord record = UserTransferRecord.fromData(item as Map<String, dynamic>);
          userOrderHistory.add(record);
        }
      }
      debugPrint("WalletPageController getAllUserOrderHistory success");
    } catch (e) {
      orderHistoryLoadingFailed = true;
      debugPrint("WalletPageController getAllUserOrderHistory error: $e");
    }

    if (context.mounted) {
      setState(() {
        orderHistoryLoading = false;
      });
    }
  }

  Future<void> userOrderHistoryRefresh() async {
    if (orderHistoryLoading == true) return;
    setState(() {
      orderHistoryLoading = true;
      orderHistoryLoadingFailed = false;
    });

    final resutl = await Network.manager.sendRequest(
        method: RequestMethod.get,
        path: UserPath.getUserTransactions,
        pathMid: [GanacheService.userAddress.hexEip55]);

    if (resutl["status"] == "success") {
      final data = resutl["data"] as List<dynamic>;
      userOrderHistory.clear();
      for (var item in data) {
        UserTransferRecord record = UserTransferRecord.fromData(item as Map<String, dynamic>);
        userOrderHistory.add(record);
      }
      debugPrint("WalletPageController userOrderHistoryRefresh success");
    } else {
      if (context.mounted) {
        orderHistoryLoadingFailed = true;

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error"),
                content: Text("Order history loading failed"),
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
    }

    if (context.mounted) {
      setState(() {
        orderHistoryLoading = false;
      });
    }
  }

  Future<void> claimedFreeToken() async {
    setState(() {
      claimedLoading = true;
    });

    late bool result;
    try {
      await ganacheService.claimedFreeToken();

      debugPrint("WalletPageController claimedFreeToken success");
      result = true;
    } catch (e) {
      debugPrint("WalletPageController claimedFreeToken error: $e");
      result = false;
    }

    if (result && context.mounted) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Claimed Free Token"),
              content:
                  const Text("You have successfully claimed 50 free tokens!"),
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
      alreadyClaimed = true;
      balance += 50.0;
    }

    setState(() {
      claimedLoading = false;
    });
  }
}
