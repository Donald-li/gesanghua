class Api::V1::FamilyMembersController < Api::V1::BaseController

  def index
    visit = Visit.find(params[:visit_id])
    family_members = visit.members
    api_success(data: {family_members: family_members.map { |r| r.detail_builder }})
  end

  def create
    @family_member = FamilyMember.new(
      name: params[:name],
      age: params[:age],
      relationship: params[:relationship],
      profession: params[:profession],
      health_condition: params[:health_condition],
      job_condition: params[:job_condition]
    )
    if @family_member.save
      api_success(data: {result: true, id: @family_member.id}, message: '提交成功！')
    else
      api_success(data: {result: false}, message: '提交失败，请重试！')
    end
  end

  def edit
    @family_member = FamilyMember.find(params[:id])
    api_success(data: {family_member: @family_member.detail_builder})
  end

  def update
    @family_member = FamilyMember.find(params[:id])
    if @family_member.update(
        name: params[:name],
        age: params[:age],
        relationship: params[:relationship],
        profession: params[:profession],
        health_condition: params[:health_condition],
        job_condition: params[:job_condition]
      )
      api_success(data: {result: true}, message: '提交成功！')
    else
      api_success(data: {result: false}, message: '提交失败，请重试！')
    end
  end

end
