class CreateLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :lessons do |t|
      t.belongs_to :topic, index: true
      t.string :lesson_type, null: false
      t.integer :level, null: false
      t.string :content, null: false, default: ''
      t.string :link_image, null: false, default: ''
      t.string :link_summary, null: false, default: ''
      t.integer :version, null: false
      t.timestamps
    end
  end
end
