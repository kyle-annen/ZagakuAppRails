class CreateUserReferences < ActiveRecord::Migration[5.1]
  def change
    create_table :user_references do |t|
      t.integer :user_id
      t.integer :reference_id
      t.timestamps
    end
  end
end
