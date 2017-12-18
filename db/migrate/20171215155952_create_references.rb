class CreateReferences < ActiveRecord::Migration[5.1]
  def change
    create_table :references do |t|
      t.belongs_to :topic, index: true
      t.string :content
      t.integer :version
      t.timestamps
    end
  end
end
