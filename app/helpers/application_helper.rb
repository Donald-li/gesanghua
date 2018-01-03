module ApplicationHelper
  # 是否当前路径
  def current_nav_class(key, options = {})
    options.reverse_merge!(:current => 'active', :not_current => '')
    is_current_nav?(key, options) ? options[:current] : options[:not_current]
  end

  def is_current_nav?(key, options = {})
    @current_nav_keys ||= MenuNav.menus_nav[controller.controller_path].try('[]', action_name) || []
    is_current = @current_nav_keys.include?(key.to_s)
    if options[:if]
      is_current = is_current && options[:if].call
    end
    is_current
  end

  def paginate_info(paginated)
    "显示 #{start = (paginated.current_page - 1) * paginated.limit_value + 1} - #{start + paginated.count - 1} 条，共 #{paginated.total_count} 条"
  end

  # pc上传组件
  def webuploader_tag(name, label: '上传', type: 'image', id: 'webuploader', klass: '', asset: nil)
    html = %{
      <div id="#{id}" class="upload-wrap webuploader #{klass}" data-name="#{name}" data-url="#{uploads_path}" data-type="#{type}">
        <div class="upload-body">
          <ul class="upload-list">
          }
    [asset].flatten.compact.select { |a| !a.new_record? }.each do |a|
      html << %{
                <li id="#{a.id}" class="file-item thumbnail">
                  #{link_to 'x', upload_path(a, file_id: a.id, protect_token: a.protect_token), method: :delete, remote: true, class: 'delete'}
      #{hidden_field_tag name, a.id}
      #{image_tag a.file.url}
                </li>
              }
    end
    html << %{
            <li class="upload-pick">
              <span><i class="iconfont icon-plus2"></i></span>
              <strong>#{label}</strong>
            </li>
          </ul>
        </div>
      </div>
    }
    html.html_safe
  end

  # pc上传附件
  def webuploader_file(name, label: '上传', type: 'image', id: 'webuploader', klass: 'webuploader', asset: nil)
    html = %{
      <div id="#{id}" class="file-upload-wrap #{klass}" data-name="#{name}" data-url="#{uploads_path}" data-type="#{type}">
        <div class="upload-body">
            <a class="upload-pick">
              <strong>#{label}</strong>
            </a>
          <ul class="upload-list">
          }
    [asset].flatten.compact.select {|a| !a.new_record?}.each do |a|
      html << %{
                <li id="#{a.id}" class="file-item">
                  #{link_to 'x', upload_path(a, file_id: a.id, protect_token: a.protect_token), method: :delete, remote: true, class: 'delete'}
      #{hidden_field_tag name, a.id}
      #{image_tag a.file.url}
                </li>
              }
    end
    html << %{
          </ul>
        </div>
      </div>
    }
    html.html_safe
  end

  def static_form_control(label, content)
    %{
    <div class="form-group">
      <label class="control-label col-md-2">#{label}</label>
      <div class="form-group">
      <div class="input-group">
        <p class="form-control-static" style="padding-left: 20px;">
          #{content}
        </p>
      </div>
      </div>
    </div>
    }.html_safe
  end

end
