module CITA
  class TransactionSigner
    class << self

      def decode_content(tx_content, recover: true)
        unless recover
          return decode(tx_content, recover: false)
        end
        content_file = Tempfile.new("tx_content")
        File.open(content_file.path, 'w+') do |f|
          f.write tx_content
        end
        json_str = %x(#{Rails.root.join(ENV["CITA_CLI_PATH"])} tx decode-unverifiedTransaction --algorithm #{ENV["ALGORITHM"]} --file #{content_file.path})
        resp = Oj.load(json_str)
        content_file.close(true)
        to = resp["transaction"]["to_v1"] == "0x" ? "" : resp["transaction"]["to_v1"]
        data = resp["transaction"]["data"] == "0x" ? "" : resp["transaction"]["data"]
        value = resp["transaction"]["value"] == "0x" ? "" : resp["transaction"]["value"]
        crypto = resp["crypto"] == 0 ? :DEFAULT : :RESERVED

        result = {
          unverified_transaction: {
            transaction: {
              to: to,
              nonce: Utils.add_prefix_for_not_blank(resp["transaction"]["nonce"]),
              quota: resp["transaction"]["quota"],
              valid_until_block: resp["transaction"]["valid_until_block"],
              data: data,
              value: value,
              chain_id: resp["transaction"]["chain_id_v1"],
              version: resp["transaction"]["version"]
            },
            signature: resp["signature"],
            crypto: crypto
          },
          sender: {
            address: resp["transaction"]["sender"],
            public_key: resp["transaction"]["pub_key"]
          }
        }

        result.delete(:sender) unless recover
        result
      end

    end
  end
end
