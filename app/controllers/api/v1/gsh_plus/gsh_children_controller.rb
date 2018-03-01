class Api::V1::GshPlus::GshChildrenController < Api::V1::BaseController

  def match_identity
    child = ProjectSeasonApplyChild.find_by(id_card: params[:child][:id_card], approve_state: 'pass')
    if child.present?
      api_success(message: '匹配成功', data: true)
    else
      api_success(message: '匹配失败，请检查提交信息', data: false)
    end
  end

end
