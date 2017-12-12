class Support::UploadsController < Support::BaseController

  def create
    klass = "Asset::#{params[:asset_type].classify}".constantize
    asset = klass.new(file: params[:file], user: current_user)
    result = asset.save
    render json: {result: result, error: asset.errors.full_messages, id: asset.try(:id), protect_token: asset.protect_token, url: asset.file.try(:url)}
  end

  def destroy
    @file_id = params[:file_id]
    asset = Asset.find(params[:id])
    @result = asset.protect_token == params[:protect_token]
    if @result
      asset.destroy
    end
  end
end
