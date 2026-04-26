class CreateBillingRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :billing_records do |t|
      t.references :client, null: false, foreign_key: true
      t.datetime :billed_at
      t.string :payment_method_identifier
      t.string :status
      t.string :year_month

      t.timestamps
    end
    add_index :billing_records, [ :client_id, :year_month ], unique: true
  end
end
