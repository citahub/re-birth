class UpgradeToCita018 < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE blocks SET header = replace(header::TEXT,'"Tendermint":','"Bft":')::jsonb;
        SQL
      end
      dir.down do
        execute <<-SQL
          UPDATE blocks SET header = replace(header::TEXT,'"Bft":','"Tendermint":')::jsonb;
        SQL
      end
    end
  end
end
