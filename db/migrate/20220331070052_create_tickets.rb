class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets, id: :uuid do |t|
      t.integer :ticket_number, null: false
      t.references :knowman_show, null: false, foreign_key: true, type: :uuid
      t.references :buyer, foreign_key: true, type: :uuid
      t.integer :status, null: false

      t.timestamps
    end
  end
end
