class CreateUserLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :user_lessons do |t|
      t.belongs_to :user, index: true
      t.belongs_to :lesson, index: true
      t.string :lesson_type, null: false
      t.integer :version, null: false
      t.boolean :complete, null: false, default: false
    end
  end
end
