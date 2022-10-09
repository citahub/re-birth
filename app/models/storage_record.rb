class StorageRecord < ApplicationRecord
  # after_create :push_storage_worker

  # def push_storage_worker
  #   PushStorageWorker.perform_async(id)
  # end
end
