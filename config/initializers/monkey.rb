module ActiveRecord
  module Store
    module ClassMethods
      def typed_store_accessor(store_attribute, attrs)
        store_accessor(store_attribute, attrs.keys.map(&:to_s))
        self.typed_stores = {}
        self.typed_stores[store_attribute] = attrs
      end

      def typed_stores
        @@typed_stores
      end

      def typed_stores=(v)
        @@typed_stores = v
      end
    end

  protected
    def read_store_attribute(store_attribute, key)
      accessor = store_accessor_for(store_attribute)
      val = accessor.read(self, store_attribute, key)
      convert = self.class.typed_stores[store_attribute][key]

      return if val.nil?
      if convert.is_a?(Proc)
        convert.call(val)
      elsif convert.is_a?(Symbol)
        val.send(convert)
      else
        val
      end
    end
  end
end

# class String
#   def try_i
#     i = self.to_i
#     self == i.to_s ? i : self
#   end
# end
