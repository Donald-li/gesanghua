class CreateAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :assets, comment: '资源表' do |t|
      t.string :type
      t.string :owner_type
      t.integer :owner_id
      t.integer :position
      t.string :file
      t.string :file_name
      t.integer :file_size
      t.integer :width
      t.integer :height
      t.string :user_type
      t.integer :user_id
      t.string :protect_token

      t.timestamps
    end
    add_index :assets, :type
  end
end
