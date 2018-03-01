class Api::V1::GshPlus::GshChildrenController < Api::V1::BaseController

  def match_identity
    child = ProjectSeasonApplyChild.find_by(id_card: params[:child][:id_card], approve_state: 'pass')
    if child.present?
      api_success(message: '匹配成功', data: true)
    else
      api_success(message: '匹配失败，请检查提交信息', data: false)
    end
  end

  def confirm_identity
    pair_records = ProjectSeasonApplyChild.where(id_card: params[:id_card], approve_state: 'pass', project: Project.pair_project)
    camp_records = ProjectSeasonApplyChild.where(id_card: params[:id_card], approve_state: 'pass', project: Project.camp_project)
    api_success(data: {pair_records: pair_records.map{|record| record.pair_record_builder}, camp_records: camp_records.map{|record| record.apply.try(:name)}})
  end

end
