class CreateShows < ActiveRecord::Migration[7.0]
  def change
    create_table :shows, id: :uuid do |t|
      t.integer :status, null: false
      t.datetime :date, null: false, unique: true

      t.timestamps
    end
    add_index :shows, :date, unique: true
  end
end
