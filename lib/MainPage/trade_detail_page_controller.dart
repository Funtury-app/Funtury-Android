import 'package:flutter/material.dart';
import 'package:funtury/Data/event_detail.dart';
import 'package:funtury/Data/order.dart';
import 'package:funtury/Data/user_transfer_record.dart';
import 'package:funtury/Data/yes_no_transaction.dart';
import 'package:funtury/Service/Path/orders_path.dart';
import 'package:funtury/Service/ganache_service.dart';
import 'package:funtury/Service/network.dart';
import 'package:reown_appkit/modal/pages/preview_send/utils.dart';
import 'package:reown_appkit/reown_appkit.dart';

class TradeDetailPageController {
  TradeDetailPageController(
      {required this.context,
      required this.setState,
      required this.marketAddress,
      this.userYesPosition,
      this.userNoPosition});

  final ganacheService = GanacheService();
  EventDetail eventDetail = EventDetail.initFromDefault();
  List<YesNoTransaction> yesTransactions = [];
  List<YesNoTransaction> noTransactions = [];

  OrderBookOrder orderBook = OrderBookOrder();  

  double yesBaseProbability = 0.5;
  double noBaseProbability = 0.5;

  late BuildContext context;
  late void Function(VoidCallback) setState;
  late EthereumAddress marketAddress;

  TextEditingController amountTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();

  bool isYesDiagram = true;
  bool isBuyingPosition = true;
  bool isYesPosition = true;

  bool marketInfoLoading = false;
  bool diagramDataLoading = false;
  bool orderBookDataLoading = false;
  bool orderBookLoadingError = false;
  bool purchaseRequestSending = false;
  bool rewardClaiming = false;
  bool probabilityLoading = false;

  double price = 0.5;
  double maxPrice = 1.0;
  double minPrice = 0.0;

  int amount = 0;
  int maxAmount = 999;
  int minAmount = 0;

  double fee = 0.1;

  double get totalCost {
    return (amount * price) * (1 + fee);
  }

  int slidingYesNoDiagram = 0;
  int slidingPosition = 0;
  int slidingYesNoOutcome = 0;

  int? userYesPosition;
  int? userNoPosition;
  double? userBalance;

