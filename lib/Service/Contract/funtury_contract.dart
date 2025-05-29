import 'dart:convert';
import 'package:funtury/Service/Contract/contract_abi_json.dart';
import 'package:web3dart/web3dart.dart';

class FunturyContract {
  static EthereumAddress contractAddress =
      EthereumAddress.fromHex("0xC60DbF9B9A133E80E7eBb150e035801Bdf0FAA77");
  static DeployedContract funturyContract = DeployedContract(
    ContractAbi.fromJson(
        jsonEncode(ContractAbiJson.funturyContractAbi), 'FunturyContract'),
    contractAddress,
  );

  // Main contract functions
  static ContractFunction claimFreeTokens =
      funturyContract.function('claimFreeTokens');
  static ContractFunction createMarket =
      funturyContract.function("createMarket");
  static ContractFunction getMarketCount =
      funturyContract.function("getMarketCount");
  static ContractFunction getAllMarket =
      funturyContract.function("getAllMarket");
  static ContractFunction getMarketContract =
      funturyContract.function("getMarketContract");
  static ContractFunction isMarketContract =
      funturyContract.function("isMarketContract");
  static ContractFunction isValidMarket =
      funturyContract.function("isValidMarket");

  // Token management functions
  static ContractFunction transferFromUser =
      funturyContract.function("transferFromUser");
  static ContractFunction transferReward =
      funturyContract.function("transferReward");
  static ContractFunction transferBetweenUser =
      funturyContract.function("transferBetweenUser");
  static ContractFunction emitTransferRecord =
      funturyContract.function("emitTransferRecord");

  // Standard ERC20 functions
  static ContractFunction approve = funturyContract.function("approve");
  static ContractFunction transfer = funturyContract.function("transfer");
  static ContractFunction transferFrom =
      funturyContract.function("transferFrom");
  static ContractFunction allowance = funturyContract.function("allowance");
  static ContractFunction increaseAllowance =
      funturyContract.function("increaseAllowance");
  static ContractFunction decreaseAllowance =
      funturyContract.function("decreaseAllowance");

  // Admin functions
  static ContractFunction mint = funturyContract.function("mint");
  static ContractFunction getBalance = funturyContract.function("balanceOf");

  // Contract state reading functions
  static ContractFunction owner = funturyContract.function("owner");
  static ContractFunction name = funturyContract.function("name");
  static ContractFunction symbol = funturyContract.function("symbol");
  static ContractFunction decimals = funturyContract.function("decimals");
  static ContractFunction totalSupply = funturyContract.function("totalSupply");
  static ContractFunction freeTokenAmount =
      funturyContract.function("freeTokenAmount");
  static ContractFunction hasClaimedFreeTokens =
      funturyContract.function("hasClaimedFreeTokens");
  static ContractFunction totalFTSupply =
      funturyContract.function("totalFTSupply");

  // Events
  static ContractEvent tokensClaimedEvent =
      funturyContract.event('TokensClaimed');
  static ContractEvent marketCreatedEvent =
      funturyContract.event('MarketCreated');
  static ContractEvent transferEvent = funturyContract.event('Transfer');
  static ContractEvent approvalEvent = funturyContract.event('Approval');
  static ContractEvent marketTransferRecordEvent =
      funturyContract.event('MarketTransferRecord');

  // Event stream getters
  static Stream<TokensClaimedEvent> getTokensClaimedEvents(Web3Client client) {
    return client
        .events(FilterOptions.events(
            contract: funturyContract, event: tokensClaimedEvent))
        .map((event) => TokensClaimedEvent.fromEventLog(event));
  }

  static Stream<MarketCreatedEvent> getMarketCreatedEvents(Web3Client client) {
    return client
        .events(FilterOptions.events(
            contract: funturyContract, event: marketCreatedEvent))
        .map((event) => MarketCreatedEvent.fromEventLog(event));
  }

  static Stream<MarketTransferRecordEvent> getMarketTransferRecordEvents(
      Web3Client client) {
    return client
        .events(FilterOptions.events(
            contract: funturyContract, event: marketTransferRecordEvent))
        .map((event) => MarketTransferRecordEvent.fromEventLog(event));
  }

  static Stream<TransferEvent> getTransferEvents(Web3Client client) {
    return client
        .events(FilterOptions.events(
            contract: funturyContract, event: transferEvent))
        .map((event) => TransferEvent.fromEventLog(event));
  }

