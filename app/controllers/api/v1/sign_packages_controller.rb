class Api::V1::SignPackagesController < Api::V1::BaseController

  def show
    url = params[:url] || request.referer
    url = "http://#{Settings.app_host}#{url}" unless url.start_with?('http')
    sign_package = $client.get_jssign_package(url)
    api_success(data: {signPackage: sign_package})
  rescue
    return api_success(message: '发生了错误')
  end

end
