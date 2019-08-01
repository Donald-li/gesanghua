class BatchNoticeChannel < ApplicationCable::Channel
  def subscribed
    stream_from "batch_notice_#{params[:id]}"
  end
end
