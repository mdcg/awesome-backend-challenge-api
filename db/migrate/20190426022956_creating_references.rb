class CreatingReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :batches do |t|
      t.string :reference
      t.string :purchase_channel
      t.references :user
      t.timestamps
    end
    
    create_table :orders do |t|
      t.string :reference
      t.string :purchase_channel
      t.string :client_name
      t.text :address
      t.string :delivery_service
      t.string :total_value
      t.text :line_items
      t.string :status
      t.references :user
      t.references :batch
      t.timestamps
    end
  end
end
