class Api::V1::ProtocolsController < Api::V1::BaseController

  def show
    if params[:type] === 'donation-protocol'
      @protocol = Page.find_by(alias: 'donation_protocol')
      api_success(data: @protocol.summary_builder)
    elsif params[:type] === 'project-apply-protocol'
      @project = Project.find(params[:id])
      api_success(data: @project.protocol_builder)
    else
      api_success(data: false)
    end
  end

end
