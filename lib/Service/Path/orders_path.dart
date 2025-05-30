import 'package:funtury/Service/Path/http_protocol.dart';

enum OrdersPath implements HttpPath{
  create(path: "orders/"),
  cancel(path: "orders/%0/cancel"), // %0 => orderId
  orderbook(path: "orders/%0/%1"); // %0 => marketAddress, %1 => outcome

  @override
  String get getPath => path;

  final String path;
  const OrdersPath({
    required this.path,
  });
}