# @api private
class Blueprinter::Field
  attr_reader :method, :name, :extractor, :options, :blueprint
  def initialize(method, name, extractor, blueprint, options = {})
    @method = method
    @name = format_name(name)
    @extractor = extractor
    @blueprint = blueprint
    @options = options
  end

  def format_name(name)
    config = Blueprinter.configuration

    return name unless config.camelize_keys

    camelize name
  end

  def camelize(name)
    string = name.to_s.sub(/^(?:(?=\b|[A-Z_])|\w)/) { $&.downcase }
    string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
  end

  def extract(object, local_options)
    extractor.extract(method, object, local_options, options)
  end

  def skip?(object, local_options)
    return true if if_callable && !if_callable.call(object, local_options)
    unless_callable && unless_callable.call(object, local_options)
  end

  private

  def if_callable
    return @if_callable if defined?(@if_callable)
    @if_callable = callable_from(:if)
  end

  def unless_callable
    return @unless_callable if defined?(@unless_callable)
    @unless_callable = callable_from(:unless)
  end

  def callable_from(condition)
    config = Blueprinter.configuration

    # Use field-level callable, or when not defined, try global callable
    tmp = if options.key?(condition)
      options.fetch(condition)
    elsif config.valid_callable?(condition)
      config.public_send(condition)
    end

    return false unless tmp

    case tmp
    when Proc then tmp
    when Symbol then blueprint.method(tmp)
    else
      raise ArgumentError, "#{tmp.class} is passed to :#{condition}"
    end
  end
end
