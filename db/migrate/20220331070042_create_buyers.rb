class CreateBuyers < ActiveRecord::Migration[7.0]
  def change
    create_table :buyers, id: :uuid do |t|
      t.string :name, null: false
      t.string :phone, null: false

      t.timestamps
    end
  end
end
