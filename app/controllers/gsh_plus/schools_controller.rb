class GshPlus::SchoolsController < GshPlus::BaseController
  before_action :set_user
  before_action :set_school, only: [:edit, :update]

  layout 'gsh_plus'

  def new
    @school = School.new(creater: current_user)
  end

  def edit

  end

  def create
    @school = School.new(school_params)
    @school.creater_id = @user.id
    respond_to do |format|
      if @school.save
        @school.attach_card_image(params[:card_image_id])
        @school.attach_certificate_image(params[:certificate_image_id])
        format.html { redirect_to gsh_plus_root_path, notice: '学校申请已提交。' }
      else
        flash[:notice] = @school.errors.full_messages
        format.html { render :new, notice: @school.errors.full_messages }
      end
    end
  end

  def update
    respond_to do |format|
      if @school.update(school_params.merge(approve_state: 'submit'))
        @school.attach_card_image(params[:card_image_id])
        @school.attach_certificate_image(params[:certificate_image_id])
        format.html { redirect_to gsh_plus_root_path, notice: '学校申请已提交。' }
      else
        flash[:notice] = @school.errors.full_messages
        format.html { render :edit, notice: @school.errors.full_messages }
      end
    end
  end

  private

  def school_params
    params.require(:school).permit!
  end

  def set_user
    @user = current_user
  end

  def set_school
    @school = School.find(params[:id])
  end
end
