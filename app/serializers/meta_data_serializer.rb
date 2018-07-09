class MetaDataSerializer < ActiveModel::Serializer
  attributes :chain_id, :chain_name, :operator, :website, :genesis_timestamp, :validators, :block_interval, :token_name, :token_symbol, :token_avatar

end
