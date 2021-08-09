module Convertable
  extend ActiveSupport::Concern

  module ClassMethods
    ##
    # Public: Converts the value added to any field to respective kind,
    #         preserving the right places of values.
    #
    # Examples
    #
    #   converts :value, to: :decimal
    #   # > Object.new.value = '10,20'
    #   # => 10.20
    #
    # Returns the converted value.
    def converts(field, to:)
      case to
      when :decimal
        define_method("#{field}=") { |value| self[field] = convert_input_to_decimal(value) }
      else
        raise "#{to} wasn't recognized as valid format."
      end
    end
  end

  private

  def convert_input_to_decimal(value)
    value = value.gsub(I18n.t('number.currency.format.unity'), '')
    delimiter = I18n.t('number.currency.format.delimiter')
    separator = I18n.t('number.currency.format.separator')

    find = /[0-9#{delimiter}]+#{separator}[0-9]+/
    value.to_s =~ find ? value.gsub(/[#{delimiter}#{separator}]/, delimiter => '', separator => '.') : value
  end
end
