module Tps
  module Comparitors
    def array_include?(array, search_val)
      array.any? do |item|
        string_match?(item, search_val)
      end
    end

    def string_equal?(record_val, search_val)
      record_val.to_s == search_val.to_s
    end

    def string_match?(record_val, search_val)
      !!(record_val.to_s =~ Regexp.new(search_val.to_s, true))
    end

    def val_empty?(record_val)
      record_val.empty?
    end
  end
end
