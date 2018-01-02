class CreateSequences < ActiveRecord::Migration[5.1]
  def change
    create_table :sequences do |t|
      t.string :kind
      t.string :prefix
      t.integer :value, limit: 8

      t.timestamps
    end
    add_index :sequences, :kind
  end
end
