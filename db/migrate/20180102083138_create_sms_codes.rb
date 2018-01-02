class CreateSmsCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :sms_codes do |t|
      t.integer :kind
      t.string :mobile
      t.string :code
      t.integer :state

      t.timestamps
    end
    add_index :sms_codes, :kind
    add_index :sms_codes, :mobile
  end
end
