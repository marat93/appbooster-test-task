class ExperimentsAssigner
  def initialize(device_id)
    @device_id = device_id
  end

  def call
    Device.find_or_create_by!(device_id: @device_id) do |device|
      assign_experiments(device)
    end
  end

  private

  def assign_experiments(device)
    experiments = Rails.application.config_for(:experiments).with_indifferent_access

    save_new_experiments(experiments)

    experiments.each_key do |experiment|
      current_values = $redis.hgetall(experiment)
      highest_key = Balancer.arrange!(current_values, experiments[experiment])
      $redis.hset(experiment, current_values)
      device.assigned_experiments.new(experiment_name: experiment, experiment_option: highest_key)
    end

    device.save!
  end

  def save_new_experiments(experiments)
    experiments.each do |experiment, values|
      $redis.hset(experiment, values) if $redis.exists(experiment).zero?
    end
  end
end
