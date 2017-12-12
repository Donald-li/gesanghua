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
end
