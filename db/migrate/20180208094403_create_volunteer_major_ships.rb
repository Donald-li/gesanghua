class CreateVolunteerMajorShips < ActiveRecord::Migration[5.1]
  def change
    create_table :volunteer_major_ships do |t|
      t.integer :volunteer_id, comment: '志愿者ID'
      t.integer :major_id, comment: '专业ID'

      t.timestamps
    end

    remove_column :volunteers, :major_id
  end
end
