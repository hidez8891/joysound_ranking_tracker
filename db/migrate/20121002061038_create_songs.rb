class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.text :title
      t.string :request_no
      t.integer :artist_id

      t.timestamps
    end
  end
end
