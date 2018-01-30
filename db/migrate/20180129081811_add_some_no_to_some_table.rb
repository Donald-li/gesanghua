class AddSomeNoToSomeTable < ActiveRecord::Migration[5.1]
  def change
    add_column :volunteers, :volunteer_no, :string, comment: '志愿者编号'
    add_column :volunteers, :volunteer_apply_no, :string, comment: '志愿者申请编号'
    add_column :teams, :team_no, :string, comment: '团队编号'
    add_column :donate_records, :certificate_no, :string, comment: '捐赠证书编号'
    add_column :project_season_applies, :apply_no, :string, comment: '项目申请编号'
  end
end
