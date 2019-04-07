# @api private
module Blueprinter
  class NameFormatter
    def initialize
      @camelize_formatter = CamelizeFormatter.new
    end

    def format(name)
      return name if formatter.nil?

      formatter.format(name)
    end

    private

    def formatter
      case Blueprinter.configuration.key_transform
        when :camelize
          @camelize_formatter
        else
          nil
      end
    end
  end
end
