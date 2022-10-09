#rails r 20190711_create_backstage_personnel.rb
manager_account = {
  "address": "0x15669487ba0ca4cf1093f624cc06e4b808766fd4",
  "private": "0x6908f1fca2d7d2eb61af2206bb62d7e9423e87cba8475da3684c573b8f3c5360",
  "public": "0xd05597b7078086dd1acb38e80fe3bd68365146ed836a3c55a66e8cfb53ee9734efa16d40ef968ac91574fdf4233423783b51bba9b6ab08b8e384899781baf72c"
}

super_admin = {
  "address": "0x831d3dd6871e135d07bb2f6f3dcf3a0344e5a2f8",
  "private": "0x30a40e35b40502ecf7cd02c4e3b4bbe29456cac445383bc5f2b3d289dd4f989f",
  "public": "0x5599afb67c3390bb6490fa8b37c213ca2efdca474e4636ed2720cc2f35762e7c62add2060548d6eba4e812c6e912bca415cf19f5ba1be4921650f360f320da8b"
}

contract_address = "0xbe4f4abf6a4587e58ad1f94b08aca2ccb5af0a0d"

abi_hex = CitaSync::Api.get_abi(contract_address, "latest")["result"]
abi = CITA::Utils.to_bytes abi_hex
block_number_hex_str = CitaSync::Api.block_number["result"]
valid_until_block = HexUtils.to_decimal(block_number_hex_str) + 88

tx = CITA::Transaction.new(
  to: contract_address,
  nonce: "create_backstage_personnel_#{Time.now.to_i}",
  quota: 8000000,
  valid_until_block: valid_until_block,
  data: "",
  value: "",
  chain_id: "1",
  version: 2
)

cita = CITA::Client.new(ENV["CITA_URL"])
contract = cita.contract_at(abi, contract_address)

params = [
    "2c4b3c868673b9c34aa1c98eff0dab677bca735f72d1537b238e566dec73d49ac2106cf62ed1aa31f653fb380aaeb03a42e28cfd2cd472c69cd523a19f3a41dc65c881d40fc7e79650272d2db983fd92", #最长10K
    99,# 身份权限 预留字段，默认为99
    0, # 身份状态 0:启用 1:禁用。默认是0
  [
    "rubytest", #调用系统id
    "1",#链代码
    "不能超过32位"#序号
  ],
  manager_account[:address]
]

# send_response = contract.send_func(tx: tx, private_key: super_admin[:private], method: :createBackstagePersonnel, params: params)
# puts send_response

data, _output_types = contract.send(:function_data_with_ot, :createBackstagePersonnel, *params)
tx.data = data
resp = contract.rpc.send_transaction(tx, super_admin[:private])
puts resp
send_response = resp&.dig("result")

loop do
  sleep 1
  response = cita.rpc.get_transaction_receipt(send_response["hash"])
  if response["result"]
    puts response
    break
  end
end

