import 'package:web3dart/credentials.dart';

class UserTransferRecord {
  final int orderId;
  final String orderSerial;
  final EthereumAddress userAddress;
  final EthereumAddress marketAddress;
  final Outcome outcome;
  final Side side;
  final int dealAmount;
  final int remainingAmount;
  final double price;
  late OrderStatus status;
  final DateTime createTime;
  final DateTime? dealtTime;

  UserTransferRecord({
    required this.orderId,
    required this.orderSerial,
    required this.userAddress,
    required this.marketAddress,
    required this.outcome,
    required this.side,
    required this.dealAmount,
    required this.remainingAmount,
    required this.price,
    required this.status,
    required this.createTime,
    this.dealtTime,
  });

  factory UserTransferRecord.fromData(Map<String, dynamic> data) {
    return UserTransferRecord(
        orderId: data["id"] as int,
        orderSerial: data["order_serial"] as String,
        userAddress: EthereumAddress.fromHex(data["user_address"] as String),
        marketAddress:
            EthereumAddress.fromHex(data["market_address"] as String),
        outcome: Outcome.fromString(data["outcome"] as String),
        side: Side.fromString(data["side"] as String),
        dealAmount: data["deal_amount"] as int,
        remainingAmount: data["remaining_amount"] as int,
        price: data["price"] as double,
        status: OrderStatus.fromString(data["status"] as String),
        createTime: DateTime.parse('${data["created_at"] as String}Z').toLocal(),
        dealtTime: data["dealt_at"] != null
            ? DateTime.parse('${data["dealt_at"] as String}Z').toLocal()
            : null);
  }
}

enum Outcome {
  yes(outcome: "yes"),
  no(outcome: "no");

  final String outcome;
  const Outcome({required this.outcome});

  factory Outcome.fromString(String outcome) {
    switch (outcome) {
      case "yes":
        return Outcome.yes;
      case "no":
        return Outcome.no;
      default:
        throw ArgumentError("Invalid outcome: $outcome");
    }
  }
}

enum Side {
  buy(side: "buy"),
  sell(side: "sell");

  final String side;
  const Side({required this.side});

  factory Side.fromString(String side) {
    switch (side) {
      case "buy":
        return Side.buy;
      case "sell":
        return Side.sell;
      default:
        throw ArgumentError("Invalid side: $side");
    }
  }
}

enum OrderStatus {
  open(status: "open"), // No deal
  partilallyDealt(status: "partially_dealt"), // Partially dealt
  dealt(status: "dealt"), // Fully dealt
  cancelled(status: "cancelled"); // Cancelled

  final String status;
  const OrderStatus({required this.status});

  factory OrderStatus.fromString(String status) {
    switch (status) {
      case "open":
        return OrderStatus.open;
      case "partially_dealt":
        return OrderStatus.partilallyDealt;
      case "dealt":
        return OrderStatus.dealt;
      case "cancelled":
        return OrderStatus.cancelled;
      default:
        throw ArgumentError("Invalid order status: $status");
    }
  }
}
