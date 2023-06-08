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

    load_new_experiments(experiments)

    experiments.each_key do |experiment|
      current_values = $redis.hgetall(experiment)
      highest_key = arrange_percentages!(current_values, experiments[experiment])
      $redis.hset(experiment, current_values)
      device.assigned_experiments.new(experiment_name: experiment, experiment_option: highest_key)
    end

    device.save!
  end

  def load_new_experiments(experiments)
    experiments.each do |experiment, values|
      $redis.hset(experiment, values) if $redis.exists(experiment).zero?
    end
  end

  def arrange_percentages!(current_percentages, initial_percentages)
    highest_percentage_key = current_percentages.keys.first

    current_percentages.each do |key, percentage|
      highest_percentage_key = key if percentage.to_f >= current_percentages[highest_percentage_key].to_f
    end

    current_percentages[highest_percentage_key] = current_percentages[highest_percentage_key].to_f - 100

    current_percentages.each do |key, _percentage|
      current_percentages[key] = current_percentages[key].to_f + initial_percentages[key.to_sym]
    end

    highest_percentage_key
  end
end
