class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
      t.integer :user_id
      t.references :favable, polymorphic: true

      t.timestamps
    end
  end
end
