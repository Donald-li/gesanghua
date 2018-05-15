class Api::V1::AppliesController < Api::V1::BaseController
  before_action :set_apply, only: [:show, :complaint]

  def index
    @book_applies = ProjectSeasonApply.where(project: Project.read_project).pass.show.sorted
    @book_applies = @book_applies.where(school_city: params[:city]) if params[:city].present?
    @book_applies = @book_applies.where(school_district: params[:district]) if params[:district].present?
    @book_applies = @book_applies.page(params[:page]).per(params[:per])
    api_success(data: {read_list: @book_applies.map{|item| item.summary_builder if item.present?}, pagination: json_pagination(@book_applies)})
  end

  def show
    api_error(message: '无效项目') && return unless @apply

    if @apply.project.alias == 'read' # 悦读
      api_success(data: @apply.read_detail_builder)
    else
      api_success(data: @apply.goods_detail_builder)
    end
  end

  def complaint
    api_error(message: '无效页面') && return unless @apply
    if SmsCode.valid_code?(mobile: complaint_params[:contact_phone], code: params[:code], kind: 'verify_profile', write_verified: true)
      complaint = Complaint.find_by(contact_phone: complaint_params[:contact_phone], owner: @apply, user: current_user)
      if complaint.present?
        api_success(message: '您已经提交过举报信息', data: false)
      else
        @complaint = Complaint.new(complaint_params.merge(user: current_user))
        @complaint.owner = @apply
        if @complaint.save
          @complaint.attach_images(params[:images].map{|image| image[:id]}) if params[:images].present?
          api_success(message: '举报成功，管理员会尽快处理', data: true)
        else
          api_success(message: '提交失败，请重试', data: false)
        end
      end
    else
      api_error(message: '验证码错误')
    end
  end

  private
  def set_apply
    @apply = ProjectSeasonApply.find(params[:id])
  end

  def complaint_params
    params.require(:complaint).permit!
  end

end
