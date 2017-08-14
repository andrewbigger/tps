require 'forwardable'
module Tps
  class RecordSet
    extend Forwardable
    attr_reader :name, :records, :fields

    def_delegators :@records, :<<, :select,
                   :each, :first, :last, :length, :empty?

    def self.new_from_array(name, arr = [], record_obj = Record)
      fields = []
      new(
        name,
        arr.map do |record|
          record = record_obj.new(record)
          fields |= record.fields
          record
        end,
        fields
      )
    end

    def initialize(name, records = [], fields = [])
      @name = name
      @records = records
      @fields = fields
    end

    def where(query = {})
      results = @records.select do |record|
        begin
          record.match?(query)
        rescue AttributeNotFound
          false
        end
      end
      RecordSet.new(name, results)
    end
  end
end
