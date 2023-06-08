module Balancer
  def self.arrange!(current_percentages, initial_percentages)
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