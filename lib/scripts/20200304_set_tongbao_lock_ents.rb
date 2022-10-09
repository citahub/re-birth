abi = %Q{
    [
        {
            "constant": true,
            "inputs": [{
                "internalType": "bytes32",
                "name": "_creditorRightsNumID",
                "type": "bytes32"
            }],
            "name": "getCrLockedParentAddress",
            "outputs": [{
                "internalType": "address",
                "name": "",
                "type": "address"
            }],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        }
    ]
}
contract_address = "0xbe4f4abf6a4587e58ad1f94b08aca2ccb5af0a0d" #北京测试环境
# contract_address = "" #上海测试环境
# contract_address = "" #上海生产环境
cita = CITA::Client.new(ENV["CITA_URL"])
contract = cita.contract_at(abi, contract_address)
total_count = OpenTongbao.where(lock_ents: nil).count
current_num = 0
OpenTongbao.where(lock_ents: nil).find_each do |open_tongbao|
    ent_addr = contract.call_func(method: :getCrLockedParentAddress, params: [open_tongbao.tongbao_id])
    ent_address = (ent_addr == ["0000000000000000000000000000000000000000"] ? [] : ent_addr)
    open_tongbao.update!(lock_ents: ent_address)
    current_num += 1
    puts "#{current_num}/#{total_count}"
end

# OpenTongbao.find_each do |open_tongbao|
#     puts contract.call_func(method: :getCrLockedParentAddress, params: [open_tongbao.tongbao_id])
# end
