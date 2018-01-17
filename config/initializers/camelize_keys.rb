Jbuilder.key_format camelize: :lower

# 重写一个Hash的方法
class Hash
  def camelize_keys!
    self.deep_transform_keys! { |key| key.to_s.camelize(:lower) }
  end
end
