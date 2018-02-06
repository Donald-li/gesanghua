class AddColumnProjectIdToMonthDonate < ActiveRecord::Migration[5.1]
  def change
    add_column :month_donates, :project_id, :integer, comment: '项目ID'
    add_column :month_donates, :certificate_no, :string, comment: '捐赠证书编号'
  end
end
