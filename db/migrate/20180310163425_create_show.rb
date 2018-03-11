class CreateShow < ActiveRecord::Migration[5.1]
  def change
    create_table :shows do |t|
      t.string :title
      t.string :abbreviation

      t.timestamps
    end
  end
end
