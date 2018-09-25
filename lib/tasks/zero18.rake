# frozen_string_literal: true

# move upgrade script to there.
namespace :zero18 do
  desc "fix 0.17 block data to 0.18 style, if you upgrade your chain to 0.18 and want to fix old data, run this command"
  task update: :environment do
    sql = %{ UPDATE blocks SET header = replace(header::TEXT,'"Tendermint":','"Bft":')::jsonb; }
    ApplicationRecord.connection.execute(sql)
  end

  desc "rollback, chain 0.18 style block data to 0.17"
  task rollback: :environment do
    sql = %{ UPDATE blocks SET header = replace(header::TEXT,'"Bft":','"Tendermint":')::jsonb; }
    ApplicationRecord.connection.execute(sql)
  end
end
