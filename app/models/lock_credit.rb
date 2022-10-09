class LockCredit < ApplicationRecord

  def self.save_lock_credit(log, decode_tx, log_index)
    ApplicationRecord.transaction(isolation: :serializable) do
      lock_credit = LockCredit.find_or_initialize_by(tx_hash: decode_tx.tx_hash, log_index: log_index)
      lock_credit.system_id = log["info"]["systemId"]
      lock_credit.rights_lock_limit = log["info"]["rightsLockLimit"]
      lock_credit.lock_type = log["info"]["lockType"]
      lock_credit.institutions_id = log["info"]["institutionsId"]
      lock_credit.open_tongbao_id = log["info"]["creditorRightsNumID"]
      lock_credit.origin_function = log["info"]["originFunction"]
      lock_credit.timestamp = decode_tx.timestamp
      lock_credit.save!

      locked_amount = LockCredit.where(system_id: lock_credit.system_id, institutions_id: lock_credit.institutions_id, lock_type: 0).sum(:rights_lock_limit)
      unlocked_amount = LockCredit.where(system_id: lock_credit.system_id, institutions_id: lock_credit.institutions_id, lock_type: 1).sum(:rights_lock_limit)
      institution = Institution.find_by!(system_id: lock_credit.system_id, institutions_id: lock_credit.institutions_id)
      institution.update!(lock_credit: (locked_amount - unlocked_amount))
    end
  rescue ActiveRecord::SerializationFailure => e
    retry
  end
end
