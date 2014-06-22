class CreateComics < ActiveRecord::Migration
  def change
    create_table :comics do |t|
      t.integer :number
      t.text :title
      t.text :safe_title
      t.text :alt_text
      t.text :transcript
      t.datetime :date_published
      t.text :news
      t.text :special_link
      t.text :img_url
      t.integer :viewcount
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
