class CreateMajors < ActiveRecord::Migration[5.1]
  def change
    create_table :majors, comment: '登记' do |t|
      t.string :name, comment: '标题'

      t.timestamps
    end
  end
end
