class AddColumnsToUsersTable < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :lname, :string
  end
end
