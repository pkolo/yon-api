class CreateSerieses < ActiveRecord::Migration[5.1]
  def change
    create_table :serieses do |t|
      t.string :title
      t.string :abbreviation

      t.timestamps
    end
  end
end
