class RemoveNullConstraintFromAlbumTitle < ActiveRecord::Migration[5.1]
  change_column_null :albums, :title, true
end
