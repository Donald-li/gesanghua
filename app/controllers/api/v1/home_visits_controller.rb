class Api::V1::HomeVisitsController < Api::V1::BaseController

  def index
    @child = ProjectSeasonApplyChild.find(params[:id])
    @visits = @child.visits.sorted.page(params[:page]).per(params[:id])
    if @visits.present?
      api_success(data: {visits: @visits.map { |r| r.simple_builder }, pagination: json_pagination(@visits)})
    else
      api_success(data: {visits: [], pagination: json_pagination([])})
    end
  end

  def qrcode
    user = current_user.id
    @child = ProjectSeasonApplyChild.find(params[:id])
    url = "http://#{Settings.app_host}/cooperation/link-to-visit?type=home_visit&id=#{@child.id}&user=#{user}"
    api_success(data: {qrcode_url: url})
  end

  def new
    @child = ProjectSeasonApplyChild.find(params[:id])
    api_success(data: {child: @child.pair_visit_builder})
  end

  def create
    @child = ProjectSeasonApplyChild.find(params[:id])
    if params[:user_id].present?
      user_id = params[:user_id]
    else
      user_id = current_user.id
    end
    member_ids = params[:member_ids].pluck(:id)
    family_members = FamilyMember.where(id: member_ids)
    @visit = @child.visits.build(
      user_id: user_id,
      investigador: params[:investigador],
      escort: params[:escort],
      survey_time: params[:survey_time],
      family_size: params[:family_size],
      family_basic: params[:family_basic].first,
      basic_information: params[:basic_information],
      income_information: params[:income_information],
      expenditure_information: params[:expenditure_information],
      lodge: params[:lodge].first,
      lodge_cost: params[:lodge_cost],
      other_subsidize: params[:other_subsidize],
      prize_information: params[:prize_information],
      study_information: params[:study_information],
      tuition_fee: params[:tuition_fee],
      sponsor_fee: params[:sponsor_fee].first
    )
    if @visit.save
      @visit.attach_image(params[:image][0][:id]) if params[:image][0].present?
      family_members.update_all(visit_id: @visit.id)
      api_success(data: {result: true, child_id: @child.id}, message: '孩子家访信息提交成功！')
    else
      api_success(data: {result: false}, message: '孩子家访信息提交失败，请重试！')
    end
  end

  def edit
    @visit = Visit.find(params[:id])
    api_success(data: {visit: @visit.detail_builder})
  end

  def update
    @visit = Visit.find(params[:id])
    family_basic = params[:family_basic].first if params[:family_basic]
    lodge = params[:lodge].first if params[:lodge]
    grade = params[:grade].first if params[:grade]
    sponsor_fee = params[:sponsor_fee].first if params[:sponsor_fee]
    member_ids = params[:member_ids].pluck(:id)
    family_members = FamilyMember.where(id: member_ids)
    if @visit.update(
      investigador: params[:investigador],
      escort: params[:escort],
      survey_time: params[:survey_time],
      family_size: params[:family_size],
      family_basic: family_basic,
      basic_information: params[:basic_information],
      income_information: params[:income_information],
      expenditure_information: params[:expenditure_information],
      lodge: lodge,
      lodge_cost: params[:lodge_cost],
      other_subsidize: params[:other_subsidize],
      prize_information: params[:prize_information],
      study_information: params[:study_information],
      tuition_fee: params[:tuition_fee],
      sponsor_fee: sponsor_fee
      )
      @visit.attach_image(params[:image][0][:id]) if params[:image][0].present?
      family_members.update_all(visit_id: @visit.id)
      api_success(data: {result: true, child_id: @visit.apply_child_id}, message: '孩子家访信息提交成功！')
    else
      api_success(data: {result: false}, message: '孩子家访信息提交失败，请重试！')
    end
  end

  def get_child
    @child = ProjectSeasonApplyChild.find(params[:id])
    school = @child.school.name
    api_success(data: {school_name: school, child: @child.name})
  end

end
