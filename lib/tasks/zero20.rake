# frozen_string_literal: true

namespace :zero20 do
  desc "fix 0.19 block data to 0.20 style, if you upgrade your chain to 0.20 and want to fix old data, run this command"
  task update: :environment do
    sql = %{ UPDATE blocks SET header = replace(header::TEXT,'"gasUsed":','"quotaUsed":')::jsonb; }
    ApplicationRecord.connection.execute(sql)
  end

  desc "rollback, chain 0.20 style block data to 0.19"
  task rollback: :environment do
    sql = %{ UPDATE blocks SET header = replace(header::TEXT,'"quotaUsed":','"gasUsed":')::jsonb; }
    ApplicationRecord.connection.execute(sql)
  end
end
