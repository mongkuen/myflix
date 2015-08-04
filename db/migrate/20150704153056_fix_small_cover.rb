class FixSmallCover < ActiveRecord::Migration
  def change
    rename_column :videos, :smalL_cover, :small_cover
  end
end
