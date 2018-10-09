#处理导航菜单当前位置
class EntranceGuard
  class << self
    def entrance_cards
      return $access_card if $access_card
      cards = YAML.load_file(File.join(Rails.root, 'lib/entrance_guard.yml'))
      $access_card = reverse_entrance_cards(cards)
    end
  end

  private
  #返回{:controller => {:action => [key1, key2]}}
  def self.reverse_entrance_cards(menus, reversed={}, parents=[])
    return reversed if menus.blank?
    menus.each do |menu, config|
      reverse_entrance_cards(config['menus'], reversed, parents | [menu]) if config['menus'].present? #递归
      config['actions'].each do |key, value|
        controller = (key.to_s.camelize << 'Controller').constantize
        all_actions_name = controller.action_methods - ['rescue_action_in_public', 'log_exception', 'local_request?'] #去掉几个非action的方法
        actions_name =
            if value == 'all' #全部action
              all_actions_name
            elsif value.is_a?(Array)
              all_actions_name & value.map(&:to_s)
            elsif value.is_a?(Hash)
              value['except'] ? all_actions_name - value['except'].map(&:to_s) : all_actions_name & value['only'].map(&:to_s)
            else
              all_actions_name & [] << value
            end
        actions_name.each do |a|
          reversed[key.to_s] = {} unless reversed[key.to_s]
          reversed[key.to_s][a] = [reversed[key.to_s][a]].flatten | [menu.to_s] | parents | ['superadmin', 'admin']
        end
      end if config['actions'].present?
    end
    return reversed
  end
end
