require 'date'

module PriceCalculator
    @@ten_percent_interval = 1..3
    @@forty_percent_interval = 4..9
    @@fifty_percent_interval = 10..1000

    def self.string_to_date(str)
        Date.new(*str.split('-').map(&:to_i))
    end

    def self.compute_total(start_date, end_date, price)
        start_date_obj = string_to_date(start_date)
        end_date_obj = string_to_date(end_date)

        total_days = (end_date_obj - start_date_obj).to_i + 1

        [recursive_compute(total_days, price), total_days]
    end

    def self.recursive_compute(remaining_days, price_per_day, sum = 0, days_passed = 0)
        raise ArgumentError, 'Days and price need to be numeric' unless remaining_days.is_a?(Numeric) && price_per_day.is_a?(Numeric)
        return sum if remaining_days.zero?
    
        case days_passed
        when 0
            sum += price_per_day
        when @@ten_percent_interval
            sum += price_per_day * 9/10
        when @@forty_percent_interval
            sum += price_per_day * 7/10
        when @@fifty_percent_interval
            sum += price_per_day * 1/2
        end
    
        recursive_compute(remaining_days-1, price_per_day, sum, days_passed+1)
    end

    def self.compute_options_price(options, days)
        result = []
        options.each do |option|
            modifier, target = option.compute_modifier_and_target
            result << [
                modifier * days,
                target
            ]
        end

        result
    end
end