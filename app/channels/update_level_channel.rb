class UpdateLevelChannel < ApplicationCable::Channel
  def subscribed
    stream_from "update_level_#{params[:id]}"
  end
end
