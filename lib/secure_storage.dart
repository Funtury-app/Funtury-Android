import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{
  static const storage = FlutterSecureStorage();

  static store(StoreKey key, String value) async{
    storage.write(key: key.key, value: value);
  }

  static Future<String?> read(StoreKey key) async {
    return await storage.read(key: key.key);
  }

  static delete(StoreKey key) async {
    await storage.delete(key: key.key);
  }
}

enum StoreKey{
  userPrivateKey(key: "USER_PRIVATE_KEY"),
  userWalletAddress(key: "USER_WALLET_ADDRESS");

  final String key;
  const StoreKey({required this.key});
}