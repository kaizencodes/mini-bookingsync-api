class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.string :client_email
      t.integer :price
      t.datetime :start_at
      t.datetime :end_at
      t.belongs_to :rental

      t.timestamps
    end
  end
end
