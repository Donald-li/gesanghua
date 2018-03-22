class Api::Common::UploadsController < Api::V1::BaseController
  def create
    klass = "Asset::#{params[:asset_type].classify}".constantize
    @asset = klass.new(file: params[:file])
    result = @asset.save
    api_error(message: @asset.errors.full_messages) and return unless result
    api_success(data: @asset.summary_builder)
  end

  def destroy
    @file_id = params[:file_id]
    asset = Asset.find(params[:id])
    api_error(message: '没有权限') and return unless asset.protect_token == params[:protect_token]
    asset.destroy
    api_success
  end
end
