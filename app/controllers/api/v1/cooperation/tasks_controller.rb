class Api::V1::Cooperation::TasksController < Api::V1::BaseController

  def index
    tasks = Task.open.where.not(id: current_user.volunteer.task_volunteers.pluck(:task_id)).sorted
    tasks = tasks.where(workplace_id: params[:workplace_id]) if params[:workplace_id].present?
    tasks = tasks.where(task_category_id: params[:category_id]) if params[:category_id].present?
    tasks = tasks.page(params[:page]).per(params[:per])
    api_success(data: {tasks: tasks.map{|task| task.summary_builder}, pagination: json_pagination(tasks)})
  end

  def workplace
    places = Workplace.sorted
    api_success(data: places.map{|p| p.summary_builder})
  end

  def category
    categories = TaskCategory.sorted
    api_success(data: categories.map{|p| p.summary_builder})
  end

  def my_tasks
    volunteer = current_user.volunteer
    volunteer.update(task_state: false)
    if params[:state] == 'allTask'
      task_volunteers = volunteer.task_volunteers.sorted
    elsif params[:state] == 'applyTask'
      task_volunteers = volunteer.task_volunteers.sorted.where(state: [:submit, :reject])
    elsif params[:state] == 'toDoTask'
      task_volunteers = volunteer.task_volunteers.sorted.pass.joins(:task).where('tasks.start_time > ?', Time.now)
    elsif params[:state] == 'doingTask'
      task_volunteers = volunteer.task_volunteers.sorted.pass.joins(:task).where('tasks.start_time < ? and tasks.end_time > ?', Time.now, Time.now)
    elsif params[:state] == 'doneTask'
      task_volunteers = volunteer.task_volunteers.sorted.done
    elsif params[:state] == 'cancelTask'
      task_volunteers = volunteer.task_volunteers.sorted.where(state: [:cancel, :apply_cancel])
    end
    task_volunteers = task_volunteers.sorted.page(params[:page]).per(params[:per])
    api_success(data: {tasks: task_volunteers.map{|tv| tv.list_builder}, pagination: json_pagination(task_volunteers)})
  end

  def show
    task = Task.find(params[:id])
    api_success(data: task.detail_builder(current_user))
  end

  def apply
    task = Task.find(params[:id])
    volunteer = current_user.volunteer
    tv = TaskVolunteer.find_by(task: task, volunteer: volunteer)
    if tv.blank? || tv.reject?
      tv ||= volunteer.task_volunteers.new(task: task)
      tv.reason = params[:reason]
      tv.state = 'submit'
      if tv.save
        api_success(data: true)
      else
        api_error(message: '申请失败，请重试')
      end
    else
      api_error(message: '您已经提交申请，请耐心等待审核')
    end
  end

  def cancel
    tv = TaskVolunteer.find(params[:id])
    if tv.apply_cancel!
      api_success(message: '取消成功')
    else
      api_error(message: '取消失败')
    end
  end

  def finish
    tv = TaskVolunteer.find(params[:id])
    if tv.to_check?
      api_error(message: '您已经提交过任务成果了~')
    else
      if tv.update(achievement_comment: params[:content], state: 'to_check')
        tv.attach_images(params[:images].pluck(:id)) if params[:images].present?
        api_success(message: '成果提交成功')
      else
        api_error(message: '提交失败')
      end
    end
  end

end
