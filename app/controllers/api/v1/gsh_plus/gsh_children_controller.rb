class Api::V1::GshPlus::GshChildrenController < Api::V1::BaseController

  def match_identity
    gsh_child = nil
    if params[:child][:id_card].present?
      gsh_child =  GshChild.find_by(id_card: params[:child][:id_card])
    elsif params[:child][:gsh_no].present? && params[:child][:name].present?
      gsh_child = GshChild.find_by(gsh_no: params[:child][:gsh_no], name: params[:child][:name])
    end
    if gsh_child.present?
      api_success(message: '匹配成功', data: {result: true, child: gsh_child})
    else
      api_success(message: '匹配失败，请检查提交信息', data: {result: false})
    end
  end

  def confirm_identity
    gsh_child = GshChild.find_by(id: params[:child_id])
    pair_records = gsh_child.project_season_apply_children.where(project: Project.pair_project).reverse_sorted
    camp_records = gsh_child.project_season_apply_camp_members.reverse_sorted
    api_success(data: {pair_records: pair_records.map{|record| record.pair_record_builder}, camp_records: camp_records.map{|record| record.apply.try(:name)}, child_info: gsh_child.child_info_builder})
  end

  def confirm
    gsh_child = GshChild.find(params[:id])
    if gsh_child.update(user_id: current_user.id)
      user = current_user
      if !user.has_role?(:gsh_child)
        user.roles = user.roles.push(:gsh_child)
        user.save
      end
      api_success(message: '匹配成功', data: true)
    else
      api_success(message: '匹配失败', data: false)
    end
  end

  def edit_child
    gsh_child = current_user.gsh_child || GshChild.find(params[:id])
    api_success(data: {child_info: gsh_child.child_info_builder})
  end

  def update_child
    gsh_child = GshChild.find_by(id: params[:child_id])
    if gsh_child.update(province: params[:location][0], city: params[:location][1], district: params[:location][2], workstation: params[:workstation], kind: params[:kind])
      gsh_child.attach_avatar(params[:avatar_id])
      api_success(message: '修改成功', data: true)
    else
      api_success(message: '修改失败', data: false)
    end
  end

end
