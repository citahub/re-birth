class MetaDataSerializer < ActiveModel::Serializer
  attributes :operator, :website, :validators
  attribute :chain_id, key: :chainId
  attribute :chain_name, key: :chainName
  attribute :genesis_timestamp, key: :genesisTimestamp
  attribute :block_interval, key: :blockInterval
  attribute :token_name, key: :tokenName
  attribute :token_symbol, key: :tokenSymbol
  attribute :token_avatar, key: :tokenAvatar

end
