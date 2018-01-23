class AddEmployeeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :employee, :boolean
  end
end
