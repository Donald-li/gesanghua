class UpdatePriorityChannel < ApplicationCable::Channel
  def subscribed
    stream_from "update_priority_#{params[:id]}"
  end
end
