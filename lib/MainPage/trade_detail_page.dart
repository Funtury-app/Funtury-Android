import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funtury/Data/event_detail.dart';
import 'package:funtury/Data/yes_no_transaction.dart';
import 'package:funtury/MainPage/trade_detail_page_controller.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:web3dart/credentials.dart';

class TradeDetailPage extends StatefulWidget {
  const TradeDetailPage(
      {super.key,
      required this.marketAddress,
      this.userYesShares,
      this.userNoShares});

  final EthereumAddress marketAddress;
  final int? userYesShares;
  final int? userNoShares;

  @override
  State<TradeDetailPage> createState() => _TradeDetailPageState();
}

class _TradeDetailPageState extends State<TradeDetailPage> {
  late TradeDetailPageController tradeDetailPageController;

  @override
  void initState() {
    super.initState();
    tradeDetailPageController = TradeDetailPageController(
      context: context,
      setState: setState,
      marketAddress: widget.marketAddress,
      userYesPosition: widget.userYesShares,
      userNoPosition: widget.userNoShares,
    );

    tradeDetailPageController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Color(0XFFFFE797),
              Colors.white,
              Theme.of(context).colorScheme.primary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.37, 0.71, 1.0]),
      ),
      child: FittedBox(
          fit: BoxFit.fill,
          child: SizedBox(
            width: 393,
            height: 852,
            child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: true,
              body: Container(
                padding: const EdgeInsets.fromLTRB(8.0, 25.0, 8.0, 10.0),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Color(0XFFFFE797),
                    Colors.white,
                    Theme.of(context).colorScheme.primary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.37, 0.71, 1.0],
                )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Color(0xFF2C76EE).withOpacity(0.8),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            tradeDetailPageController
                                .eventDetail.marketState.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    if (tradeDetailPageController.marketInfoLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      ),
                    if (!tradeDetailPageController.marketInfoLoading) ...[
                      // Market title info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Icon(Icons.image,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            tradeDetailPageController.eventDetail.title!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Diagram Place
                      if (MediaQuery.of(context).viewInsets.bottom == 0)
                        Container(
                          width: 345,
                          height: 313,
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Yes No diagram switcher
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: CupertinoSlidingSegmentedControl(
                                        children: {
                                          0: Text("Yes"),
                                          1: Text("No"),
                                        },
                                        groupValue: tradeDetailPageController
                                            .slidingYesNoDiagram,
                                        onValueChanged: (int? newValue) {
                                          tradeDetailPageController
                                              .switchDiagram(newValue!);
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            tradeDetailPageController
                                                    .isYesDiagram
                                                ? "${(tradeDetailPageController.yesBaseProbability * 100).toStringAsFixed(0)}%"
                                                : "${(tradeDetailPageController.noBaseProbability * 100).toStringAsFixed(0)}%",
                                            style: TextStyle(
                                                color: Color(0xFF5596FF),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                        if (tradeDetailPageController
                                            .isYesDiagram)
                                          SizedBox(
                                              child: tradeDetailPageController
                                                      .deltaYesProbability
                                                      .isNegative
                                                  ? Icon(
                                                      Icons.arrow_downward,
                                                      color: Colors.green,
                                                      size: 16,
                                                    )
                                                  : Icon(
                                                      Icons.arrow_upward,
                                                      color: Colors.red,
                                                      size: 16,
                                                      
                                                    )),
                                        if (!tradeDetailPageController
                                            .isYesDiagram)
                                          SizedBox(
                                              child: tradeDetailPageController
                                                      .deltaNoProbability
                                                      .isNegative
                                                  ? Icon(
                                                      Icons.arrow_downward,
                                                      color: Colors.green,
                                                      size: 16,
                                                    )
                                                  : Icon(
                                                      Icons.arrow_upward,
                                                      color: Colors.red,
                                                      size: 16,
                                                    )),
                                        SizedBox(
                                          child: tradeDetailPageController
                                                  .isYesDiagram
                                              ? Text(
                                                  "${(tradeDetailPageController.deltaYesProbability.abs() * 100).toStringAsFixed(0)}%",
                                                  style: TextStyle(
                                                      color: tradeDetailPageController
                                                              .deltaYesProbability
                                                              .isNegative
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              : Text(
                                                  "${(tradeDetailPageController.deltaNoProbability.abs() * 100).toStringAsFixed(0)}%",
                                                  style: TextStyle(
                                                      color: tradeDetailPageController
                                                              .deltaNoProbability
                                                              .isNegative
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                        )
                                      ],
                                    ),
                                  ]),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                  height: 270,
                                  width: 360,
                                  child: SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 340,
                                          height: 270,
                                          // padding: const EdgeInsets.all(10.0),
                                          alignment: Alignment.center,
                                          child: tradeDetailPageController
                                                  .diagramDataLoading
                                              ? CircularProgressIndicator(
                                                  color: Colors.grey,
                                                )
                                              : tradeDetailPageController
                                                      .isYesDiagram
                                                  ? YesNoDiagram(
                                                      transactionData:
                                                          tradeDetailPageController
                                                              .yesTransactions,
                                                      baseProbability:
                                                          tradeDetailPageController
                                                              .yesBaseProbability,
                                                    )
                                                  : YesNoDiagram(
                                                      transactionData:
                                                          tradeDetailPageController
                                                              .noTransactions,
                                                      baseProbability:
                                                          tradeDetailPageController
                                                              .noBaseProbability,
                                                    ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Order Book",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                            width: 340,
                                            height: 313,
                                            child: tradeDetailPageController
                                                    .orderBookDataLoading
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : tradeDetailPageController
                                                        .orderBookLoadingError
                                                    ? Text(
                                                        "Order Book Load Failed",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 16))
                                                    : YesNoOrderBook(
                                                        tradeDetailPageController:
                                                            tradeDetailPageController))
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Buy Sell position and Price Amount input
                      if (tradeDetailPageController.eventDetail.marketState ==
                              MarketState.active ||
                          tradeDetailPageController.eventDetail.marketState ==
                              MarketState.preorder)
                        Container(
                            width: 370,
                            height: 350,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                gradient: LinearGradient(
                                  colors: [Colors.white, Color(0xFFFFE797)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0, 0.9],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: const Offset(4, 4),
                                  ),
                                ]),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Buy Sell position button
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child:
                                              CupertinoSlidingSegmentedControl(
                                            children: {
                                              0: Text("Buy"),
                                              1: Text("Sell"),
                                            },
                                            groupValue:
                                                tradeDetailPageController
                                                    .slidingPosition,
                                            onValueChanged: (int? newValue) {
                                              tradeDetailPageController
                                                  .switchPosition(newValue!);
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child:
                                              CupertinoSlidingSegmentedControl(
                                                  groupValue:
                                                      tradeDetailPageController
                                                          .slidingYesNoOutcome,
                                                  children: {
                                                    0: Text("Yes"),
                                                    1: Text("No")
                                                  },
                                                  onValueChanged: (newValue) {
                                                    tradeDetailPageController
                                                        .switchYesNoOutcome(
                                                            newValue);
                                                  }),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Amount user input side
                                        SizedBox(
                                          height: 110,
                                          width: 160,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Amount",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2.0,
                                              ),
                                              Container(
                                                  height: 50,
                                                  width: 124,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.25),
                                                        ),
                                                        BoxShadow(
                                                          color: Colors.white,
                                                          spreadRadius: -1.0,
                                                          blurRadius: 3.0,
                                                        )
                                                      ]),
                                                  child: TextField(
                                                    controller:
                                                        tradeDetailPageController
                                                            .amountTextController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                    onTapOutside: (event) =>
                                                        FocusScope.of(context)
                                                            .unfocus(),
                                                    onChanged: (value) =>
                                                        tradeDetailPageController
                                                            .amountTextControllerOnChange(
                                                                value),
                                                  )),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      width: 34,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              backgroundColor:
                                                                  Color(0xFF77ABFF)
                                                                      .withOpacity(
                                                                          0.8),
                                                              shadowColor:
                                                                  Colors.black,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          10.0))),
                                                          onPressed: () =>
                                                              tradeDetailPageController
                                                                  .increAmount(
                                                                      1),
                                                          child: Text(
                                                            "+1",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ))),
                                                  SizedBox(
                                                      width: 34,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              backgroundColor:
                                                                  Color(0xFF5596FF)
                                                                      .withOpacity(
                                                                          0.8),
                                                              shadowColor:
                                                                  Colors.black,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          10.0))),
                                                          onPressed: () =>
                                                              tradeDetailPageController
                                                                  .increAmount(
                                                                      5),
                                                          child: Text(
                                                            "+5",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ))),
                                                  SizedBox(
                                                      width: 34,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              padding: EdgeInsets
                                                                  .zero,
                                                              backgroundColor:
                                                                  Color(0xFF3B86FF)
                                                                      .withOpacity(
                                                                          0.8),
                                                              shadowColor:
                                                                  Colors.black,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0))),
                                                          onPressed: () =>
                                                              tradeDetailPageController
                                                                  .increAmount(
                                                                      10),
                                                          child: Text(
                                                            "+10",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ))),
                                                  SizedBox(
                                                      width: 34,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              padding: EdgeInsets
                                                                  .zero,
                                                              backgroundColor:
                                                                  Color(0xFF2679FF)
                                                                      .withOpacity(
                                                                          0.8),
                                                              shadowColor:
                                                                  Colors.black,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0))),
                                                          onPressed: () =>
                                                              tradeDetailPageController
                                                                  .increAmount(
                                                                      50),
                                                          child: Text(
                                                            "+50",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Price user input side
                                        SizedBox(
                                          height: 110,
                                          width: 160,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Price",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                  height: 50,
                                                  width: 124,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.25),
                                                        ),
                                                        BoxShadow(
                                                          color: Colors.white,
                                                          spreadRadius: -1.0,
                                                          blurRadius: 3.0,
                                                        )
                                                      ]),
                                                  child: TextField(
                                                    enabled:
                                                        tradeDetailPageController
                                                                .eventDetail
                                                                .marketState ==
                                                            MarketState.active,
                                                    controller:
                                                        tradeDetailPageController
                                                            .priceTextController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                    onTapOutside: (event) =>
                                                        FocusScope.of(context)
                                                            .unfocus(),
                                                    onChanged: tradeDetailPageController
                                                                .eventDetail
                                                                .marketState ==
                                                            MarketState.active
                                                        ? (value) =>
                                                            tradeDetailPageController
                                                                .priceTextControllerOnChange(
                                                                    value)
                                                        : (value) {},
                                                  )),
                                              Expanded(
                                                  child: Slider(
                                                      value:
                                                          tradeDetailPageController
                                                              .price,
                                                      min:
                                                          tradeDetailPageController
                                                              .minPrice,
                                                      max:
                                                          tradeDetailPageController
                                                              .maxPrice,
                                                      onChanged: tradeDetailPageController
                                                                  .eventDetail
                                                                  .marketState ==
                                                              MarketState.active
                                                          ? (value) =>
                                                              tradeDetailPageController
                                                                  .priceTextControllerOnChange(
                                                                      value
                                                                          .toString())
                                                          : (value) {})),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),

                                    Divider(
                                      color: Color(0xFF2C76EE).withOpacity(0.8),
                                      thickness: 2.0,
                                    ),

                                    SizedBox(
                                      height: 80,
                                      width: 340,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Total Cost",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const SizedBox(
                                                width: 5.0,
                                              ),
                                              Tooltip(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.25),
                                                        spreadRadius: 0,
                                                        blurRadius: 4,
                                                        offset:
                                                            const Offset(4, 4),
                                                      ),
                                                    ]),
                                                message:
                                                    "Total Cost: \n${tradeDetailPageController.amount} (amount) * \n${tradeDetailPageController.price} (price) * \n${tradeDetailPageController.fee + 1} (fee) \n= ${tradeDetailPageController.totalCost.toStringAsFixed(2)}",
                                                textStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                child: Icon(Icons.info_outline,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 52,
                                                width: 80,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "amount ${tradeDetailPageController.amount}",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Text(
                                                      "price ${tradeDetailPageController.price}",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Text(
                                                        "fee ${tradeDetailPageController.fee}",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF666666),
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 46,
                                                width: 217,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.25),
                                                      ),
                                                      BoxShadow(
                                                        color: Colors.white,
                                                        spreadRadius: -1.0,
                                                        blurRadius: 5.0,
                                                      )
                                                    ]),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      "${tradeDetailPageController.totalCost.toStringAsFixed(2)}  𝟊",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 24,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5.0),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),

                                    Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        height: 40,
                                        width: 200,
                                        child: ElevatedButton(
                                            onPressed: tradeDetailPageController
                                                .purchaseRequestSent,
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFF2C76EE)
                                                        .withOpacity(0.8),
                                                shadowColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0))),
                                            child: Text(
                                              tradeDetailPageController
                                                      .isBuyingPosition
                                                  ? "Purchase"
                                                  : "Sell",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                                if (tradeDetailPageController
                                    .purchaseRequestSending)
                                  Positioned(
                                      height: 345,
                                      width: 340,
                                      child: Container(
                                        width: 340,
                                        height: 350,
                                        color: Colors.grey.withOpacity(0.4),
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(),
                                      ))
                              ],
                            )),
                      // Event result outcome claim reward
                      if (tradeDetailPageController.eventDetail.marketState ==
                          MarketState.resolved)
                        Container(
                          width: 370,
                          height: 350,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              gradient: LinearGradient(
                                colors: [Colors.white, Color(0xFFFFE797)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0, 0.9],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(4, 4),
                                ),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 370,
                                height: 44,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      left: 10,
                                      child: Tooltip(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                spreadRadius: 0,
                                                blurRadius: 4,
                                                offset: const Offset(4, 4),
                                              ),
                                            ]),
                                        message:
                                            "Winner side can change 1 yes/no token\nto 1 funtury token",
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        child: Icon(Icons.info_outline,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Text(
                                      "Market was ended",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Text("Outcomes:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                              // Yes or No side win
                              Expanded(
                                child: Center(
                                    child: Text(
                                  tradeDetailPageController
                                          .eventDetail.resolvedToYes
                                      ? "YES"
                                      : "NO",
                                  style: TextStyle(
                                      color: tradeDetailPageController
                                              .eventDetail.resolvedToYes
                                          ? Color(0xFF3CEE2C).withOpacity(0.7)
                                          : Color(0xFFEE2C2C).withOpacity(0.7),
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF2BFF00),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text("Yes",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          " ${tradeDetailPageController.userYesPosition}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFEE2C2C),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text("No",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          " ${tradeDetailPageController.userNoPosition}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 20.0,
                              ),
                              // Claim reward button

                              Container(
                                height: 40,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                      ),
                                    ]),
                                child: ElevatedButton(
                                    onPressed:
                                        tradeDetailPageController.rewardClaiming
                                            ? () {}
                                            : tradeDetailPageController
                                                .claimedReward,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color(0xFF2C76EE).withOpacity(0.8),
                                        shadowColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0))),
                                    child: tradeDetailPageController
                                            .rewardClaiming
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            "Claim Reward",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                              ),
                            ],
                          ),
                        ),
                    ]
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class YesNoDiagram extends StatelessWidget {
  const YesNoDiagram(
      {super.key, required this.transactionData, this.baseProbability = 0.5});

  final List<YesNoTransaction> transactionData;
  final timeInterval = 86400000; // 1 day in millie seconds
  final double baseProbability;

  @override
  Widget build(BuildContext context) {
    // double _minx =
    //     DateTime.parse(transactionData.first.timestamp.toString().split(' ')[0])
    //         .millisecondsSinceEpoch
    //         .toDouble();
    // double _maxx = DateTime.parse(DateTime.now().toString().split(' ')[0])
    //     .millisecondsSinceEpoch
    //     .toDouble();
    // if (_minx == _maxx) {
    //   _maxx = _minx + timeInterval.toDouble();
    // }

    double _minx;
    double _maxx;
    if (transactionData.isEmpty) {
      _minx = DateTime.now().millisecondsSinceEpoch.toDouble();
      _maxx = DateTime.now().millisecondsSinceEpoch.toDouble();
    } else {
      _minx = transactionData.first.timestamp.millisecondsSinceEpoch.toDouble();
      _maxx = transactionData.last.timestamp.millisecondsSinceEpoch.toDouble();
    }

    Map<int, YesNoTransaction> transactionMap = {};
    for (int i = 0; i < transactionData.length; i++) {
      transactionMap[transactionData[i].timestamp.millisecondsSinceEpoch] =
          transactionData[i];
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: 0.1,
          verticalInterval: 1.0,
          // verticalInterval: timeInterval.toDouble(),
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Color(0xFF2C76EE).withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              minIncluded: false,
              maxIncluded: false,
              interval: timeInterval.toDouble(),
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return SideTitleWidget(
                  space: 4.0,
                  meta: meta,
                  child: Text(
                    "${date.year}/${date.month}/${date.day}",
                    style: TextStyle(
                      color: Color(0xFF2C76EE).withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 28,
              showTitles: true,
              maxIncluded: false,
              interval: 0.1,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  space: 4.0,
                  meta: meta,
                  child: Text(
                    "${(value * 100).toStringAsFixed(0)}%",
                    style: TextStyle(
                      color: Color(0xFF2C76EE).withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.black26, width: 1),
            left: BorderSide(color: Colors.black26, width: 1),
            right: BorderSide(color: Colors.transparent),
            top: BorderSide(color: Colors.transparent),
          ),
        ),
        minX: _minx,
        maxX: _maxx,
        // minX: 0,
        // maxX: transactionData.length.toDouble() - 1,
        minY: 0,
        maxY: 1.0,
        clipData: FlClipData.all(),
        lineBarsData: [
          LineChartBarData(
            spots: _createSpots(),
            isCurved: false,
            color: Color(0xFF2C76EE).withOpacity(0.8),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 2,
                  color: Colors.blue,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                );
              },
            ),
            aboveBarData: BarAreaData(
              show: true,
              cutOffY: baseProbability,
              applyCutOffY: true,
              color: Colors.green.withOpacity(0.5),
            ),
            belowBarData: BarAreaData(
              show: true,
              cutOffY: baseProbability,
              applyCutOffY: true,
              color: Colors.red.withOpacity(0.5),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final millesecond = spot.x.toInt();
                if (transactionMap[millesecond] != null) {
                  final transaction = transactionMap[millesecond]!;
                  return LineTooltipItem(
                    '${transaction.timestamp.year}-${transaction.timestamp.month}-${transaction.timestamp.day}\n${transaction.timestamp.hour}:${transaction.timestamp.minute}:${transaction.timestamp.second}\n',
                    const TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text:
                            'price: ${transaction.perPrice.toStringAsFixed(2)}\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "amount: "
                            "${transaction.amount}\n",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "totalCost: "
                            "${transaction.totalCost}\n",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  List<FlSpot> _createSpots() {
    return List.generate(
      transactionData.length,
      (index) => FlSpot(
          transactionData[index].timestamp.millisecondsSinceEpoch.toDouble(),
          transactionData[index].perPrice),
      // (index) => FlSpot(index.toDouble(), transactionData[index].perPrice),
    );
  }
}

class YesNoOrderBook extends StatelessWidget {
  const YesNoOrderBook({super.key, required this.tradeDetailPageController});

  final TradeDetailPageController tradeDetailPageController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Yes/No topic
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 124,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color(0xFF5596FF).withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(4, 4),
                      ),
                    ]),
                child: Text(
                  "Yes",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.bottomCenter,
                height: 40,
                child: Text(
                  "Sell",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 124,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color(0xFF5596FF).withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(4, 4),
                      ),
                    ]),
                child: Text(
                  "No",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Price(𝟊)",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                    Expanded(
                        child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Amount",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    )),
                  ],
                ),
              ),
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Price(𝟊)",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Amount",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  )),
                ],
              )),
            ],
          ),
          // Sell part
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Yes sell
              Expanded(
                child: Container(
                    width: 160,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    child: SingleChildScrollView(
                      reverse: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          for (var order in tradeDetailPageController
                              .orderBook.sellYesList) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.only(left: 5.0),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.black26,
                                                width: 1.0),
                                            right: BorderSide(
                                                color: Colors.black26,
                                                width: 0.5))),
                                    child: Text(
                                      "${order.key.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.only(right: 5.0),
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.black26,
                                                width: 1.0),
                                            left: BorderSide(
                                                color: Colors.black26,
                                                width: 0.5))),
                                    child: Text(
                                      order.value.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]
                        ],
                      ),
                    )),
              ),
              // No sell
              Expanded(
                  child: Container(
                width: 160,
                height: 100,
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(color: Colors.black, width: 1),
                )),
                child: SingleChildScrollView(
                    reverse: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        for (var order in tradeDetailPageController
                            .orderBook.sellNoList) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 30,
                                  padding: const EdgeInsets.only(left: 5.0),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.black26,
                                              width: 1.0),
                                          right: BorderSide(
                                              color: Colors.black26,
                                              width: 0.5))),
                                  child: Text(
                                    "${order.key.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 30,
                                  padding: const EdgeInsets.only(right: 5.0),
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.black26,
                                              width: 1.0),
                                          left: BorderSide(
                                              color: Colors.black26,
                                              width: 0.5))),
                                  child: Text(
                                    order.value.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]
                      ],
                    )),
              )),
            ],
          ),
          Divider(
            color: Colors.black,
            thickness: 2.0,
            height: 2.0,
          ),
          // Buy part
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Yes buy
              Expanded(
                child: Container(
                    width: 160,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          for (var order in tradeDetailPageController
                              .orderBook.buyYesList) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.only(left: 5.0),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black26,
                                                width: 1.0),
                                            right: BorderSide(
                                                color: Colors.black26,
                                                width: 0.5))),
                                    child: Text(
                                      "${order.key.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.only(right: 5.0),
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black26,
                                                width: 1.0),
                                            left: BorderSide(
                                                color: Colors.black26,
                                                width: 0.5))),
                                    child: Text(
                                      order.value.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]
                        ],
                      ),
                    )),
              ),
              // No buy
              Expanded(
                child: Container(
                    width: 160,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          for (var order in tradeDetailPageController
                              .orderBook.buyNoList) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.only(left: 5.0),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black26,
                                                width: 1.0),
                                            right: BorderSide(
                                                color: Colors.black26,
                                                width: 0.5))),
                                    child: Text(
                                      "${order.key.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.only(right: 5.0),
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black26,
                                                width: 1.0),
                                            left: BorderSide(
                                                color: Colors.black26,
                                                width: 0.5))),
                                    child: Text(
                                      order.value.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]
                        ],
                      ),
                    )),
              ),
            ],
          ),

          Text(
            "Buy",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
