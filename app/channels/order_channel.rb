class OrderChannel < ApplicationCable::Channel
  def subscribed
    stream_from "order_#{params[:no]}"
  end
end
