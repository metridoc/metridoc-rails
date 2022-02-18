class DropMarcBookMods < ActiveRecord::Migration[5.2]
  def change
    drop_table :marc_book_mods
  end
end
