manager_account = {
  "address": "0x7d6b33834950ad244550443afcaa69df336edafe",
  "private": "0xbffd2d7f0f66dfd4b263b07e016741af39fecc43ab18734c0d0b881efef8a191",
  "public": "0xbeaae0fd1f01e583f4553a73054c17d6d9958243c6a1acfa3b0ce0a5eb37f15e1462b36662afe960e185535a392642f859c1d927061db10414321ef41f3e022a"
}

contract_address = "0x2c4DD6281a5b0D53AE96a098b9Dd3F6B3d82a4F3"

params = [
    {a: 2}.to_json, #ouye ID
    99,# 身份权限 预留字段，默认为99
    0, # 身份状态 0:启用 1:禁用。默认是0,
  [
    "rubytest", #调用系统id
    "1",#链代码
    "requestSN1"#序号
  ],
  manager_account[:address]
]

abi_hex = CitaSync::Api.get_abi(contract_address, "latest")["result"]
abi = CITA::Utils.to_bytes abi_hex

cita = CITA::Client.new(ENV["CITA_URL"])
contract = cita.contract_at(abi, contract_address)


data, _output_types = contract.send(:function_data_with_ot, :createBackstagePersonnel, *params)
resp = contract.rpc.call_rpc(:call, params: [{data: data, to: contract_address,quota: 8}, "latest"])
puts resp
result = resp&.dig("result")
puts CITA::Utils.to_bytes(result)
