class DropSerieses < ActiveRecord::Migration[5.1]
  def change
    drop_table :serieses
  end
end
