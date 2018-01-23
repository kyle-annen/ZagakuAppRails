class CreateCalendars < ActiveRecord::Migration[5.1]
  def change
    create_table :calendars do |t|
      t.string :google_ical_link
      t.string :time_zone
      t.string :office
      t.timestamps
    end
  end
end
