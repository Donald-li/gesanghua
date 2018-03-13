class Api::V1::ReadAppliesController < Api::V1::BaseController
  # before_action :set_apply, only: [:show]

  def create
    image_ids = params[:images].pluck(:id)
    class_ids = params[:class_ids].pluck(:id)
    classes = ProjectSeasonApplyBookshelf.where(id: class_ids)
    @apply = ProjectSeasonApply.new(
      project_id: Project.read_project.id,
      project_season_id: params[:read_apply][:season][0],
      school_id: params[:read_apply][:school_id],
      teacher_id: current_user.teacher.try(:id),
      class_number: params[:read_apply][:class_number],
      student_number: params[:read_apply][:student_number],
      contact_name: params[:read_apply][:contact_name],
      contact_phone: params[:read_apply][:contact_phone],
      address: params[:read_apply][:address],
      province: params[:read_apply][:location][0],
      city: params[:read_apply][:location][1],
      district: params[:read_apply][:location][2]
    )
    if @apply.save
      @apply.attach_images(image_ids) if image_ids.present?
      classes.update_all(project_season_apply_id: @apply.id)
      api_success(data: {result: true, apply_id: @apply.id}, message: '提交成功！')
    else
      api_success(data: {result: false}, message: '提交失败，请重试！')
    end
  end

  private
  def set_apply
    @apply = ProjectSeasonApply.find(params[:id])
  end
end
