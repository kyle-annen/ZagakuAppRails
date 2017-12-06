class CreateTopicLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :topic_levels do |t|
      t.belongs_to :topic, index: true
      t.integer :level_number
      t.timestamps
    end
  end
end
