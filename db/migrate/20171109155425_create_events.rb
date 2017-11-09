class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :call_id, uniqueness: true
      t.datetime :start_time
      t.string :summary
      t.string :link
      t.string :location
      t.string :hangout_link
      t.timestamps
    end
  end
end