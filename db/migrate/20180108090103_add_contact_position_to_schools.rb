class AddContactPositionToSchools < ActiveRecord::Migration[5.1]
  def change
    add_column :schools, :contact_position, :string, comment: '联系人职务'
  end
end
