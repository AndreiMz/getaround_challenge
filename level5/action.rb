module Action
    @@action_targets = [
        ['driver', 'debit'],
        ['owner', 'credit'],
        ['insurance', 'credit'],
        ['assistance', 'credit'],
        ['drivy', 'credit']
    ]

    def self.generate_action_list(rental)
        data = extract_values(rental)

        @@action_targets.each_with_index.inject([]) do |result, ((who, type), idx)|
            result << {
                who: who,
                type: type,
                amount: data[idx]
            }
        end
    end

    # order of values extracted is the same as described by @@action_targets

    def self.extract_values(rental)
        total = rental[:price]
        commission = (total * CommissionCalculator.commission_percent).to_i
        [
            total,
            total - commission,
            rental[:commission][:insurance],
            rental[:commission][:assistance],
            rental[:commission][:drivy]
        ]
    end

    def self.apply_options_to_actions(options, data)
        options.each do |value, target|
            idx = data[:actions].index {|a| a[:who] == target}
            data[:actions][idx][:amount] = data[:actions][idx][:amount] + value
            unless target == 'driver'
                data[:actions][0][:amount] = data[:actions][0][:amount] + value
            end
        end
    end
end
