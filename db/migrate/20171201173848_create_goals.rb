class CreateGoals < ActiveRecord::Migration[5.1]
  def change
    create_table :goals do |t|
      t.belongs_to :topic_level, index: true
      t.string :content
      t.integer :version

      t.timestamps
    end
  end
end
