class AddInvoiceInfoToOpenTongbaos < ActiveRecord::Migration[5.2]
  def change
    add_column :open_tongbaos, :invoice_encrypted, :string, array: true
    add_column :open_tongbaos, :invoice_decrypted, :jsonb
    add_column :open_tongbaos, :is_advance_charge, :boolean
  end
end
