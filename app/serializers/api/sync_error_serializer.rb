class Api::SyncErrorSerializer < ActiveModel::Serializer
  attributes :params, :code, :message, :created_at, :updated_at
  attribute :method

  def method
    object.method
  end
end
