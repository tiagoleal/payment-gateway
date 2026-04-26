class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.integer :due_day
      t.string :payment_method_identifier

      t.timestamps
    end
  end
end
