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

  def can_current_entrance(path_name, action_name, roles, **params)
    @current_entrance_cards ||= EntranceGuard.entrance_cards
    can_entrance = (@current_entrance_cards[path_name][action_name].compact.uniq & roles).present?
    can_project = params[:project].present? ? current_user.project_ids.include?(params[:project].id) : true
    can_entrance && can_project
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

  # pc头像上传
  def webuploader_avatar(name, label: '上传', type: 'image', id: 'webuploader', klass: '', asset: nil)
    html = %{
      <div id="#{id}" class="avatar-upload-wrap webuploader #{klass}" data-name="#{name}" data-url="#{uploads_path}" data-type="#{type}">
        <div class="upload-body">
          <ul class="upload-list">
          }
    [asset].flatten.compact.select { |a| !a.new_record? }.each do |a|
      html << %{
                <li id="#{a.id}" class="file-item thumbnail">
      #{hidden_field_tag name, a.id}
      #{image_tag a.file.url}
                </li>
              }
    end
    html << %{
            <li class="upload-pick">
              <strong>#{label}</strong>
            </li>
          </ul>
        </div>
      </div>
    }
    html.html_safe
  end

  # pc多图片上传
  def webuploader_images(name, label: '上传', type: 'image', id: 'webuploader', klass: '', asset: nil)
    html = %{
      <div id="#{id}" class="image-upload-wrap webuploader #{klass}" data-name="#{name}" data-url="#{uploads_path}" data-type="#{type}">
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
              <p class="iconfont icon-ico-add"></p>
              <strong>#{label}</strong>
            </li>
          </ul>
        </div>
      </div>
    }
    html.html_safe
  end

  # pc图片上传
  def webuploader_image(name, label: '上传', type: 'image', id: 'webuploader', klass: '', asset: nil)
    html = %{
      <div id="#{id}" class="single-image-upload-wrap webuploader #{klass}" data-name="#{name}" data-url="#{uploads_path}" data-type="#{type}">
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
              <strong >#{label}</strong>
            </li>
          </ul>
        </div>
      </div>
    }
    html.html_safe
  end

  # 静态表单项
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

  def display_menu(name)
    name.include?(controller_name) ? "selectedli" : ""
  end

  def display_line(name)
    name.include?(controller_name) ? "leftLine" : ""
  end

  ##金钱格式化显示为 123,456,789.00
  def format_money(money, precision=0, delimiter = nil)
    return '0.00' if money.nil?
    precision = money % 1 == 0 ? 0 : 2
    number_to_currency(money, precision: precision, unit: "", separator:".", delimiter: delimiter || ",")
  end

  def hash_to_hidden_fields(hash)
    query_string = Rack::Utils.build_nested_query(hash)
    pairs        = query_string.split(Rack::Utils::DEFAULT_SEP)

    tags = pairs.map do |pair|
      key, value = pair.split('=', 2).map { |str| Rack::Utils.unescape(str) }
      hidden_field_tag(key, value)
    end

    tags.join("\n").html_safe
  end

  def management_amount(amount, rate)
    format('%.2f', amount * rate / (100 + rate))
  end

end
