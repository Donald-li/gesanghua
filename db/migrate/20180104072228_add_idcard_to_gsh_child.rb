class AddIdcardToGshChild < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_children, :idcard, :string, comment: '身份证'
  end
end
