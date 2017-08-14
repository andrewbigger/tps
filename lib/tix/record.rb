module Tix
  class Record
    attr_reader :data

    def initialize(params = {})
      @data = params
    end

    def fields
      @data.keys
    end

    def get(attribute)
      raise AttributeNotFound, attribute unless @data.key?(attribute)
      @data[attribute]
    end

    def match?(query)
      query.all? do |attribute, value|
        get(attribute).to_s =~ Regexp.new(value.to_s, true)
      end
    end
  end
end
