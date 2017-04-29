# rubocop:disable Style/GuardClause
class DatetimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return false unless value

    if options[:before]
      valid = prepare_comparable(options[:before], record)
      return false unless valid
      if value > valid
        record.errors[attribute] << (options[:message] || "has to be before #{valid}")
      end
    end

    if options[:after]
      valid = prepare_comparable(options[:after], record)
      return false unless valid
      if value < valid
        record.errors[attribute] << (options[:message] || "has to be after #{valid}")
      end
    end
  end

  private

  def prepare_comparable(value, record = {})
    return record[value] if value.is_a?(Symbol)
    return value.call if value.is_a?(Proc)
    raise "Not supported option type: #{value.class} use Symbol or Proc"
  end
end
