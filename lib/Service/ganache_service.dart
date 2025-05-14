// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:funtury/Service/Contract/Funtury_contract.dart';
import 'package:funtury/Service/Contract/prediction_market_contract.dart';
// import 'package:funtury/Service/Contract/contract_abi_json.dart';
// import 'package:funtury/Service/Contract/contract_address.dart';
import 'package:http/http.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';
// import 'package:reown_appkit/solana/solana_common/src/converters/hex_codec.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:bip32/bip32.dart' as bip32;
// import 'package:bip39/bip39.dart' as bip39;

class GanacheService {
  static const String _rpcUrl =
      "https://d241-2001-b400-e3ac-4100-d81d-deea-7056-80bb.ngrok-free.app";
  static final EthPrivateKey _privateKey = EthPrivateKey.fromHex(
      "0xd1659c1e6db804d140b9767226bb9d371fb7b062e64251bfe654b2a0628b9e3f");
  static final EthereumAddress userAddress =
      EthereumAddress.fromHex("0x6B21C392F5aAD239f253aB4ed4a65d62fbbEEa99");

  late Client httpClient;
  late Web3Client ganacheClient;

  GanacheService() {
    httpClient = Client();
    ganacheClient = Web3Client(_rpcUrl, Client());
  }

  // Future<void> transferTo(
  //     EthereumAddress sender, EthereumAddress to, BigInt value) async {
  //   value = value * BigInt.from(10).pow(18);
  //   try {
  //     final tx = await ganacheClient.signTransaction(
  //         _privateKey,
  //         Transaction(
  //           from: _privateKey.address,
  //           gasPrice: EtherAmount.inWei(BigInt.from(20000000000)),
  //           maxGas: 100000,
  //           value: EtherAmount.zero(),
  //           to: _contract.address,
  //           data: _transferTo.encodeCall([to, value]),
  //         ),
  //         chainId: 1337);

  //     final result = await ganacheClient.sendRawTransaction(tx);
  //     debugPrint("GanacheService transferTo result: $result");
  //   } catch (e) {
  //     debugPrint("GanacheService transferTo error: $e");
  //   }

  //   return;
  // }

  /// Funtury contract transfer function ///

