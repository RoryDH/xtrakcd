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
      return if val.nil?
      
      convert = self.class.typed_stores[store_attribute][key]
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

class Time
  NEXT_OPTS = [:year, :month, :day, :hour, :min, :sec] # and :wday
  AS_NEXT_OPTS = [:years, :months, :days, :hours, :minutes, :seconds]
  def next_where(opts)
    opts[:day] ||= 1 if opts[:month]
    opts[:hour] ||= 0 if opts[:day] || opts[:month]
    changed = self.change(opts)
    return changed if changed > self

    highest_attr_index = NEXT_OPTS.index((NEXT_OPTS & opts.keys).first) - 1
    overflow_attr = AS_NEXT_OPTS[highest_attr_index]
    changed.advance(overflow_attr => 1)
  end
end
