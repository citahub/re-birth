class AddIndexCreditBalanceForInstitution < ActiveRecord::Migration[5.2]
  def change
    add_index :institutions, :credit_balance
  end
end
