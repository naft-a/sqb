module SQB
  class WhereDSL

    attr_reader :hash

    def initialize
      @hash = {}
    end

    def method_missing(name, value = nil)
      if name =~ /(.*)\=\z/
        attribute_name = $1
        @hash[attribute_name.to_sym] ||= {}
        @hash[attribute_name.to_sym][:equal] = value
      else
        @hash[name.to_sym] ||= {}
        attribute = PositiveAttribute.new(name.to_sym, @hash)
      end
    end

    class Attribute

      def initialize(attribute_name, hash)
        @attribute_name = attribute_name
        @hash = hash
      end

    end

    class PositiveAttribute < Attribute
      def =~(value)
        @hash[@attribute_name][:like] = value
      end
      alias_method :like, :=~

      def <(value)
        @hash[@attribute_name][:less_than] = value
      end
      alias_method :less_than, :<

      def <=(value)
        @hash[@attribute_name][:less_than_or_equal_to] = value
      end
      alias_method :less_than_or_equal_to, :<=

      def >(value)
        @hash[@attribute_name][:greater_than] = value
      end
      alias_method :greater_than, :>

      def >=(value)
        @hash[@attribute_name][:greater_than_or_equal_to] = value
      end
      alias_method :greater_than_or_equal_to, :>=

      def includes(*values)
        @hash[@attribute_name][:in] = values
      end
      alias_method :in, :includes

      def not
        NegativeAttribute.new(@attribute_name, @hash)
      end
      alias_method :does_not, :not

      def not=(value)
        @hash[@attribute_name][:not_equal] = value
      end

    end

    class NegativeAttribute < Attribute
      def =~(value)
        @hash[@attribute_name][:not_like] = value
      end
      alias_method :like, :=~

      def includes(*values)
        @hash[@attribute_name][:not_in] = values
      end
      alias_method :in, :includes
    end

  end
end
