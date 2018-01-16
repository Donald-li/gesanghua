class Admin::SchoolAppliesController < Admin::BaseController
  before_action :set_school_apply, only: [:edit, :update, :new_audit, :edit_audti]

  def index
    @search = School.can_check.sorted.ransack(params[:q])
    scope = @search.result
    @school_applies = scope.page(params[:page])
  end

  def new
    @school_apply = School.new
  end

  def edit
    @audit = @school_apply.audits.last
    @new_audit = @school_apply.audits.build
  end

  def create
    @school_apply = School.new(school_apply_params)
    @school_apply.audits.build
    respond_to do |format|
      if @school_apply.save
        @school_apply.attach_images(params[:image_ids])
        format.html { redirect_to admin_school_applies_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @school_apply.update(school_apply_params)
        @school_apply.attach_images(params[:image_ids])
        format.html { redirect_to admin_school_applies_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @school.destroy
    respond_to do |format|
      format.html { redirect_to admin_school_applies_path, notice: '删除成功。' }
    end
  end

  # def new_audit
  #   @audit = @school_apply.audits.build
  # end

  def create_audit
    @school_apply = School.find(params[:audit][:school_apply_id])
    @new_audit = @school_apply.audits.build(state: params[:audit][:state], comment: params[:audit][:comment], user_id: current_user.id)
    respond_to do |format|
      if @new_audit.save
        # if @audit.pass? && @school_apply.gsh_child.blank?
        #   @school_apply.build_gsh_child(name: @school_apply.name, phone: @school_apply.phone, idcard: @school_apply.id_card, province: @school_apply.province, city: @school_apply.city, district: @school_apply.district)
        # end
        @school_apply.approve_state = params[:audit][:state]
        @school_apply.save(validate: false)
        format.js
      else
        format.html { render :new_audit }
      end
    end
  end

  def update_audit
    @school_apply = School.find(params[:audit][:school_apply_id])
    @audit = @school_apply.audits.last
    respond_to do |format|
      if @audit.update(state: params[:audit][:state], comment: params[:audit][:comment], user_id: current_user.id)
        @school_apply.approve_state = params[:audit][:state]
        @school_apply.save(validate: false)
        format.js
      else
        format.html { render :edit }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school_apply
      @school_apply = School.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def school_apply_params
      params.require(:school).permit!
    end
end
