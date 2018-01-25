class AddPrefferedCalendarToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :preffered_calendar, :Integer
  end
end
