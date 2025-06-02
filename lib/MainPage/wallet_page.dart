import 'package:flutter/material.dart';
import 'package:funtury/Data/user_transfer_record.dart';
import 'package:funtury/Data/wallet_event.dart';
import 'package:funtury/MainPage/wallet_page_controller.dart';
import 'package:funtury/Service/Path/orders_path.dart';
import 'package:funtury/Service/ganache_service.dart';
import 'package:funtury/Service/network.dart';
import 'package:funtury/route_map.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late WalletPageController walletPageController;

  @override
  initState() {
    super.initState();
    walletPageController = WalletPageController(
      context: context,
      setState: setState,
    );
    walletPageController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Wallet",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.history,
                                    color: Colors.black,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.settings,
                                    color: Colors.black,
                                  ))
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 350,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        alignment: Alignment.center,
                        child: walletPageController.balanceLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Balance\nF ${walletPageController.balance.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 220,
                          height: 38,
                          child: walletPageController.claimedLoading
                              ? Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ))
                              : ElevatedButton(
                                  onPressed: walletPageController.alreadyClaimed
                                      ? () {}
                                      : walletPageController.claimedFreeToken,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          walletPageController.alreadyClaimed
                                              ? Colors.grey
                                              : Colors.orangeAccent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: walletPageController.alreadyClaimed
                                      ? Text(
                                          "Free Tokens Has Claimed",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          "Claim Free Tokens",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: PageView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Stocks",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                                  SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3.0,
                                  ),
                                  SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3.0,
                                  ),
                                ],
                              ),
                              Expanded(
                                child: walletPageController.positionLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : walletPageController.userPosition.isEmpty
                                        ? Center(
                                            child: Text(
                                              "Empty",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          )
                                        : ListView.builder(
                                            padding: const EdgeInsets.only(
                                              bottom: 80.0,
                                            ),
                                            itemBuilder: (_, index) {
                                              return Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 5.0),
                                                  child: PositionCard(
                                                    event: walletPageController
                                                        .userPosition[index],
                                                    walletPageController:
                                                        walletPageController,
                                                  ));
                                            },
                                            itemCount: walletPageController
                                                .userPosition.length),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Orders",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                                  SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3.0,
                                  ),
                                  SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3.0,
                                  ),
                                ],
                              ),
                              Expanded(
                                child: walletPageController.orderHistoryLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : walletPageController
                                            .orderHistoryLoadingFailed
                                        ? Center(child: Text("Loading Failed"))
                                        : walletPageController
                                                .userOrderHistory.isEmpty
                                            ? Center(
                                                child: Text("No order created"))
                                            : RefreshIndicator(
                                                onRefresh: walletPageController
                                                    .userOrderHistoryRefresh,
                                                child: SingleChildScrollView(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 80.0),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    physics:
                                                        const AlwaysScrollableScrollPhysics(),
                                                    child: Column(
                                                      children: [
                                                        for (var orderInfo
                                                            in walletPageController
                                                                .userOrderHistory
                                                                .reversed) ...[
                                                          if (orderInfo
                                                                  .status !=
                                                              OrderStatus
                                                                  .cancelled)
                                                            Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10.0),
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5.0),
                                                                child: OrderCard(
                                                                    orderInfo:
                                                                        orderInfo))
                                                        ]
                                                      ],
                                                    )),
                                              ),
                              )
                            ],
                          )
                        ],
                      ))
                    ]))));
  }
}

class PositionCard extends StatefulWidget {
  const PositionCard(
      {super.key, required this.event, required this.walletPageController});

  final WalletEvent event;
  final WalletPageController walletPageController;

  @override
  State<PositionCard> createState() => _PositionCardState();
}

