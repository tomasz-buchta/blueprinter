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
      @camelize_formatter if Blueprinter.configuration.camelize_keys
    end
  end
end
