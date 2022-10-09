abi = %Q{
    [
      {
        "constant": true,
        "inputs": [
          {
              "name": "",
              "type": "uint256"
            }
        ],
        "name": "ecgmult",
        "outputs": [
          {
            "name": "",
            "type": "uint256"
          },
          {
            "name": "",
            "type": "uint256"
          }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function",
        "signature": "0x180cd6b5"
      }
    ]
  }
  contract_address = "0xffffffffffffffffffffffffffffffffff033333"
  call_method = "ecgmult"
  params = [115792089237316195423570985008687907852837564279074904382605163141518161494335]
  cita = CITA::Client.new(ENV["CITA_URL"])
  contract = cita.contract_at(abi, contract_address)

  puts contract.call_func(method: call_method.to_sym, params: params)