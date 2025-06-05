// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:funtury/Service/Contract/funtury_contract.dart';
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
      "https://6205-2001-b400-e179-f49e-c9-72db-e762-95ec.ngrok-free.app";
  static EthPrivateKey _privateKey = EthPrivateKey.fromHex(
      "0xbda582304ad6b97f303cebc9cef6ebc02c2055413058de5031745da72dc68cdf");
  static EthereumAddress userAddress =
      EthereumAddress.fromHex("0x75D7B871b54483825EBba67aFB54bC7eFAF48944");

  static final EthereumAddress ethereumBankAddress = EthereumAddress.fromHex("0x39a5162c0785a8BC05F0a3d925d5BE42db7FB6d1");
  static final EthPrivateKey ethereumBankKey = EthPrivateKey.fromHex("0xcd5db108631112123d965086b73ccaa2c361d668bf175866994fec97d62231a8");

  late Client httpClient;
  late Web3Client ganacheClient;

  GanacheService() {
    httpClient = Client();
    ganacheClient = Web3Client(_rpcUrl, Client());
  }

  static setPrivateKeyWalletAddress (
      EthPrivateKey privateKey, EthereumAddress walletAddress) async {
    _privateKey = privateKey;
    userAddress = walletAddress;
  
    Web3Client tempClient = Web3Client(_rpcUrl, Client());
    
    try{
      final tx = await tempClient.signTransaction(
          ethereumBankKey,
          Transaction(
            from: ethereumBankAddress,
            gasPrice: EtherAmount.inWei(BigInt.from(20000000000)),
            maxGas: 100000,
            value: EtherAmount.fromUnitAndValue(
              EtherUnit.ether, 5),
            to: userAddress,
          ),
          chainId: 1337);

      final result = await tempClient.sendRawTransaction(tx);
      debugPrint("GanacheService setPrivateKeyWalletAddress result: $result");
    } catch(e){
      debugPrint("GanacheService setPrivateKeyWalletAddress error: $e");
    }
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

  Future<double> getUserBalance(EthereumAddress user) async {
    try {
      final result = await ganacheClient.call(
          contract: FunturyContract.funturyContract,
          function: FunturyContract.getBalance,
          params: [user]);
      final balance = (result[0] as BigInt) / BigInt.from(10).pow(18);
      debugPrint("GanacheService getUserBalance result: $balance");
      return (balance.toDouble());
    } catch (e) {
      debugPrint("GanacheService getUserBalance error: $e");
      return (0.0);
    }
  }

  Future<List<Map<String, dynamic>>> queryAllMarkets() async {
    List<Map<String, dynamic>> data = [];

    try {
      final filter = FilterOptions(
        address: FunturyContract.contractAddress,
        topics: [
          [
            bytesToHex(FunturyContract.marketCreatedEvent.signature,
                include0x: true)
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
            "title": decodedLog.marketTitle,
            "createTime": decodedLog.createTime,
            "preOrderTime": decodedLog.preOrderTime,
            "resolutionTime": decodedLog.resolvedTime,
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
          function: FunturyContract.getAllMarket,
          params: []);
      final markets = List<EthereumAddress>.from(result[0] as List);
      debugPrint("GanacheService getAllMarkets result: $markets");
      return markets;
    } catch (e) {
      debugPrint("GanacheService getAllMarkets error: $e");
      return [];
    }
  }

  Future<(bool, List<EthereumAddress>)> getAllFunturyUser() async {
    List<EthereumAddress> data = [];
    try {
      final filter = FilterOptions(
        address: FunturyContract.contractAddress,
        topics: [
          [
            bytesToHex(FunturyContract.tokenClaimedEvent.signature,
                include0x: true)
          ],
        ],
        fromBlock: const BlockNum.genesis(),
        toBlock: const BlockNum.current(),
      );

      final logs = await ganacheClient.getLogs(filter);

      for (var log in logs) {
        final decodedLog = TokenClaimedEvent.fromEventLog(log);

        data.add(decodedLog.user);

        debugPrint(decodedLog.toString());
      }

      return (true, data);
    } catch (e) {
      debugPrint("GanacheService queryAllMarket error: $e");
      return (false, data);
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

  Future<(bool, String)> claimRewardFromMarketRequest(
      EthereumAddress marketAddress) async {
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
      if (e.runtimeType == RPCError) {
        e as RPCError;
        if (e.data["reason"] == "Already claimed reward") {
          return (false, "Already claimed reward");
        }
      }

      debugPrint("GanacheService claimRewardFromMarketRequest error: $e");

      return (false, "Claim reward failed");
    }
  }

  Future<(bool, List<Map<String, dynamic>>)> queryAllYesTransactionRecord(
      EthereumAddress marketAddress) async {
    PredictionMarketContract predictionMarketContract =
        PredictionMarketContract(contractAddress: marketAddress);
    List<Map<String, dynamic>> data = [];

    try {
      final filter = FilterOptions(
        address: marketAddress,
        topics: [
          [
            bytesToHex(predictionMarketContract.yesTransaction().signature,
                include0x: true)
          ],
        ],
        fromBlock: const BlockNum.genesis(),
        toBlock: const BlockNum.current(),
      );

      final logs = await ganacheClient.getLogs(filter);

      for (var log in logs) {
        final decodedLog =
            YesTransactionEvent.fromEventLog(predictionMarketContract, log);

        data.add(
          {
            "from": decodedLog.from,
            "to": decodedLog.to,
            "amount": decodedLog.amount,
            "totalCost": decodedLog.totalCost,
            "timestamp": decodedLog.timestamp,
          },
        );

        debugPrint(decodedLog.toString());
      }
    } catch (e) {
      debugPrint("GanacheService queryAllYesTransactionRecord error: $e");
      return (false, data);
    }
    return (true, data);
  }

  Future<(bool, List<Map<String, dynamic>>)> queryAllNoTransactionRecord(
      EthereumAddress marketAddress) async {
    PredictionMarketContract predictionMarketContract =
        PredictionMarketContract(contractAddress: marketAddress);
    List<Map<String, dynamic>> data = [];

    try {
      final filter = FilterOptions(
        address: marketAddress,
        topics: [
          [
            bytesToHex(predictionMarketContract.noTransaction().signature,
                include0x: true)
          ],
        ],
        fromBlock: const BlockNum.genesis(),
        toBlock: const BlockNum.current(),
      );

      final logs = await ganacheClient.getLogs(filter);

      for (var log in logs) {
        final decodedLog =
            NoTransactionEvent.fromEventLog(predictionMarketContract, log);

        data.add(
          {
            "from": decodedLog.from,
            "to": decodedLog.to,
            "amount": decodedLog.amount,
            "totalCost": decodedLog.totalCost,
            "timestamp": decodedLog.timestamp,
          },
        );

        debugPrint(decodedLog.toString());
      }
    } catch (e) {
      debugPrint("GanacheService queryAllNoTransactionRecord error: $e");
      return (false, data);
    }
    return (true, data);
  }

  Future<(bool, Map<String, dynamic>)> getMarketPreorderSellingInfo(
      EthereumAddress marketAddress) async {
    PredictionMarketContract predictionMarketContract =
        PredictionMarketContract(contractAddress: marketAddress);
    Map<String, dynamic> data = {};

    try {
      final result = await Future.wait([
        ganacheClient.call(
            contract: predictionMarketContract.contract,
            function: predictionMarketContract.getMarketInitialYesNoShares(),
            params: []),
        ganacheClient.call(
            contract: predictionMarketContract.contract,
            function: predictionMarketContract.getMarketRemainYesNoShares(),
            params: [])
      ]);
      data["init_yes"] = (result[0][0] as BigInt).toDouble();
      data["init_no"] = (result[0][1] as BigInt).toDouble();
      data["remain_yes"] = (result[1][0] as BigInt).toDouble();
      data["remain_no"] = (result[1][1] as BigInt).toDouble();
      debugPrint("GanacheService getMarketPreorderSellingInfo result: $data");
      return (true, data);
    } catch (e) {
      debugPrint("GanacheService getMarketPreorderSellingInfo error: $e");
      return (false, data);
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