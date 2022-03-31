class CreateKnowhereShows < ActiveRecord::Migration[7.0]
  def change
    create_table :knowhere_shows, id: :uuid do |t|
      t.integer :status, null: false
      t.datetime :date, null: false, unique: true

      t.timestamps
    end
    add_index :knowhere_shows, :date, unique: true
  end
end
