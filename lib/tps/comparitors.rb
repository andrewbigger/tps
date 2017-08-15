module Tps
  module Comparitors
    def array_include?(array, search_val)
      array.include?(search_val)
    end

    def string_equal?(record_val, search_val)
      record_val.to_s == search_val.to_s
    end

    def string_match?(record_val, search_val)
      !!(record_val.to_s =~ Regexp.new(search_val.to_s, true))
    end
  end
end
