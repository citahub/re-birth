class UpgradeToCita018 < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE blocks SET header = jsonb_set(header #- '{proof, Tendermint}', '{proof, Bft}', header#>'{proof, Tendermint}') WHERE header#>'{proof}' ? 'Tendermint';
        SQL
      end
      dir.down do
        execute <<-SQL
          UPDATE blocks SET header = jsonb_set(header #- '{proof, Bft}', '{proof, Tendermint}', header#>'{proof, Bft}') WHERE header#>'{proof}' ? 'Bft';
        SQL
      end
    end
  end
end
