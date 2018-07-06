class Api::V1::ProtocolsController < Api::V1::BaseController

  def show
    if params[:type] === 'donation-protocol'
      @protocol = Protocol.donate_protocol.show.last
      api_success(data: @protocol.summary_builder)
    elsif params[:type] === 'project-apply-protocol'
      @protocol = Protocol.project_apply_protocol.where(project_id: params[:id]).show.last
      api_success(data: @protocol.summary_builder)
    elsif params[:type] === 'volunteer-apply-protocol'
      @protocol_intro = Protocol.volunteer_introduction.show.last
      @protocol_rule = Protocol.volunteer_rules.show.last
      api_success(data: {intro: @protocol_intro.summary_builder, rule: @protocol_rule.summary_builder})
    elsif params[:type] === 'voucher-protocol'
      @protocol = Protocol.voucher_protocol.show.last
      api_success(data: @protocol.summary_builder)
    else
      api_success(data: false)
    end
  end

end
