class CreateCalendars < ActiveRecord::Migration[5.1]
  def change
    create_table :calendars do |t|
      t.string :name
      t.string :google_ical_link
      t.string :time_zone
      t.timestamps
    end
  end
end
