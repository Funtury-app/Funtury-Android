import 'package:funtury/Data/user_transfer_record.dart';
import 'package:web3dart/credentials.dart';

class Order {
  final EthereumAddress userAddress;
  final EthereumAddress marketAddress;
  final Outcome outcome;
  final double price;
  final int amount;
  final Side side;

  Order({
    required this.userAddress,
    required this.marketAddress,
    required this.outcome,
    required this.price,
    required this.amount,
    required this.side,
  });

  Map<String, dynamic> get toJson{
    return {
      "user_address": userAddress.hexEip55,
      "market_address": marketAddress.hexEip55,
      "outcome": outcome.outcome,
      "price": price,
      "amount": amount,
      "side": side.side,
    };
  }
}