  Future<double> getBalance() async {
    try {
      final result = await ganacheClient.call(
          contract: FunturyContract.funturyContract,
          function: FunturyContract.getBalance,
          params: [userAddress]);
      final balance = (result[0] as BigInt) / BigInt.from(10).pow(18);
      debugPrint("GanacheService getBalance result: $balance");
      return balance.toDouble();
    } catch (e) {
      debugPrint("GanacheService getBalance error: $e");
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> queryAllMarkets() async {
    List<Map<String, dynamic>> data = [];

    try {
      final filter = FilterOptions(
        address: FunturyContract.contractAddress,
        topics: [
          [
            bytesToHex(FunturyContract.marketCreated.signature, include0x: true)
          ],
        ],
        fromBlock: const BlockNum.genesis(),
        toBlock: const BlockNum.current(),
      );

      final logs = await ganacheClient.getLogs(filter);

      for (var log in logs) {
        final decodedLog = MarketCreatedEvent.fromEventLog(log);

        data.add(
          {
            "title": decodedLog.title,
            "createTime": decodedLog.createTime,
            "preOrderTime": decodedLog.preOrderTime,
            "resolutionTime": decodedLog.resolutionTime,
            "marketContract": decodedLog.marketContract,
            "yesProbability": 0.5,
            "noProbability": 0.5,
          },
        );

        debugPrint(decodedLog.toString());
      }
    } catch (e) {
      debugPrint("GanacheService queryAllMarket error: $e");
    }
    return data;
  }

  Future<List<EthereumAddress>> getAllMarkets() async {
    try {
      final result = await ganacheClient.call(
          contract: FunturyContract.funturyContract,
          function: FunturyContract.getAllMarkets,
          params: []);
      final markets = List<EthereumAddress>.from(result[0] as List);
      debugPrint("GanacheService getAllMarkets result: $markets");
      return markets;
    } catch (e) {
      debugPrint("GanacheService getAllMarkets error: $e");
      return [];
    }
  }

  Future<void> claimedFreeToken() async {
    try {
      final tx = await ganacheClient.signTransaction(
          _privateKey,
          Transaction(
            from: _privateKey.address,
            gasPrice: EtherAmount.inWei(BigInt.from(20000000000)),
            maxGas: 100000,
            value: EtherAmount.zero(),
            to: FunturyContract.contractAddress,
            data: FunturyContract.claimFreeTokens.encodeCall([]),
          ),
          chainId: 1337);

      final result = await ganacheClient.sendRawTransaction(tx);
      debugPrint("GanacheService transferTo result: $result");
    } catch (e) {
      debugPrint("GanacheService transferTo error: $e");
    }
  }

  Future<bool> checkFreeTokenClaimed() async {
    try {
      final result = await ganacheClient.call(
          contract: FunturyContract.funturyContract,
          function: FunturyContract.hasClaimedFreeTokens,
          params: [userAddress]);
      debugPrint("GanacheService checkFreeTokenClaimed result: $result");
      return result[0];
    } catch (e) {
      debugPrint("GanacheService checkFreeTokenClaimed error: $e");
      return false;
    }
  }

  /// Funtury contract transfer function ///

  /// Prediction contract transfer function ///

  Future<(double, double)> getUserPosition(
      EthereumAddress marketAddress) async {
    PredictionMarketContract predictionMarketContract =
        PredictionMarketContract(contractAddress: marketAddress);

    try {
      final result = await ganacheClient.call(
          contract: predictionMarketContract.contract,
          function: predictionMarketContract.getUserShares(),
          params: [userAddress]);
      debugPrint("GanacheService getUserPosition result: $result");

      return (
        (result[0] as BigInt).toDouble(),
        (result[1] as BigInt).toDouble()
      );
    } catch (e) {
      debugPrint("GanacheService getUserPosition error: $e");
      return (0.0, 0.0);
    }
  }

  Future<Map<String, dynamic>?> getMarketInfo(
      EthereumAddress marketAddress) async {
    PredictionMarketContract predictionMarketContract =
        PredictionMarketContract(contractAddress: marketAddress);

    Map<String, dynamic>? data;

    try {
      final result = await ganacheClient.call(
          contract: predictionMarketContract.contract,
          function: predictionMarketContract.getMarketInfo(),
          params: []);

      data = {
        "title": result[0] as String,
        "createTime": result[1] as BigInt,
        "resolutionTime": result[2] as BigInt,
        "preOrderTime": result[3] as BigInt,
        "funturyContract": result[4] as EthereumAddress,
        "owner": result[5] as EthereumAddress,
        "marketState": (result[6] as BigInt).toInt(),
        "resolvedToYes": result[7] as bool,
        "remainYesShares": result[8] as BigInt,
        "remainNoShares": result[9] as BigInt,
        "initialPrice": result[10] as BigInt,
      };
      debugPrint("GanacheService getMarketInfo result: $data");
    } catch (e) {
      debugPrint("GanacheService getMarketInfo error: $e");
    }

    return data;
  }

  Future<(bool, String)> preorderPurchase(EthereumAddress marketAddress,
      bool isYes, double price, int amount) async {
    try {
      final userBalance = await getBalance();
      if (userBalance < amount * price) {
        debugPrint(
            "GanacheService preorderPurchase error: Insufficient balance");
        return (false, "Insufficient balance");
      }
    } catch (e) {
      debugPrint("GanacheService preorderPurchase error: $e");
      return (false, "Error checking balance");
    }

    PredictionMarketContract predictionMarketContract =
        PredictionMarketContract(contractAddress: marketAddress);

    try {
      final tx = await ganacheClient.signTransaction(
          _privateKey,
          Transaction(
            from: _privateKey.address,
            gasPrice: EtherAmount.inWei(BigInt.from(20000000000)),
            maxGas: 100000,
            value: EtherAmount.zero(),
            to: marketAddress,
            data: predictionMarketContract.preOrderTransfer().encodeCall([
              userAddress,
              isYes,
              BigInt.from(price * 1e18),
              BigInt.from(amount)
            ]),
          ),
          chainId: 1337);
      await ganacheClient.sendRawTransaction(tx);
      return (true, "Preorder purchase success");
    } catch (e) {
      debugPrint("GanacheService preorderPurchase error: $e");
      return (false, "Preorder purchase failed");
    }
  }

  Future<(bool, String)> claimRewardFromMarketRequest(EthereumAddress marketAddress) async{
    PredictionMarketContract predictionMarketContract =
        PredictionMarketContract(contractAddress: marketAddress);

    try {
      final tx = await ganacheClient.signTransaction(
          _privateKey,
          Transaction(
            from: _privateKey.address,
            gasPrice: EtherAmount.inWei(BigInt.from(20000000000)),
            maxGas: 100000,
            value: EtherAmount.zero(),
            to: marketAddress,
            data: predictionMarketContract.claimReward().encodeCall([]),
          ),
          chainId: 1337);
      await ganacheClient.sendRawTransaction(tx);
      return (true, "Claim reward success");
    } catch (e) {
      if(e.runtimeType == RPCError){
        e as RPCError;
        if(e.data["reason"] == "Already claimed reward"){
          return (false, "Already claimed reward");
        }
      }

      debugPrint("GanacheService claimRewardFromMarketRequest error: $e");
      
      return (false, "Claim reward failed");
    }
  }
  /// Prediction contract transfer function ///
}

  // Future<void> getPrivateKey() async {
  //   try {
  //     final sp = await SharedPreferences.getInstance();
  //     final mnemonic = sp.getString("mnemonic") ?? bip39.generateMnemonic();
  //     if (!sp.containsKey('mnemonic')) {
  //       await sp.setString('mnemonic', mnemonic);
  //     }
  //     final seed = bip39.mnemonicToSeed(mnemonic);
  //     final wallet = bip32.BIP32.fromSeed(seed);
  //     final pathWallet = wallet.derivePath("m/44'/60'/0'/0");
  //     _privateKey = EthPrivateKey.fromHex(hexEncode(pathWallet.privateKey!));
  //     debugPrint("GanacheService getPrivateKey result: $_privateKey");
  //   } catch (e) {
  //     debugPrint("GanacheService getPrivateKey error: $e");
  //   }
  //   return;
  // }

  // btcWallet = hdWallet.derivePath("m/44'/0'/0'/0/0");
  // ethWallet = hdWallet.derivePath("m/44'/60'/0'/0/0");
  // tronWallet = hdWallet.derivePath("m/44'/195'/0'/0/0");
  // solanaWallet = hdWallet.derivePath("m/44'/501'/0'/0/0");
  // bnbWallet = hdWallet.derivePath("m/44'/714'/0'/0/0");
  // dogeWallet = hdWallet.derivePath("m/44'/3'/0'/0/0");
  // avaxWallet = hdWallet.derivePath("m/44'/60'/0'/0/0");
  // aptosWallet = hdWallet.derivePath("m/44'/637'/0'/0/0");
  // nearWallet = hdWallet.derivePath("m/44'/397'/0'/0/0");
  // solanaWallet = hdWallet.derivePath("m/44'/501'/0'/0/0");
  // zilliqaWallet = hdWallet.derivePath("m/44'/313'/0'/0/0");
  // algorandWallet = hdWallet.derivePath("m/44'/283'/0'/0/0");