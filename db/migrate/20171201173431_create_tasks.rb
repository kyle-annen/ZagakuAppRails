class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.belongs_to :topic_level, index: true
      t.string :content
			t.string :link_image  
			t.string :link_summary
      t.integer :version
      t.timestamps
    end
  end
end
