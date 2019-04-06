module Blueprinter
  class CamelizeFormatter
    def format(name)
      string = name.to_s.sub(/^(?:(?=\b|[A-Z_])|\w)/) { $&.downcase }
      string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
    end
  end
end
