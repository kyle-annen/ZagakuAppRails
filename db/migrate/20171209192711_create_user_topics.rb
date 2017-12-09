class CreateUserTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :user_topics do |t|
      t.integer :user_id
      t.integer :topic_id
      t.integer :topic_version
      t.timestamps
    end
  end
end
