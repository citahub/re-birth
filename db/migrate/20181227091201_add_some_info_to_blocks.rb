class AddSomeInfoToBlocks < ActiveRecord::Migration[5.2]
  def change
    add_column :blocks, :timestamp, :bigint
    add_column :blocks, :proposer, :string
    add_column :blocks, :quota_used, :decimal, precision: 100

    reversible do |dir|
      dir.up do
        execute "UPDATE blocks SET timestamp = subquery.timestamp::bigint, proposer = subquery.proposer::varchar, quota_used = subquery.quota_used::decimal(100) FROM (SELECT (b.header ->> 'timestamp') AS timestamp, (b.header ->> 'proposer') AS proposer, ('x'||lpad(substr((b.header ->> 'quotaUsed'), 3, char_length(b.header ->> 'quotaUsed')), 16, '0'))::bit(64)::bigint AS quota_used, block_hash FROM blocks AS b) AS subquery WHERE subquery.block_hash = blocks.block_hash;"
      end
    end
  end
end