class _PositionCardState extends State<PositionCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final int? addBalance = await Navigator.of(context)
            .pushNamed(RouteMap.tradeDetailPage, arguments: (
          widget.event.marketAddress,
          widget.event.yesShares,
          widget.event.noShares
        ));
        if (addBalance != null) {
          widget.walletPageController
              .updateBalance(widget.walletPageController.balance + addBalance);
        }
      },
      child: Container(
        width: 355,
        height: 90,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Preorder Time: ${widget.event.preOrderTime.year}.${widget.event.preOrderTime.month}.${widget.event.preOrderTime.day}",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "Resolve Time: ${widget.event.resolutionTime.year}.${widget.event.resolutionTime.month}.${widget.event.resolutionTime.day}",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      margin: const EdgeInsets.only(right: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Text(
                        "Yes",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 25,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.event.yesShares.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      margin: const EdgeInsets.only(right: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Text(
                        "No",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 25,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.event.noShares.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  const OrderCard({super.key, required this.orderInfo});

  final UserTransferRecord orderInfo;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool marketInfoLoading = false;
  bool canceling = false;
  String marketTitle = "";

  @override
  void initState() {
    super.initState();
    getMarketInfo();
  }

  Future<void> getMarketInfo() async {
    setState(() {
      marketInfoLoading = true;
    });

    try {
      final ganacheService = GanacheService();
      final result =
          await ganacheService.getMarketInfo(widget.orderInfo.marketAddress);
      // Assume we got the market title from the service
      marketTitle = result!['title'] ?? "Unknown Market";
    } catch (e) {
      marketTitle = "Error fetching market title";
      debugPrint("Error fetching market info: $e");
    }

    if (context.mounted) {
      setState(() {
        marketInfoLoading = false;
      });
    }
  }

  Future<void> sendCancelRequest() async {
    if (canceling ||
        widget.orderInfo.status == OrderStatus.cancelled ||
        widget.orderInfo.status == OrderStatus.dealt) return;
    setState(() {
      canceling = true;
    });

    try {
      final result = await Network.manager.sendRequest(
          method: RequestMethod.post,
          path: OrdersPath.cancel,
          pathMid: [widget.orderInfo.orderId.toString()]);
      if (context.mounted) {
        if (result["status"] == "success") {
          widget.orderInfo.status = OrderStatus.cancelled;
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Success"),
                    content: Text("Order canceled successfully."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ));
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Error"),
              content:
                  Text("Canceling order failed: ${result['data']['message']}"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK"),
                ),
              ],
            ),
          );
        }
      }
      // Optionally, you can show a success message or update the UI
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text("Error canceling order: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
      debugPrint("Error canceling order: $e");
    }

    if (context.mounted) {
      setState(() {
        canceling = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 143,
        width: 353,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: marketInfoLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.grey,
              ))
            : Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 336,
                      height: 30,
                      child: Text(
                        marketTitle,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 16,
                      width: 336,
                      child: Text(
                          "${widget.orderInfo.createTime.year}-${widget.orderInfo.createTime.month}-${widget.orderInfo.createTime.day} ${widget.orderInfo.createTime.hour}:${widget.orderInfo.createTime.minute} Created",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            height: 80,
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(
                                  text: "- Outcome:",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal),
                                  children: [
                                    TextSpan(
                                      text: widget.orderInfo.outcome ==
                                              Outcome.yes
                                          ? "Yes"
                                          : "No",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                                RichText(
                                    text: TextSpan(
                                        text: "- Side:",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal),
                                        children: [
                                      TextSpan(
                                        text: widget.orderInfo.side == Side.buy
                                            ? " Buy"
                                            : " Sell",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ])),
                                RichText(
                                  text: TextSpan(
                                      text: "- Dealt amount:",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal),
                                      children: [
                                        TextSpan(
                                            text: widget.orderInfo.dealAmount
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold))
                                      ]),
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: "- Remaining amount:",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal),
                                      children: [
                                        TextSpan(
                                          text: widget.orderInfo.remainingAmount
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]),
                                ),
                                RichText(
                                    text: TextSpan(
                                  text: "- Price:",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal),
                                  children: [
                                    TextSpan(
                                      text:
                                          "${widget.orderInfo.price.toStringAsFixed(2)} F",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                              ],
                            )),
                        Container(
                          alignment: Alignment.bottomRight,
                          width: 100,
                          height: 73,
                          child: SizedBox(
                              width: 120,
                              height: 25,
                              child: ElevatedButton(
                                  onPressed: sendCancelRequest,
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: widget.orderInfo.status ==
                                            OrderStatus.cancelled
                                        ? Colors.grey
                                        : Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: canceling
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : widget.orderInfo.status ==
                                              OrderStatus.cancelled
                                          ? Center(
                                              child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    "Cancelled",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  )))
                                          : widget.orderInfo.status ==
                                                  OrderStatus.dealt
                                              ? Center(
                                                  child: Text(
                                                    "Dealt",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                )
                                              : Center(
                                                  child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                )))),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
  }
}
