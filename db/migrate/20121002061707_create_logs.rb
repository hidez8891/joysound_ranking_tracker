class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :song_id
      t.integer :rank
      t.integer :point
      t.date :date

      t.timestamps
    end
  end
end
