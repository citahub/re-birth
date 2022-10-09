abi = %Q{
  [
    {
      "constant": true,
      "inputs": [
        {
            "name": "",
            "type": "uint256"
          },
          {
            "name": "",
            "type": "uint256"
          },
          {
            "name": "",
            "type": "uint256"
          }
      ],
      "name": "modpow",
      "outputs": [
        {
          "name": "",
          "type": "uint256"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function",
      "signature": "0x864ddea1"
    }
  ]
}
contract_address = "0xffffffffffffffffffffffffffffffffff033333"
call_method = "modpow"
params = [2,10,1000]
cita = CITA::Client.new(ENV["CITA_URL"])
contract = cita.contract_at(abi, contract_address)

puts contract.call_func(method: call_method.to_sym, params: params)