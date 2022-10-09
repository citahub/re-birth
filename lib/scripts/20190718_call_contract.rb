contract_address = "0xe0907eb849c3daa8be3a137ddf7514665df3522f"
call_method = "balanceOf"
# params = CITA::Utils.from_bytes "k_tb_holder_id_11010"
params = "0x61c49db6522f4f0b9fc0c0d2d8abb06b3ea7a8ef"

abi_hex = CitaSync::Api.get_abi(contract_address, "latest")["result"]
abi = CITA::Utils.to_bytes abi_hex

cita = CITA::Client.new(ENV["CITA_URL"])
contract = cita.contract_at(abi, contract_address)

puts contract.call_func(method: call_method.to_sym, params: [params])

