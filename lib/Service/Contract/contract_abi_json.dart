class ContractAbiJson {
  static Object get funturyContractAbi => [
        {"inputs": [], "stateMutability": "nonpayable", "type": "constructor"},
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "owner",
              "type": "address"
            },
            {
              "indexed": true,
              "internalType": "address",
              "name": "spender",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "value",
              "type": "uint256"
            }
          ],
          "name": "Approval",
          "type": "event"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "spender", "type": "address"},
            {"internalType": "uint256", "name": "amount", "type": "uint256"}
          ],
          "name": "approve",
          "outputs": [
            {"internalType": "bool", "name": "", "type": "bool"}
          ],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "claimFreeTokens",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "string", "name": "title", "type": "string"},
            {
              "internalType": "uint256",
              "name": "resolutionTime",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "preOrderTime",
              "type": "uint256"
            }
          ],
          "name": "createMarket",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "spender", "type": "address"},
            {
              "internalType": "uint256",
              "name": "subtractedValue",
              "type": "uint256"
            }
          ],
          "name": "decreaseAllowance",
          "outputs": [
            {"internalType": "bool", "name": "", "type": "bool"}
          ],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "_from", "type": "address"},
            {"internalType": "address", "name": "_to", "type": "address"},
            {
              "internalType": "address",
              "name": "_marketaddress",
              "type": "address"
            },
            {
              "internalType": "string",
              "name": "_marketTitle",
              "type": "string"
            },
            {"internalType": "bool", "name": "_isYes", "type": "bool"},
            {"internalType": "uint256", "name": "_amount", "type": "uint256"},
            {
              "internalType": "uint256",
              "name": "_totalPrice",
              "type": "uint256"
            },
            {"internalType": "uint256", "name": "_time", "type": "uint256"}
          ],
          "name": "emitTransferRecord",
          "outputs": [
            {"internalType": "bool", "name": "", "type": "bool"}
          ],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "spender", "type": "address"},
            {"internalType": "uint256", "name": "addedValue", "type": "uint256"}
          ],
          "name": "increaseAllowance",
          "outputs": [
            {"internalType": "bool", "name": "", "type": "bool"}
          ],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "marketContract",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "string",
              "name": "marketTitle",
              "type": "string"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "createTime",
              "type": "uint256"
            },
            {
              "indexed": true,
              "internalType": "uint256",
              "name": "resolvedTime",
              "type": "uint256"
            },
            {
              "indexed": true,
              "internalType": "uint256",
              "name": "preorderTime",
              "type": "uint256"
            }
          ],
          "name": "MarketCreated",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "from",
              "type": "address"
            },
            {
              "indexed": true,
              "internalType": "address",
              "name": "to",
              "type": "address"
            },
            {
              "indexed": true,
              "internalType": "address",
              "name": "marketContracts",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "string",
              "name": "marketTitle",
              "type": "string"
            },
            {
              "indexed": false,
              "internalType": "bool",
              "name": "isYes",
              "type": "bool"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "amount",
              "type": "uint256"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "totalPrice",
              "type": "uint256"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "time",
              "type": "uint256"
            }
          ],
          "name": "MarketTransferRecord",
          "type": "event"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "to", "type": "address"},
            {"internalType": "uint256", "name": "amount", "type": "uint256"}
          ],
          "name": "mint",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "user",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "amount",
              "type": "uint256"
            }
          ],
          "name": "TokenClaimed",
          "type": "event"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "to", "type": "address"},
            {"internalType": "uint256", "name": "amount", "type": "uint256"}
          ],
          "name": "transfer",
          "outputs": [
            {"internalType": "bool", "name": "", "type": "bool"}
          ],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "from",
              "type": "address"
            },
            {
              "indexed": true,
              "internalType": "address",
              "name": "to",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "value",
              "type": "uint256"
            }
          ],
          "name": "Transfer",
          "type": "event"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "from", "type": "address"},
            {"internalType": "address", "name": "to", "type": "address"},
            {"internalType": "uint256", "name": "amount", "type": "uint256"}
          ],
          "name": "transferBetweenUser",
          "outputs": [
            {"internalType": "bool", "name": "", "type": "bool"}
          ],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "from", "type": "address"},
            {"internalType": "address", "name": "to", "type": "address"},
            {"internalType": "uint256", "name": "amount", "type": "uint256"}
          ],
          "name": "transferFrom",
          "outputs": [
            {"internalType": "bool", "name": "", "type": "bool"}
          ],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "from", "type": "address"},
            {"internalType": "uint256", "name": "amount", "type": "uint256"}
          ],
          "name": "transferFromUser",
          "outputs": [
            {"internalType": "bool", "name": "", "type": "bool"}
          ],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "to", "type": "address"},
            {"internalType": "uint256", "name": "amount", "type": "uint256"}
          ],
          "name": "transferReward",
          "outputs": [
            {"internalType": "bool", "name": "", "type": "bool"}
          ],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "owner", "type": "address"},
            {"internalType": "address", "name": "spender", "type": "address"}
          ],
          "name": "allowance",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "account", "type": "address"}
          ],
          "name": "balanceOf",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "decimals",
          "outputs": [
            {"internalType": "uint8", "name": "", "type": "uint8"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "freeTokenAmount",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "getAllMarket",
          "outputs": [
            {"internalType": "address[]", "name": "", "type": "address[]"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "uint256", "name": "index", "type": "uint256"}
          ],
          "name": "getMarketContract",
          "outputs": [
            {"internalType": "address", "name": "", "type": "address"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "", "type": "address"}
          ],
          "name": "hasClaimedFreeTokens",
          "outputs": [
            {"internalType": "bool", "name": "", "type": "bool"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {
              "internalType": "address",
              "name": "marketAddress",
              "type": "address"
            }
          ],
          "name": "isMarketContract",
          "outputs": [
            {"internalType": "bool", "name": "", "type": "bool"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "", "type": "address"}
          ],
          "name": "isValidMarket",
          "outputs": [
            {"internalType": "bool", "name": "", "type": "bool"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "name": "marketContracts",
          "outputs": [
            {"internalType": "address", "name": "", "type": "address"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "name",
          "outputs": [
            {"internalType": "string", "name": "", "type": "string"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "owner",
          "outputs": [
            {"internalType": "address", "name": "", "type": "address"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "symbol",
          "outputs": [
            {"internalType": "string", "name": "", "type": "string"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "totalFTSupply",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "totalSupply",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        }
      ];

  static Object get predictionMarketContractAbi => [
        {
          "inputs": [
            {"internalType": "string", "name": "_title", "type": "string"},
            {
              "internalType": "uint256",
              "name": "_resolutionTime",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "_preorderTime",
              "type": "uint256"
            },
            {
              "internalType": "address",
              "name": "_funturyContract",
              "type": "address"
            },
            {"internalType": "address", "name": "_owner", "type": "address"}
          ],
          "stateMutability": "nonpayable",
          "type": "constructor"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "market",
              "type": "address"
            }
          ],
          "name": "MarketCancelled",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "market",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "bool",
              "name": "resolvedToYes",
              "type": "bool"
            }
          ],
          "name": "MarketResolved",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "from",
              "type": "address"
            },
            {
              "indexed": true,
              "internalType": "address",
              "name": "to",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "amount",
              "type": "uint256"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "totalCost",
              "type": "uint256"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "time",
              "type": "uint256"
            }
          ],
          "name": "NoTransaction",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "user",
              "type": "address"
            },
            {
              "indexed": true,
              "internalType": "address",
              "name": "market",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "amount",
              "type": "uint256"
            }
          ],
          "name": "RewardClaimed",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "internalType": "address",
              "name": "from",
              "type": "address"
            },
            {
              "indexed": true,
              "internalType": "address",
              "name": "to",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "amount",
              "type": "uint256"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "totalCost",
              "type": "uint256"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "time",
              "type": "uint256"
            }
          ],
          "name": "YesTransaction",
          "type": "event"
        },
        {
          "inputs": [],
          "name": "cancelMarket",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "checkAndEndPreorder",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "user", "type": "address"}
          ],
          "name": "checkReward",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "claimReward",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "createTime",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "funturyContract",
          "outputs": [
            {"internalType": "address", "name": "", "type": "address"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "getInitialPrice",
          "outputs": [
            {"internalType": "uint256", "name": "price", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "getMarketInfo",
          "outputs": [
            {"internalType": "string", "name": "_title", "type": "string"},
            {
              "internalType": "uint256",
              "name": "_createTime",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "_resolutionTime",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "_preOrderTime",
              "type": "uint256"
            },
            {
              "internalType": "address",
              "name": "_funturyContract",
              "type": "address"
            },
            {"internalType": "address", "name": "_owner", "type": "address"},
            {"internalType": "int256", "name": "_IntState", "type": "int256"},
            {"internalType": "bool", "name": "_resolvedToYes", "type": "bool"},
            {
              "internalType": "uint256",
              "name": "_marketRemainYesShares",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "_marketRemainNoShares",
              "type": "uint256"
            },
            {
              "internalType": "uint256",
              "name": "_initialPrice",
              "type": "uint256"
            }
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "getMarketInitialYesNoShares",
          "outputs": [
            {"internalType": "uint256", "name": "yes", "type": "uint256"},
            {"internalType": "uint256", "name": "no", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "getMarketRemainYesNoShares",
          "outputs": [
            {"internalType": "uint256", "name": "yes", "type": "uint256"},
            {"internalType": "uint256", "name": "no", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "getMarketState",
          "outputs": [
            {"internalType": "string", "name": "", "type": "string"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "user", "type": "address"}
          ],
          "name": "getUserShares",
          "outputs": [
            {"internalType": "uint256", "name": "yes", "type": "uint256"},
            {"internalType": "uint256", "name": "no", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "", "type": "address"}
          ],
          "name": "hasClaimedReward",
          "outputs": [
            {"internalType": "bool", "name": "", "type": "bool"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "initialNoShares",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "initialPrice",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "initialYesShares",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "marketRemainNoShares",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "marketRemainYesShares",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "owner",
          "outputs": [
            {"internalType": "address", "name": "", "type": "address"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "preOrderTime",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "to", "type": "address"},
            {"internalType": "bool", "name": "isYes", "type": "bool"},
            {"internalType": "uint256", "name": "price", "type": "uint256"},
            {"internalType": "uint256", "name": "amount", "type": "uint256"}
          ],
          "name": "preOrderTransfer",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "resolutionTime",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "bool", "name": "outcome", "type": "bool"}
          ],
          "name": "resolveMarket",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "resolvedToYes",
          "outputs": [
            {"internalType": "bool", "name": "", "type": "bool"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "state",
          "outputs": [
            {
              "internalType": "enum PredictionMarket.MarketState",
              "name": "",
              "type": "uint8"
            }
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "title",
          "outputs": [
            {"internalType": "string", "name": "", "type": "string"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "from", "type": "address"},
            {"internalType": "address", "name": "to", "type": "address"},
            {"internalType": "bool", "name": "isYes", "type": "bool"},
            {"internalType": "uint256", "name": "price", "type": "uint256"},
            {"internalType": "uint256", "name": "amount", "type": "uint256"}
          ],
          "name": "transferShares",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "", "type": "address"}
          ],
          "name": "userNoTokens",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "", "type": "address"}
          ],
          "name": "userYesTokens",
          "outputs": [
            {"internalType": "uint256", "name": "", "type": "uint256"}
          ],
          "stateMutability": "view",
          "type": "function"
        }
      ];
}
