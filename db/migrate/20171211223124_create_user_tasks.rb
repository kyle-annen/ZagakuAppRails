class CreateUserTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :user_tasks do |t|
      t.integer :user_id
      t.integer :task_id
      t.boolean :complete, null: false, default: false
      t.timestamps
    end
  end
end

