require './calculators/price.rb'
require './calculators/commission'
require './car.rb'
require './option'
require './action'
class Rental
    @@id = 1

    def initialize(start, finish, distance, car_data, options=[])
        @id = @@id
        @start_date = start
        @end_date = finish
        @distance = distance.to_i
        @car = Car.new(*car_data)

        if options.empty?
            @options = []
        else
            @options = options.map {|e| Option.new(e)}
        end
        @@id += 1
    end

    def to_initial_price_hash
        time_total, days = PriceCalculator.compute_total(@start_date, @end_date, @car.price_per_day)
        distance_total = @distance * @car.price_per_km
        @days = days

        {
            id: @id,
            price: time_total + distance_total,
            days: days
        }
    end

    def to_commission_price_hash
        id, price, days = to_initial_price_hash.values


        {
            id: id,
            price: price,
            commission: CommissionCalculator.compute_commissions(price, days)
        }
    end

    def to_credit_debit_hash
        usable = to_commission_price_hash

        {
            id: usable[:id],
            actions: Action.generate_action_list(usable)
        }
    end

    def to_options_hash
        usable = to_credit_debit_hash
        usable[:options] = @options.map(&:type)
        modifications = PriceCalculator.compute_options_price(@options, @days) unless @options.empty?

        unless modifications.nil?
            Action.apply_options_to_actions(modifications, usable)
        end

        usable
    end



    attr_accessor :id, :car_id, :start_date, :end_date, :distance, :days
end