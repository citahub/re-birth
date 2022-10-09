# rake contract:deploy\[/Users/liyi/project/ouyeel-contract/deploye-contract/build/contracts,0x30a40e35b40502ecf7cd02c4e3b4bbe29456cac445383bc5f2b3d289dd4f989f,http://192.168.1.80:1337\]
namespace :contract do
  desc "deploy contracts"
  task :deploy, [:dir_path, :private_key, :cita_url] => [:environment] do |task, args|
    cita = CITA::Client.new(args[:cita_url])

    Dir[args[:dir_path] + "/*.json"].each do |file|

      # file = "/Users/liyi/project/ouyeel-contract/deploye-contract/build/contracts/RightsFactory.json"
      contract_info = Oj.load(File.read(file))
      puts "=============合约名称======================="
      puts contract_info["contractName"]

      private_key = "--private-key #{args[:private_key]}"
      quota = "--quota #{10000000}" 
      bytecode = "--code #{contract_info["bytecode"]}"
      resp = %x(#{Rails.root.join(ENV["CITA_CLI_PATH"])} rpc sendRawTransaction #{bytecode} #{private_key} #{quota} --algorithm #{ENV["ALGORITHM"]} --url #{args[:cita_url]})
      resp_hash = Oj.load(resp)
      puts "-------部署合约的交易hash-----------"
      puts resp_hash["result"]["hash"]

      response = nil
      10.times do
        sleep 1
        response = cita.rpc.get_transaction_receipt(resp_hash["result"]["hash"])
        if response["result"]
          puts "-------部署返回的合约地址-----------"
          puts response["result"]["contractAddress"]
          break
        end
      end

      abi_hex = CITA::Utils.from_bytes(contract_info["abi"].to_json)
      abi_hex = CITA::Utils.remove_hex_prefix(abi_hex)
      data = response["result"]["contractAddress"] + abi_hex

      block_number_hex_str = CitaSync::Api.block_number["result"]
      valid_until_block = HexUtils.to_decimal(block_number_hex_str) + 88

      tx = CITA::Transaction.new(
        to: "0xffffffffffffffffffffffffffffffffff010001",
        valid_until_block: valid_until_block,
        quota: 10000000,
        data: data,
        value: "",
        chain_id: "1",
        version: 2
      )

      resp_store = cita.rpc.send_transaction(tx, args[:private_key])
      puts "-------存储ABI的交易hash-----------"
      puts resp_store["result"]["hash"]

      abi = nil
      10.times do
        sleep 1
        abi_response = cita.rpc.get_transaction_receipt(resp_store["result"]["hash"])
        if abi_response["result"]
          abi_hex = CitaSync::Api.get_abi(response["result"]["contractAddress"], "pending")["result"]
          abi = CITA::Utils.to_bytes(abi_hex)
          break
        end
      end
      puts "--------存储ABI结果----------"
      puts abi.nil? ? "失败" : "成功"
    end
  end

  desc "save abi"
  task :save_abi, [:json_path, :private_key, :cita_url, :contract_address] => [:environment] do |task, args|
    cita = CITA::Client.new(args[:cita_url])
    file = args[:json_path]
    contract_address = args[:contract_address]
    contract_info = Oj.load(File.read(file))
    abi_hex = CITA::Utils.from_bytes(contract_info["abi"].to_json)
    abi_hex = CITA::Utils.remove_hex_prefix(abi_hex)
    data = contract_address + abi_hex

    block_number_hex_str = CitaSync::Api.block_number["result"]
    valid_until_block = HexUtils.to_decimal(block_number_hex_str) + 88

    tx = CITA::Transaction.new(
      to: "0xffffffffffffffffffffffffffffffffff010001",
      valid_until_block: valid_until_block,
      quota: 10000000,
      data: data,
      value: "",
      chain_id: "1",
      version: 2
    )

    resp_store = cita.rpc.send_transaction(tx, args[:private_key])
    puts "-------存储ABI的交易hash-----------"
    puts resp_store["result"]["hash"]

    abi = nil
    10.times do
      sleep 1
      abi_response = cita.rpc.get_transaction_receipt(resp_store["result"]["hash"])
      if abi_response["result"]
        abi_hex = CitaSync::Api.get_abi(contract_address, "pending")["result"]
        abi = CITA::Utils.to_bytes(abi_hex)
        break
      end
    end
    puts "--------存储ABI结果----------"
    puts abi.nil? ? "失败" : "成功"
  end
end
