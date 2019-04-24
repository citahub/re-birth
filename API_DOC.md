# API Doc

### JSON-RPC Interface

JSON-RPC interface, same format with [CITA JSON-RPC](http://docs.citahub.com/en-US/cita/rpc-guide/rpc).

> POST /

#### params

```ruby
{
  "jsonrpc": "2.0",
  "id": 83,
  "method": "blockNumber",
  "params": []
}
```

#### response

```ruby
{
  "jsonrpc": "2.0",
  "id": 83,
  "result": "0x7169a"
}
```

### System infos

> GET /api/info/url

Get the http and websocket url which ReBirth connected.

#### response

```ruby
{
  result: {
    http_url: "http://localhost:1337",
    ws_url: "http://localhost:4337"
  }
}
```

### Blocks

Get blocks info list and paginate it.

> GET /v2/api/blocks

#### params

Also Support camelCase.

```ruby
{
  "block_number_from": "10" or "0xa", #  number or integer
  "block_number_to": "20", # number or integer
  "min_transaction_count": "min transaction count", # integer
  "max_transaction_count": "max transaction count", # integer
  "page": "1", # default 1
  "per_page": "10", # default 10

  # offset and limit has lower priority than page and perPage
  "offset": "1", # database offset for pagination
  "limit": "10", # database limit for pagination
}
```

#### response

```ruby
{
    "result": {
        "blocks": [
            {
                "version": 0,
                "header": {
                    "proof": {
                        "Bft": {
                            "round": 0,
                            "height": 111198,
                            "commits": {
                                "0x31042d4f7662cddf8ded5229db3c5e7302875e10": "0x8132cc5090329854a7dc22300b45c5d972f02a1e558e0b1fa71916316ad2fe061c06829b8b5eb16a7d206f421061a392cd6aad7a1d0a05a8c3e7203fe78a181e00",
                                "0x486bb688c8d29056bd7f87c26733048b0a6abda6": "0x4aa508798a0b9b77cc1263ae6b64d78977909fd2ce28e4f9322369041a3175cc4f7ad376b122c4b201dc6d2910c515f3d6d94c35dbd13fa6207a91fa8fd649b400",
                                "0x71b028e49c6f41aaa74932d703c707ecca6d732e": "0xc1e580fa36b0ae5740ca66b612df6d3435c29d20fa21292c93a8bacd7751eee87984a3720576dbad15527bd3a52c9cda42a2d58a382701ab835add5e11bbed1001"
                            },
                            "proposal": "0xc880eb00df297b3c96bc08dca378280f99955816c6f32c08c17f004c0c7dfe75"
                        }
                    },
                    "number": "0x1b25f",
                    "quotaUsed": "0x0",
                    "prevHash": "0x4bf32733fa6ca03326f0cfe7c487d7f8de26ad7c38fcf68959eebc2c0088e279",
                    "proposer": "0x31042d4f7662cddf8ded5229db3c5e7302875e10",
                    "stateRoot": "0x7e51d4969381493124b457e57db6dcab48c741a5046c327a43b59593d6a4ab16",
                    "timestamp": 1532648718735,
                    "receiptsRoot": "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
                    "transactionsRoot": "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421"
                },
                "transactionsCount": 0,
                "hash": "0x06208c3b241ff5b8a1fcdec9190abf0cc861d1e5ecdd4f696892fe7ee972473f"
            }
        ]
    }
}
```

### Transactions

Get transactions list and paginate it.

> GET /api/transactions

#### params

```ruby
{
  "account":  "the addr transactions related to (from or to)", # hash string
  "from":  "the addr transactions from", # hash string
  "to":  "the addr transactions to", # hash string
  "valueFormat": "decimal", # set value to decimal number, default hex number
  "page": "1", # integer, default 1
  "perPage": "10", # integer, default 10
  # offset and limit has lower priority than page and perPage
  "offset":  "1", # integer, default to 0
  "limit":  "10", # integer, default to 10
}
```

#### response

```ruby
{
    "result": {
        "count": 75178,
        "transactions": [
            {
                "value": "0x0000000000000000000000000000000000000000000000000000000000000000", # 0 if valueFormat=decimal
                "to": "0xffffffffffffffffffffffffffffffffff010001",
                "gasUsed": "0x45754",
                "quotaUsed": "0x45754",
                "from": "0x35f8ca15fdeb958d9ad60537bec5e35444dd6d93",
                "content": "0x0ae70b0a286666666666666666666666666666666666666666666666666666666666666666666630313030303118c0843d20d480042a8e0bf2356b3877cb8fa08deb57a9ccf4f67e50012a2f5b7b22636f6e7374616e74223a747275652c22696e70757473223a5b7b226e616d65223a22222c2274797065223a2275696e74323536227d5d2c226e616d65223a22616c6c6f7765644d656d62657273222c226f757470757473223a5b7b226e616d65223a22222c2274797065223a2261646472657373227d5d2c2270617961626c65223a66616c73652c2273746174654d75746162696c697479223a2276696577222c2274797065223a2266756e6374696f6e222c227369676e6174757265223a2230783164353563336631227d2c7b22636f6e7374616e74223a66616c73652c22696e70757473223a5b7b226e616d65223a2266696c65222c2274797065223a22737472696e67227d2c7b226e616d65223a2275726c73222c2274797065223a22737472696e67227d5d2c226e616d65223a2261646446696c65222c226f757470757473223a5b7b226e616d65223a2273756363657373222c2274797065223a22626f6f6c227d5d2c2270617961626c65223a66616c73652c2273746174654d75746162696c697479223a226e6f6e70617961626c65222c2274797065223a2266756e6374696f6e222c227369676e6174757265223a2230783234386266633362227d2c7b22636f6e7374616e74223a747275652c22696e70757473223a5b7b226e616d65223a2266696c65222c2274797065223a22737472696e67227d5d2c226e616d65223a2267657446696c6555726c73222c226f757470757473223a5b7b226e616d65223a2275726c73222c2274797065223a22737472696e67227d5d2c2270617961626c65223a66616c73652c2273746174654d75746162696c697479223a2276696577222c2274797065223a2266756e6374696f6e222c227369676e6174757265223a2230783831363234353763227d2c7b22636f6e7374616e74223a747275652c22696e70757473223a5b5d2c226e616d65223a226f776e6572222c226f757470757473223a5b7b226e616d65223a22222c2274797065223a2261646472657373227d5d2c2270617961626c65223a66616c73652c2273746174654d75746162696c697479223a2276696577222c2274797065223a2266756e6374696f6e222c227369676e6174757265223a2230783864613563623562227d2c7b22636f6e7374616e74223a66616c73652c22696e70757473223a5b7b226e616d65223a2266696c65222c2274797065223a22737472696e67227d5d2c226e616d65223a2272656d6f766546696c65222c226f757470757473223a5b7b226e616d65223a2273756363657373222c2274797065223a22626f6f6c227d5d2c2270617961626c65223a66616c73652c2273746174654d75746162696c697479223a226e6f6e70617961626c65222c2274797065223a2266756e6374696f6e222c227369676e6174757265223a2230786631616665303464227d2c7b22636f6e7374616e74223a747275652c22696e70757473223a5b7b226e616d65223a22222c2274797065223a2275696e74323536227d5d2c226e616d65223a2266696c6573222c226f757470757473223a5b7b226e616d65223a22222c2274797065223a2262797465733332227d5d2c2270617961626c65223a66616c73652c2273746174654d75746162696c697479223a2276696577222c2274797065223a2266756e6374696f6e222c227369676e6174757265223a2230786634633731346234227d2c7b22696e70757473223a5b7b226e616d65223a225f616c6c6f7765644d656d62657273222c2274797065223a22616464726573735b5d227d5d2c2270617961626c65223a66616c73652c2273746174654d75746162696c697479223a226e6f6e70617961626c65222c2274797065223a22636f6e7374727563746f72222c227369676e6174757265223a22636f6e7374727563746f72227d5d3220000000000000000000000000000000000000000000000000000000000000000038011241433a04695bfb3f3ada4266494093b80f317b8c795110fc2a223ad2c771377602c810ce591d7ae85695508eafe851ec080602c7fd7e2481bea43f0ece61189d6a01",
                "blockNumber": "0xffff",
                "hash": "0xf005a3585f9cfce03c7e428b9221eccdedeeae2736c8496c03113f90633135d8",
                "timestamp": 1532511655997,
                "chainId": 1,
                "chainName": "test-chain",
                "errorMessage": "Not enough base gas."
            }
        ]
    }
}
```

### Transaction

Get transactions list and paginate it.

> GET /api/transactions/:hash

example
> GET /api/transactions/0x0000000000000000000000000000000000000000000000000000000000000000

#### params

```ruby
{
  "account":  "the addr transactions related to (from or to)", # hash string
  "from":  "the addr transactions from", # hash string
  "to":  "the addr transactions to", # hash string
  "valueFormat": "decimal", # set value to decimal number, default hex number
}
```

#### response

```ruby
{
    "result": {
        "transaction": {
            "value": "0x0000000000000000000000000000000000000000000000000000000000000000", # 0 if valueFormat=decimal
            "to": "0xffffffffffffffffffffffffffffffffff010001",
            "gasUsed": "0x45754",
            "quotaUsed": "0x45754",
            "from": "0x35f8ca15fdeb958d9ad60537bec5e35444dd6d93",
            "content": "0x0ae70b0a286666666666666666666666666666666666666666666666666666666666666666666630313030303118c0843d20d480042a8e0bf2356b3877cb8fa08deb57a9ccf4f67e50012a2f5b7b22636f6e7374616e74223a747275652c22696e70757473223a5b7b226e616d65223a22222c2274797065223a2275696e74323536227d5d2c226e616d65223a22616c6c6f7765644d656d62657273222c226f757470757473223a5b7b226e616d65223a22222c2274797065223a2261646472657373227d5d2c2270617961626c65223a66616c73652c2273746174654d75746162696c697479223a2276696577222c2274797065223a2266756e6374696f6e222c227369676e6174757265223a2230783164353563336631227d2c7b22636f6e7374616e74223a66616c73652c22696e70757473223a5b7b226e616d65223a2266696c65222c2274797065223a22737472696e67227d2c7b226e616d65223a2275726c73222c2274797065223a22737472696e67227d5d2c226e616d65223a2261646446696c65222c226f757470757473223a5b7b226e616d65223a2273756363657373222c2274797065223a22626f6f6c227d5d2c2270617961626c65223a66616c73652c2273746174654d75746162696c697479223a226e6f6e70617961626c65222c2274797065223a2266756e6374696f6e222c227369676e6174757265223a2230783234386266633362227d2c7b22636f6e7374616e74223a747275652c22696e70757473223a5b7b226e616d65223a2266696c65222c2274797065223a22737472696e67227d5d2c226e616d65223a2267657446696c6555726c73222c226f757470757473223a5b7b226e616d65223a2275726c73222c2274797065223a22737472696e67227d5d2c2270617961626c65223a66616c73652c2273746174654d75746162696c697479223a2276696577222c2274797065223a2266756e6374696f6e222c227369676e6174757265223a2230783831363234353763227d2c7b22636f6e7374616e74223a747275652c22696e70757473223a5b5d2c226e616d65223a226f776e6572222c226f757470757473223a5b7b226e616d65223a22222c2274797065223a2261646472657373227d5d2c2270617961626c65223a66616c73652c2273746174654d75746162696c697479223a2276696577222c2274797065223a2266756e6374696f6e222c227369676e6174757265223a2230783864613563623562227d2c7b22636f6e7374616e74223a66616c73652c22696e70757473223a5b7b226e616d65223a2266696c65222c2274797065223a22737472696e67227d5d2c226e616d65223a2272656d6f766546696c65222c226f757470757473223a5b7b226e616d65223a2273756363657373222c2274797065223a22626f6f6c227d5d2c2270617961626c65223a66616c73652c2273746174654d75746162696c697479223a226e6f6e70617961626c65222c2274797065223a2266756e6374696f6e222c227369676e6174757265223a2230786631616665303464227d2c7b22636f6e7374616e74223a747275652c22696e70757473223a5b7b226e616d65223a22222c2274797065223a2275696e74323536227d5d2c226e616d65223a2266696c6573222c226f757470757473223a5b7b226e616d65223a22222c2274797065223a2262797465733332227d5d2c2270617961626c65223a66616c73652c2273746174654d75746162696c697479223a2276696577222c2274797065223a2266756e6374696f6e222c227369676e6174757265223a2230786634633731346234227d2c7b22696e70757473223a5b7b226e616d65223a225f616c6c6f7765644d656d62657273222c2274797065223a22616464726573735b5d227d5d2c2270617961626c65223a66616c73652c2273746174654d75746162696c697479223a226e6f6e70617961626c65222c2274797065223a22636f6e7374727563746f72222c227369676e6174757265223a22636f6e7374727563746f72227d5d3220000000000000000000000000000000000000000000000000000000000000000038011241433a04695bfb3f3ada4266494093b80f317b8c795110fc2a223ad2c771377602c810ce591d7ae85695508eafe851ec080602c7fd7e2481bea43f0ece61189d6a01",
            "blockNumber": "0xffff",
            "hash": "0xf005a3585f9cfce03c7e428b9221eccdedeeae2736c8496c03113f90633135d8",
            "timestamp": 1532511655997,
            "chainId": 1,
            "chainName": "test-chain",
            "errorMessage": "Not enough base gas."
        }
    }
}

# or not found
{
  "result": {
    "transaction": null
  }
}
```

### Statistics

Get proposals info or brief info.

> GET /api/statistics

#### params

```ruby
{
  type: "proposals" or "brief" # required
}
```

#### response

```ruby
# when type = "proposals"
{
    "result": [
        {
            "validator": "0x0000000000000000000000000000000000000000", # proposer of block header
            "count": 1 # count of this proposer
        },
        {
            "validator": "0x31042d4f7662cddf8ded5229db3c5e7302875e10",
            "count": 28514
        },
        {
            "validator": "0x486bb688c8d29056bd7f87c26733048b0a6abda6",
            "count": 27044
        },
        {
            "validator": "0x71b028e49c6f41aaa74932d703c707ecca6d732e",
            "count": 27844
        },
        {
            "validator": "0xee01b9ba97671e8a1891e85b206b499f106822a1",
            "count": 27797
        }
    ]
}

# when type = "brief"
{
    "result": {
        "tps": 0, # float number, transaction count per second
        "tpb": 0, # float number, transaction count per block
        "ipb": 2.97 # float number, average block interval
    }
}
```

### Status

Get sync process running status.

> GET /api/status

#### response

```ruby
{
    "result": {
        "status": "not running", # sync process running status, "not running" or "running"
        "currentBlockNumber": "0x1b25f", # last sync block
        "currentChainBlockNumber": "0x717d0" # the chain current block number
    }
}
```

### SyncErrors

Get sync errors list, which is the errors while sync from chain.

> GET /api/sync_errors

#### params

```ruby
{
  "page": 1, # integer, default 1
  "perPage": 10, # integer, default 10
  # offset and limit has lower priority than page and perPage
  "offset":  1, # integer
  "limit":  10, # integer
}
```

#### response

```ruby
{
    "result": {
        "count": 4, # total count of sync errors
        "syncErrors": [
            {
                "params": ["0x123"], # the params you send
                "code": -32700,
                "message": "invalid format: [0x123]",
                "createdAt": "2018-08-07T03:21:15.862Z",
                "updatedAt": "2018-08-07T03:21:15.862Z",
                "data": null,
                "method": "getTransaction" # the method you access
            }
        ]
    }
}
```

### ERC20 Transfer event

Get erc20 contracts transfer event logs by address

> GET /api/erc20/transfers

#### params

```ruby
{
    "address": "0x...", # contract address, required
    "account": "from or to", # hash
    "from": "from address", # hash
    "to": "to address", # hash
    "page": 1, # default 1
    "perPage": 10, # default 10
    
    # offset and limit has lower priority than page and perPage
    "offset": 1, # default 0
    "limit": 10 # default 10
}
```

#### response

```ruby
{
    "result": {
        "count": 1,
        "transfers": [
            {
                "address": "0x0b9a7bad10e78aefbe6d99e61c7ea2a23c3ec888",
                "from": "0xac30bce77cf849d869aa37e39b983fa50767a2dd",
                "to": "0x6005ed6b942c99533b896b95fe8a90c7a7ecbf6a",
                "value": 10,
                "blockNumber": "0x18a1ec",
                "gasUsed": "0x64",
                "quotaUsed": "0x64",
                "hash": "0x14b06be4067ba65d05e41d8821e2cf7d572a65b1bf53857a6a504ec42e69fdfd",
                "chainId": 1,
                "chainName": "test-chain"
            }
        ]
    }
}
```

### EventLog by address

Get event logs by address

> GET /api/event_logs/:address

#### params

```ruby
{
    "page": 1, # default 1
    "perPage": 10, # default 10
}
```

#### response

```ruby
{
  "result": {
    "count": 1,
    "eventLogs": [
      {
        "address": "0x0b9a7bad10e78aefbe6d99e61c7ea2a23c3ec888",
        "data": "0x000000000000000000000000000000000000000000000000000000000000000a",
        "topics": [
          "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
          "0x000000000000000000000000ac30bce77cf849d869aa37e39b983fa50767a2dd",
          "0x0000000000000000000000006005ed6b942c99533b896b95fe8a90c7a7ecbf6a"
        ],
        "blockHash": "0xa2574fbd6fe9083ad8a1729630d1fa2c227f0a6df2dbb1f0d6d69faa4145c5cb",
        "blockNumber": "0x18a1ec",
        "logIndex": "0x0",
        "transactionHash": "0x14b06be4067ba65d05e41d8821e2cf7d572a65b1bf53857a6a504ec42e69fdfd",
        "transactionIndex": "0x0",
        "transactionLogIndex": "0x0"
      }
    ]
  }
}
```
)
