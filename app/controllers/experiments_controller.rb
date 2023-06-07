class ExperimentsController < ApplicationController
  def index
    return render json: { error: { message: "Device-Token header is empty" } }, status: :bad_request if device_id.blank?

    device = ExperimentsAssigner.new(device_id).call

    render json: device, serializer: DeviceSerializer
  end

  private

  def device_id
    request.headers["Device-Token"]
  end
end
