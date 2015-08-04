class RenameCoverColumns < ActiveRecord::Migration
  def change
    rename_column :videos, :small_cover_url, :smalL_cover
    rename_column :videos, :large_cover_url, :large_cover
  end
end
