class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.string :topic
      t.string :path
      t.string :sha
      t.integer :size
      t.string :url
      t.string :html_url
      t.string :git_url
      t.string :download_url
      t.string :type
      t.timestamps
    end
  end
end
