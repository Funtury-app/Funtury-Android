import 'package:funtury/Data/user_transfer_record.dart';
import 'package:web3dart/credentials.dart';

class OrderBookOrder{
  final int orderId;
  final String orderSerial;
  final EthereumAddress userAddress;
  final EthereumAddress marketAddress;
  final Outcome outcome;
  final double price;
  final int amount;
  final Side side;
  final MarketState state;
  final DateTime createTime;

  OrderBookOrder({
    required this.orderId,
    required this.orderSerial,
    required this.userAddress,
    required this.marketAddress,
    required this.outcome,
    required this.price,
    required this.amount,
    required this.side,
    required this.state,
    required this.createTime,
  });

  factory OrderBookOrder.fromData(Map<String, dynamic> data) {
    return OrderBookOrder(
      orderId: data["id"] as int,
      orderSerial: data["order_serial"] as String,
      userAddress: EthereumAddress.fromHex(data["user_address"] as String),
      marketAddress: EthereumAddress.fromHex(data["market_address"] as String),
      outcome: Outcome.fromString(data["outcome"] as String),
      price: (data["price"] as num).toDouble(),
      amount: data["amount"] as int,
      side: Side.fromString(data["side"] as String),
      state: MarketState.fromString(data["state"] as String),
      createTime: DateTime.parse('${data["created_at"] as String}Z').toLocal(),
    );
  }
}

enum MarketState{
  active(state: "Active"),
  preorder(state: "Preorder"),
  resolved(state: "Resolved"),
  cancelled(state: "Cancelled");

  final String state;
  const MarketState({required this.state});

  factory MarketState.fromString(String state) {
    switch (state) {
      case "Active":
        return MarketState.active;
      case "Preorder":
        return MarketState.preorder;
      case "Resolved":
        return MarketState.resolved;
      case "Cancelled":
        return MarketState.cancelled;
      default:
        throw ArgumentError("Unknown market state: $state");
    }
  }
}