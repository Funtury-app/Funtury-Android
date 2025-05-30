import 'package:funtury/Service/Path/http_protocol.dart';

enum UserPath implements HttpPath{
  getUserTransactions(path: "user/%0/transactions"); // %0 => userAddress

  @override
  String get getPath => path;
  
  final String path;

  const UserPath({
    required this.path,
  });
}
