module Tps
  class Record
    include Tps::Comparators
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
        compare(attribute, value)
      end
    end

    def compare(attribute, value)
      return val_empty?(get(attribute)) if value == '\empty'
      send("#{attribute}_compare", value)
    rescue NoMethodError
      string_match?(get(attribute), value)
    end
  end
end
