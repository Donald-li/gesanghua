class SnakeCaseParameters
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    ##ckeditor中的图片上传不经过此参数过滤
    if request.path != "/ckeditor/pictures"
      request.request_parameters.deep_transform_keys!(&:underscore)
      request.query_parameters.deep_transform_keys!(&:underscore)
    end
    @app.call(env)
  end
end
