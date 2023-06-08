class ExperimentsController < ApplicationController
  def index
    if device_id.blank?
      return render json: { error: { message: "Device-Token header is empty" } }, status: :bad_request
    end

    device = ExperimentsAssigner.new(device_id).call

    render json: device
  end

  private

  def device_id
    request.headers["Device-Token"]
  end
end
