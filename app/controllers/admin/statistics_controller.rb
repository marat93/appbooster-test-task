module Admin
  class StatisticsController < ApplicationController
    def show
      statistics = AssignedExperiment.group(:experiment_name, :experiment_option).count(:experiment_option)

      render json: statistics.transform_keys { |key| key.join(" | ") }
    end
  end
end
