class ExperimentsAssigner
    def initialize(device_id)
        @device_id = device_id
    end

    def call
        experiments = Rails.application.config_for(:experiments).with_indifferent_access
        experiments.each do |experiment, values|
            $redis.hset(experiment, values) if $redis.exists(experiment).zero?
        end

        device = Device.find_or_create_by!(device_id: @device_id)

        device_experiment_names = device.assigned_experiments.map(&:experiment_name)
        new_assigned_experiments = []

        experiments.keys.difference(device_experiment_names).each do |experiment|
            current_values = $redis.hgetall(experiment)
            highest_key = arrange_percentages!(current_values, experiments[experiment])
            $redis.hset(experiment, current_values)
            new_assigned_experiments << { experiment_name: experiment, experiment_option: highest_key }
        end

        device.assigned_experiments.create!(new_assigned_experiments)

        device
    end

    private

    def arrange_percentages!(current_percentages, initial_percentages)
        highest_percentage_key = current_percentages.keys.first

        current_percentages.each do |key, percentage|
            if percentage.to_f >= current_percentages[highest_percentage_key].to_f
                highest_percentage_key = key
            end
        end

        current_percentages[highest_percentage_key] = current_percentages[highest_percentage_key].to_f - 100

        current_percentages.each do |key, percentage|
            current_percentages[key] = current_percentages[key].to_f + initial_percentages[key.to_sym]
        end

        highest_percentage_key
    end
end
