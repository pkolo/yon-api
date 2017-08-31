class AddTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :token, :string, index: true
  end
end