  Future<void> init() async {
    amountTextController.text = amount.toString();
    priceTextController.text = price.toStringAsFixed(2);

    setState(() {
      marketInfoLoading = true;
    });

    // Market info loading logic here
    try {
      final data = await ganacheService.getMarketInfo(marketAddress);
      eventDetail = EventDetail.initFromData(data);

      // final data = {
      //       "title": "Market Title",
      //       "createTime":
      //           BigInt.from(DateTime.now().millisecondsSinceEpoch / 1000),
      //       "resolutionTime": BigInt.from(DateTime.now()
      //               .add(const Duration(days: 2))
      //               .millisecondsSinceEpoch /
      //           1000),
      //       "preOrderTime": BigInt.from(DateTime.now()
      //               .add(const Duration(days: 1))
      //               .millisecondsSinceEpoch /
      //           1000),
      //       "funturyContract": marketAddress,
      //       "owner": marketAddress,
      //       "resolvedToYes": false,
      //       "marketState": 0,
      //       "remainYesShares": BigInt.from(1000),
      //       "remainNoShares": BigInt.from(500),
      //       "initialPrice": BigInt.from(0.5),
      //     },
      //     eventDetail = EventDetail.initFromData(data);
      // await Future.delayed(const Duration(seconds: 2));
      if (userYesPosition == null && userNoPosition == null) {
        await ganacheService.getUserPosition(marketAddress).then((value) {
          userYesPosition = value.$1.toInt();
          userNoPosition = value.$2.toInt();
        });
      }

      userBalance ??=
          await ganacheService.getUserBalance(GanacheService.userAddress);

      // Load diagram data
      lodaYesNoTransactionData();

      // Load base probability
      if(eventDetail.marketState != MarketState.preorder){
        calculateBaseYesNoProbability();
      } else{
        yesBaseProbability = 0.5;
        noBaseProbability = 0.5;
      }

      // Load order book data
      loadOrderBookOrder();

      debugPrint("Market info: $data");
    } catch (e) {
      if (context.mounted) {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error"),
                content:
                    const Text("Failed to load market info. Please try again."),
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
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
      debugPrint("Market info loading error: $e");
    }

    setState(() {
      marketInfoLoading = false;
    });
  }

  Future lodaYesNoTransactionData() async {
    if (diagramDataLoading) return;
    setState(() {
      diagramDataLoading = true;
    });

    try {
      final result = await Future.wait([
        ganacheService.queryAllYesTransactionRecord(marketAddress),
        ganacheService.queryAllNoTransactionRecord(marketAddress),
      ]);

      if (result[0].$1 && result[1].$1) {
        yesTransactions =
            result[0].$2.map((e) => YesNoTransaction.fromData(e)).toList();
        noTransactions =
            result[1].$2.map((e) => YesNoTransaction.fromData(e)).toList();

        yesTransactions.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        noTransactions.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        debugPrint("Yes transactions: $yesTransactions");
        debugPrint("No transactions: $noTransactions");
      } else {
        throw Exception("Failed to load transaction data");
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error"),
                content: const Text(
                    "Failed to load transaction data. Please try again."),
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
      debugPrint("Diagram data loading error: $e");
    }

    if (context.mounted) {
      setState(() {
        diagramDataLoading = false;
      });
    }
  }

  Future calculateBaseYesNoProbability() async{
    if(probabilityLoading) return;
    setState((){
      probabilityLoading = true;
    });

    try{
      final result = await ganacheService.getMarketPreorderSellingInfo(marketAddress);
      if(result.$1){
        double yesSelling = result.$2["init_yes"] - result.$2["remain_yes"];
        double noSelling = result.$2["init_no"] - result.$2["remain_no"];

        yesBaseProbability = yesSelling / (yesSelling + noSelling);
        noBaseProbability = noSelling / (yesSelling + noSelling);

        debugPrint("Base probability calculated: Yes: $yesBaseProbability, No: $noBaseProbability");
      } else{
        throw Exception("Failed to calculate base probability");
      }
    } catch(e){
      debugPrint("Base probability calculation error: $e");
    }


    if(context.mounted){
      setState((){
        probabilityLoading = false;
      });
    }
  }

  Future loadOrderBookOrder() async{
    if(orderBookDataLoading) return;
    setState((){
      orderBookDataLoading = true;
    });

    try{
      final result = await Future.wait([
        Network.manager.sendRequest(method: RequestMethod.get, path: OrdersPath.orderbook, pathMid: [marketAddress.hexEip55, "yes"]),
        Network.manager.sendRequest(method: RequestMethod.get, path: OrdersPath.orderbook, pathMid: [marketAddress.hexEip55, "no"]),
      ]);

      if(result[0]["status"] == "success" && result[1]["status"] == "success"){
        orderBook.clear();
        final yesOrders = result[0]["data"];
        final noOrders = result[1]["data"];
        for (var order in yesOrders) {
          double price = order["price"].toDouble();
          int amount = order["amount"];
          if(order["side"] == "buy"){
            orderBook.buyYesOrders[price] = orderBook.buyYesOrders[price] == null ? amount : orderBook.buyYesOrders[price]! + amount;
          }else{
            orderBook.sellYesOrders[price] = orderBook.sellYesOrders[price] == null ? amount : orderBook.sellYesOrders[price]! + amount;
          }
        }

        for(var order in noOrders){
          double price = order["price"].toDouble();
          int amount = order["amount"];
          if(order["side"] == "buy"){
            orderBook.buyNoOrders[price] = orderBook.buyNoOrders[price] == null ? amount : orderBook.buyNoOrders[price]! + amount;
          }else{
            orderBook.sellNoOrders[price] = orderBook.sellNoOrders[price] == null ? amount : orderBook.sellNoOrders[price]! + amount;
          }
        }
        
        debugPrint("Order book data loaded successfully");
      } else{
        throw Exception("Failed to load order book data");
      }
    } catch(e){
      orderBookLoadingError = true;
      debugPrint("Order book data loading error: $e");
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error"),
                content: const Text(
                    "Failed to load order book data. Please try again."),
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
    if(context.mounted){
      setState((){
        orderBookDataLoading = false;
      });
    }
  }

  void switchDiagram(int? newValue) {
    if (newValue == null) return;
    setState(() {
      slidingYesNoDiagram = newValue;
      isYesDiagram = newValue == 0;
    });
  }

  void switchPosition(int? newValue) {
    if (newValue == null) return;

    setState(() {
      slidingPosition = newValue;
      isBuyingPosition = newValue == 0;
    });
  }

  void switchYesNoOutcome(int? newValue) {
    if (newValue == null) return;
    setState(() {
      slidingYesNoOutcome = newValue;
      isYesPosition = newValue == 0;
    });
  }

  void increAmount(int value) {
    setState(() {
      amount += value;
      if (amount < 0) {
        amount = 0;
      }
      amountTextController.text = amount.toString();
    });
  }

  void amountTextControllerOnChange(String value) {
    if (value.isEmpty) {
      amount = 0;
      return;
    }
    if (value.toInt()! > maxAmount) {
      amountTextController.text = maxAmount.toString();
    } else if (value.toInt()! < minAmount) {
      amountTextController.text = minAmount.toString();
    } else {
      amountTextController.text = value;
    }
    amount = amountTextController.text.toInt()!;
    setState(() {});
  }

  void priceTextControllerOnChange(String value) {
    if (value.isEmpty) {
      price = 0;
      return;
    }
    double inputValue = value.toDouble().toStringAsFixed(2).toDouble();
    if (inputValue > maxPrice) {
      priceTextController.text = maxPrice.toStringAsFixed(2);
    } else if (inputValue < minPrice) {
      priceTextController.text = minPrice.toString();
    } else {
      priceTextController.text = inputValue.toString();
    }
    price = priceTextController.text.toDouble();
    setState(() {});
  }

  Future purchaseRequestSent() async {
    if (purchaseRequestSending) return;
    setState(() {
      purchaseRequestSending = true;
    });

    try {
      if (eventDetail.marketState == MarketState.preorder) {
        final result = await ganacheService.preorderPurchase(
            marketAddress, isYesPosition, price, amount);
        if (result.$1) {
          if (context.mounted) {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Success"),
                    content: const Text("Preorder purchase success."),
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
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
        } else {
          throw Exception("Preorder purchase failed");
        }
      } else if (eventDetail.marketState == MarketState.active) {
        // Call backend to create order to order book
        if (isBuyingPosition && userBalance! < totalCost) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Insufficient Balance"),
                  content: const Text(
                      "You do not have enough balance to make this purchase."),
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
          if (context.mounted) {
            setState(() {
              purchaseRequestSending = false;
            });
          }
          return;
        } else if(!isBuyingPosition){
          if (isYesPosition && userYesPosition! < amount) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Insufficient Yes Position"),
                    content: const Text(
                        "You do not have enough Yes position to make this purchase."),
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
            if (context.mounted) {
              setState(() {
                purchaseRequestSending = false;
              });
            }
            return;
          } else if (!isYesPosition && userNoPosition! < amount) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Insufficient No Position"),
                    content: const Text(
                        "You do not have enough No position to make this purchase."),
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
            if (context.mounted) {
              setState(() {
                purchaseRequestSending = false;
              });
            }
            return;
          }
        }

        Order order = Order(
            userAddress: GanacheService.userAddress,
            marketAddress: marketAddress,
            outcome: isYesPosition ? Outcome.yes : Outcome.no,
            price: price,
            amount: amount,
            side: isBuyingPosition ? Side.buy : Side.sell);
        final result = await Network.manager.sendRequest(
            method: RequestMethod.post,
            path: OrdersPath.create,
            data: order.toJson);

        if (result["status"] == "success") {
          if (context.mounted) {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Success"),
                    content: const Text("Purchase order create successfully."),
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
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
        } else {
          throw Exception("Sending purchase request failed");
        }
      } else {
        throw Exception("Invalid market state");
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error"),
                content: const Text(
                    "Failed to send purchase request. Please try again."),
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
      debugPrint("Sending purchase request failed: ${e.toString()}");
    }

    if (context.mounted) {
      setState(() {
        purchaseRequestSending = false;
      });
    }
  }

  Future<void> claimedReward() async {
    if (rewardClaiming) return;
    setState(() {
      rewardClaiming = true;
    });

    try {
      final result =
          await ganacheService.claimRewardFromMarketRequest(marketAddress);

      if (context.mounted) {
        if (result.$1) {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Success"),
                  content: const Text("Claimed reward success."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(eventDetail.resolvedToYes
                            ? userYesPosition
                            : userNoPosition);
                      },
                      child: const Text("OK"),
                    ),
                  ],
                );
              });
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        } else {
          if (result.$2 == "Already claimed") {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Error"),
                    content: const Text("You have already claimed the reward."),
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
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
          throw Exception("Claiming reward failed");
        }
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error"),
                content:
                    const Text("Failed to claim reward. Please try again."),
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
      debugPrint("Claiming reward failed: ${e.toString()}");
    }

    if (context.mounted) {
      setState(() {
        rewardClaiming = false;
      });
    }
  }
}

class OrderBookOrder{
  Map<double, int> sellYesOrders = {};
  Map<double, int> sellNoOrders = {};
  Map<double, int> buyYesOrders = {};
  Map<double, int> buyNoOrders = {};

  void clear(){
    sellYesOrders.clear();
    sellNoOrders.clear();
    buyYesOrders.clear();
    buyNoOrders.clear();
  }

  get sellYesList {
    return sellYesOrders.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
  }
  get sellNoList {
    return sellNoOrders.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
  }
  get buyYesList {
    return buyYesOrders.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
  }
  get buyNoList {
    return buyNoOrders.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
  }
}