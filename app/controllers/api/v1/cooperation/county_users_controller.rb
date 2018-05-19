class Api::V1::Cooperation::CountyUsersController < Api::V1::BaseController

  def index
    api_success(data: {county_user_info: current_user.county_user.summary_builder})
  end

  def update
    province = params[:location][0] if params[:location].present?
    city = params[:location][1] if params[:location].present?
    district = params[:location][2] if params[:location].present?
    county_user = current_user.county_user
    if county_user.update(name: params[:name], province: province, city: city, district: district, unit_name: params[:unit_name])
      current_user.attach_avatar(params[:user_avatar][:id]) if params[:user_avatar].present?
      api_success(data: true, message: '修改成功')
    else
      api_success(data: false, message: county_user.errors.full_messages.first)
    end
  end

  def get_projects
    scope = Project.all
    projects = scope.sorted.visible
    api_success(data: projects.map{|p| p.summary_builder})
  end

  def get_applies
    schools = School.where(district: current_user.county_user.district).sorted
    if params[:alias].present?
      project = Project.find_by(alias: params[:alias])
      if project == Project.pair_project
        if params[:kind] == 'executing'
          applies = ProjectSeasonApply.where(project_id: project.id, school: schools, pair_state: ['waiting_upload', 'waiting_check']).includes(:season).sorted.page(params[:page]).per(params[:per])
        elsif params[:kind] == 'done'
          applies = ProjectSeasonApply.where(project_id: project.id, school: schools, pair_state: 'pair_complete').includes(:season).sorted.page(params[:page]).per(params[:per])
        end
        api_success(data: {applies: applies.map { |r| r.pair_applies_builder }, pagination: json_pagination(applies)})
      elsif project == Project.read_project
        if params[:kind] == 'executing'
          applies = ProjectSeasonApply.where(project_id: project.id, school: schools, read_state: 'read_executing').includes(:season).sorted.page(params[:page]).per(params[:per])
        elsif params[:kind] == 'done'
          applies = ProjectSeasonApply.where(project_id: project.id, school: schools, read_state: 'read_done').includes(:season).sorted.page(params[:page]).per(params[:per])
        end
        api_success(data: {applies: applies.map { |r| r.read_applies_builder }, pagination: json_pagination(applies)})
      elsif project == Project.movie_project
        if params[:kind] == 'executing'
          applies = ProjectSeasonApply.where(project_id: project.id, school: schools, audit_state: ['submit', 'reject']).includes(:season).sorted.page(params[:page]).per(params[:per])
        elsif params[:kind] == 'done'
          applies = ProjectSeasonApply.where(project_id: project.id, school: schools, audit_state: 'pass').includes(:season).sorted.page(params[:page]).per(params[:per])
        end
        api_success(data: {applies: applies.map { |r| r.movie_apply_builder }, pagination: json_pagination(applies)})
      elsif project == Project.movie_care_project
        if params[:kind] == 'executing'
          applies = ProjectSeasonApply.where(project_id: project.id, school: schools, audit_state: ['submit', 'reject']).includes(:season).sorted.page(params[:page]).per(params[:per])
        elsif params[:kind] == 'done'
          applies = ProjectSeasonApply.where(project_id: project.id, school: schools, audit_state: 'pass').includes(:season).sorted.page(params[:page]).per(params[:per])
        end
        api_success(data: {applies: applies.map { |r| r.movie_care_apply_builder }, pagination: json_pagination(applies)})
      elsif project == Project.camp_project
        if params[:kind] == 'executing'
          applies = ProjectSeasonApplyCamp.where(school: schools, execute_state: ['to_submit', 'to_approve']).includes(:apply).sorted.page(params[:page]).per(params[:per])
        elsif params[:kind] == 'done'
          applies = ProjectSeasonApplyCamp.where(school: schools, execute_state: 'approved').includes(:apply).sorted.page(params[:page]).per(params[:per])
        end
        api_success(data: {applies: applies.map { |r| r.camp_applies_builder }, pagination: json_pagination(applies)})
      end
    elsif params[:pid].present?
      project = Project.find(params[:pid])
      if params[:kind] == 'executing'
        applies = ProjectSeasonApply.where(project_id: project.id, school: schools, execute_state: ['raising', 'to_delivery', 'to_receive', 'to_feedback', 'feedbacked']).includes(:season).sorted.page(params[:page]).per(params[:per])
      elsif params[:kind] == 'done'
        applies = ProjectSeasonApply.where(project_id: project.id, school: schools, execute_state: 'done').includes(:season).sorted.page(params[:page]).per(params[:per])
      end
      api_success(data: {applies: applies.map { |r| r.goods_apply_builder }, pagination: json_pagination(applies)})
    end
  end

  def get_school_list
    schools = School.where(district: current_user.county_user.district).sorted.page(params[:page]).per(params[:per])
    api_success(data: {schools: schools.map{ |s| s.detail_builder }, pagination: json_pagination(schools)})
  end

  def get_exception_records
    school_ids = School.where(district: current_user.county_user.district).ids
    apply_ids = ProjectSeasonApply.where(school: school_ids).ids
    exception_records = ExceptionRecord.where(owner: apply_ids).sorted.page(params[:page]).per(params[:per])
    api_success(data: {exception_records: exception_records.map{ |s| s.summary_builder }, pagination: json_pagination(exception_records)})
  end

end
