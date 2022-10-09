module CITA
  class RPC
    def send_transaction(transaction, private_key)
      code     = transaction.data.present? ? "--code #{transaction.data}" : ""
      address  = transaction.to.present? ? "--address #{transaction.to}" : ""
      chain_id = transaction.chain_id.present? ? "--chain-id #{transaction.chain_id}" : ""
      quota    = transaction.quota.present? ? "--quota #{transaction.quota}" : ""
      value    = transaction.value.present? ? "--value #{transaction.value}" : ""
      version  = transaction.version.present? ? "--version #{transaction.version}" : ""
      valid_until_block = transaction.valid_until_block - 88 # cita-cli 代码里固定设置88
      height   = "--height #{valid_until_block}"

      byte_code = %x(#{Rails.root.join(ENV["CITA_CLI_PATH"])} tx make #{code} #{address} #{chain_id} #{quota} #{value} #{version} #{height} --url #{ENV["CITA_URL"]})
      result = %x(#{Rails.root.join(ENV["CITA_CLI_PATH"])} tx sendTransaction --algorithm #{ENV["ALGORITHM"]} --byte-code #{byte_code.strip} --private-key #{private_key} --url #{ENV["CITA_URL"]})
      Oj.load(result)
    end
  end
end
