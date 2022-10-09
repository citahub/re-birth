class CreateValidatorCaches < ActiveRecord::Migration[5.2]
  def change
    create_table :validator_caches do |t|
      t.string :name, null: false, index: { unique: true }
      t.integer :counter

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        # create validator cache for present blocks
        ApplicationRecord.transaction do
          Block.where.not(block_number: 0).group("header ->> 'proposer'").count.each do |k, v|
            cache = ValidatorCache.find_or_create_by(name: k)
            cache.lock!
            cache.update(counter: v)
          end
        end
      end
    end
  end
end
