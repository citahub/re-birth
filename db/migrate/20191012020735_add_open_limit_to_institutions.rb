class AddOpenLimitToInstitutions < ActiveRecord::Migration[5.2]
  def change
    add_column :institutions, :open_limit, :decimal, precision: 80
  end
end
