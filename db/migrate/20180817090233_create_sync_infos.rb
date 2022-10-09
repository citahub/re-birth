class CreateSyncInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :sync_infos do |t|
      t.string :name, index: true
      t.jsonb :value

      t.timestamps
    end
  end
end
