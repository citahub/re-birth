# frozen_string_literal: true

class Api::SyncErrorSerializer < ActiveModel::Serializer
  attributes :params, :code, :message, :data
  attribute :method
  attribute :created_at, key: :createdAt
  attribute :updated_at, key: :updatedAt

  delegate :method, to: :object
end
