class RpcApi::V1::BlockSerializer < ActiveModel::Serializer
  attributes :version
  attribute :cita_hash, key: :hash
  attributes :header, :body

  def body
    flag = @instance_options[:flag]
    if flag
      object.body
    else
      { transactions: object.body["transactions"].map { |t| t["hash"] } }
    end
  end
end