  static Stream<ApprovalEvent> getApprovalEvents(Web3Client client) {
    return client
        .events(FilterOptions.events(
            contract: funturyContract, event: approvalEvent))
        .map((event) => ApprovalEvent.fromEventLog(event));
  }
}

// Event models to parse event data
class TokensClaimedEvent {
  final EthereumAddress user;
  final BigInt amount;

  TokensClaimedEvent(this.user, this.amount);

  static TokensClaimedEvent fromEventLog(FilterEvent event) {
    final decodedData = FunturyContract.tokensClaimedEvent
        .decodeResults(event.topics!, event.data!);

    final userAddress = decodedData[0] as EthereumAddress;
    final amount = decodedData[1] as BigInt;

    return TokensClaimedEvent(userAddress, amount);
  }
}

class MarketCreatedEvent {
  final EthereumAddress marketContract;
  final String marketTitle;
  final DateTime createTime;
  final DateTime resolvedTime;
  final DateTime preOrderTime;

  MarketCreatedEvent(this.marketContract, this.marketTitle, this.createTime,
      this.resolvedTime, this.preOrderTime);

  static MarketCreatedEvent fromEventLog(FilterEvent event) {
    final decodedData = FunturyContract.marketCreatedEvent
        .decodeResults(event.topics!, event.data!);

    final marketContract = decodedData[0] as EthereumAddress;
    final marketTitle = decodedData[1] as String;
    final createTime = DateTime.fromMillisecondsSinceEpoch(
        (decodedData[2] as BigInt).toInt() * 1000);
    final resolvedTime = DateTime.fromMillisecondsSinceEpoch(
        (decodedData[3] as BigInt).toInt() * 1000);
    final preOrderTime = DateTime.fromMillisecondsSinceEpoch(
        (decodedData[4] as BigInt).toInt() * 1000);

    return MarketCreatedEvent(
        marketContract, marketTitle, createTime, resolvedTime, preOrderTime);
  }
}

class MarketTransferRecordEvent {
  final EthereumAddress from;
  final EthereumAddress to;
  final EthereumAddress marketContract;
  final String marketTitle;
  final bool isYes;
  final BigInt amount;
  final BigInt totalPrice;
  final DateTime recordTime;

  MarketTransferRecordEvent(this.from, this.to, this.marketContract, this.marketTitle, this.isYes,
      this.amount, this.totalPrice, this.recordTime);

  static MarketTransferRecordEvent fromEventLog(FilterEvent event) {
    final decodedData = FunturyContract.marketTransferRecordEvent
        .decodeResults(event.topics!, event.data!);

    final from = decodedData[0] as EthereumAddress;
    final to = decodedData[1] as EthereumAddress;
    final marketContract = decodedData[2] as EthereumAddress;
    final marketTitle = decodedData[3] as String;
    final isYes = decodedData[4] as bool;
    final amount = decodedData[5] as BigInt;
    final totalPrice = decodedData[6] as BigInt;
    final recordTime = DateTime.fromMillisecondsSinceEpoch(
        (decodedData[7] as BigInt).toInt() * 1000);

    return MarketTransferRecordEvent(
        from, to, marketContract, marketTitle,isYes, amount, totalPrice, recordTime);
  }
}

class TransferEvent {
  final EthereumAddress from;
  final EthereumAddress to;
  final BigInt value;

  TransferEvent(this.from, this.to, this.value);

  static TransferEvent fromEventLog(FilterEvent event) {
    final decodedData =
        FunturyContract.transferEvent.decodeResults(event.topics!, event.data!);

    final from = decodedData[0] as EthereumAddress;
    final to = decodedData[1] as EthereumAddress;
    final value = decodedData[2] as BigInt;

    return TransferEvent(from, to, value);
  }
}

class ApprovalEvent {
  final EthereumAddress owner;
  final EthereumAddress spender;
  final BigInt value;

  ApprovalEvent(this.owner, this.spender, this.value);

  static ApprovalEvent fromEventLog(FilterEvent event) {
    final decodedData =
        FunturyContract.approvalEvent.decodeResults(event.topics!, event.data!);

    final owner = decodedData[0] as EthereumAddress;
    final spender = decodedData[1] as EthereumAddress;
    final value = decodedData[2] as BigInt;

    return ApprovalEvent(owner, spender, value);
  }
}
