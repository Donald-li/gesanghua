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

  def self.item_types
    [
      ['管理员', 'Administrator'],
      ['商家', 'Company'],
      ['商品', 'Product'],
      ['二维码预发码', 'QrcodeAdvance'],
      ['申请码或分配码', 'QrcodeApply'],
      ['绑定二维码','QrcodeBind']
  ]
  end

  def self.item_name(name)
    self.item_types.detect{|t|t.second == name}.try(:first)
  end

  def self.display_name(audit)
    attributes = audit.reify.try(:attributes) || audit.next.try(:reify).try(:attributes) || audit.item.try(:attributes) || {}
    attributes['nickname'] || attributes['name'] || attributes['title'] || attributes['code'] ||
    attributes['bind_no'] || attributes['batch_no'] || attributes['phone']
  end

  def self.attr_name(item_type, attr)
    key = "audit.#{item_type.underscore}.#{attr}"
    I18n.t(key)
  end

  def self.attr_value(audit, attr, value)
    return '' if value.blank?
    case attr
    when 'state', 'approve_state', 'apply_type', 'code_type'
      klass = audit.item_type.constantize
      klass.enum_name(attr.pluralize, value)
    when /_id$/
      item = audit.item
      return unless item
      asso = item.send(attr.gsub('_id', ''))
      asso && (asso.attributes['name'] || asso.attributes['batch_no'])
    when /_at$/
      I18n.localize(value)
    when 'content'
      value.html_safe
    else
      value
    end
  end

end
