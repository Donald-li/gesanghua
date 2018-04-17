#处理导航菜单当前位置
class MenuNav
  class << self
    def menus_nav
      return $site_menus if $site_menus
      menu_define = YAML.load_file(File.join(Rails.root, 'lib/menus.yml'))
      $site_menus = reverse_menus_nav(menu_define)
    end
  end

  private
  #返回{:controller => {:action => [key1, key2]}}
  def self.reverse_menus_nav(menus, reversed={}, parents=[])
    return reversed if menus.blank?
    menus.each do |menu, config|
      reverse_menus_nav(config['menus'], reversed, parents | [menu]) #递归
      config['actions'].each do |k,v|
        controller = (k.to_s.camelize << 'Controller').constantize
        all_actions_name = controller.action_methods - ['rescue_action_in_public','log_exception','local_request?'] #去掉几个非action的方法
        actions_name =
          if v == 'all' #全部action
          all_actions_name
        elsif  v.is_a?(Array)
          all_actions_name & v.map(&:to_s)
        elsif v.is_a?(Hash)
          v['except'] ? all_actions_name - v['except'].map(&:to_s) : all_actions_name & v['only'].map(&:to_s)
        else
          all_actions_name & [] << v
        end
        actions_name.each do |a|
          reversed[k.to_s] = {} unless reversed[k.to_s]
          reversed[k.to_s][a] = [reversed[k.to_s][a]].flatten | [menu.to_s] | parents
        end
      end if config['actions'].present?
    end
    return reversed
  end
end
