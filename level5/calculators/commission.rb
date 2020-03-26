module CommissionCalculator
    @@commission_percent = 3.0/10
    @@insurance_percent = 5.0/10
    @@daily_cost = 100

    def self.compute_commissions(price, days)
        raise ArgumentError, 'Price and number of days must be Numeric' unless price.is_a?(Numeric) && days.is_a?(Numeric)

        value = price * @@commission_percent
        insurance = value * @@insurance_percent
        assistance = days * @@daily_cost
        drivy = value - insurance - assistance

        {
            insurance: insurance.to_i,
            assistance: assistance.to_i,
            drivy: drivy.to_i
        }
    end

    def self.commission_percent
        @@commission_percent
    end

    def self.insurance_percent
        @@insurance_percent
    end

    def self.daily_cost
        @@daily_cost
    end
end