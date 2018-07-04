class AuditHelper
  def self.event_name(event)
    case event
    when 'create'
      '添加'
    when 'update'
      '修改'
    when 'destroy'
      '删除'
    end
  end

  def self.event_types
    [
      ['添加', 'create'],
      ['修改', 'update'],
      ['删除', 'destroy']
    ]
  end

  def self.item_types
    [
      ['用户', 'User'],
      ['学校', 'School'],
      ['老师', 'Teacher'],
      ['项目', 'Project'],
      ['项目批次', 'ProjectSeason'],
      ['申请', 'ProjectSeasonApply'],
      ['申请孩子','ProjectSeasonApplyChild'],
      ['发放批次','GrantBatch'],
      ['孩子发放', 'GshChildGrant'],
      ['格桑花孩子', 'GshChild'],
      ['申请书架', 'ProjectSeasonApplyBookshelf'],
      ['申请补书', 'BookshelfSupplement'],
      ['探索营', 'Camp'],
      ['探索营概算', 'CampDocumentEstimate'],
      ['探索营预算或决算', 'CampDocumentFinance'],
      ['探索营志愿者', 'CampDocumentVolunteer'],
      ['探索营总结', 'CampDocumentSummary'],
      ['探索营资源', 'CampProjectResource'],
      ['志愿者', 'Volunteer'],
      ['活动', 'Campaign'],
      ['活动报名表', 'CampaignEnlist'],
      ['收入记录', 'IncomeRecord'],
      ['支出记录', 'ExpenditureRecord']
  ]
  end

  def self.item_name(name)
    self.item_types.detect{|t|t.second == name}.try(:first)
  end

  def self.display_name(audit)
    attributes = audit.reify.try(:attributes) || audit.next.try(:reify).try(:attributes) || audit.item.try(:attributes) || {}
    audit.item.try(:apply_name) || audit.item.try(:bookshelf).try(:classname) || attributes['nickname'] || attributes['name'] || attributes['title'] ||
    attributes['bind_no'] || attributes['batch_no'] || attributes['phone'] || attributes['classname']
  end

  def self.attr_name(item_type, attr)
    key = "audit.#{item_type.underscore}.#{attr}"
    I18n.t(key)
  end

  def self.attr_value(audit, attr, value)
    return '' if value.blank?
    case attr
    when 'state', 'approve_state', 'apply_type', 'code_type', 'show_state', 'execute_state', 'read_state', 'pair_state', 'gender', 'nation',
       'level', 'grade', 'semester', 'kind', 'audit_state', 'inventory_state', 'accept_feedback_state', 'feedback_format', 'apply_kind', 'job_state',
        'internship_state', 'phone_verify', 'use_nickname', 'voucher_state'
      klass = audit.item_type.constantize
      klass.enum_name(attr.pluralize, value)
    when 'province', 'city', 'district'
      ChinaCity.get(value).to_s
    when 'form'
      project = audit.item.try(:project)
      if project.present?
        form = project.form_submit(value)
        a = ''
        form.each do |item|
          a += item.first + ': ' + item.second + "\n"
        end
      end
      a
    when /_id$/
      item = audit.item
      return unless item
      asso = item.send(attr.gsub('_id', ''))
      asso && (asso.attributes['name'] || asso.attributes['nickname'] || asso.attributes['classname'] || asso.try(:apply_name))
    when /_at$/
      I18n.localize(value)
    when  'camp_start_time', 'start_time', 'end_time', 'sign_up_end_time', 'sign_up_start_time', 'income_time', 'expended_at'
      I18n.localize(value)
    when 'content', 'protocol', 'describe', 'experience', 'remark'
      value.html_safe
    else
      value
    end
  end

end
