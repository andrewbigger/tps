require 'forwardable'
module Tix
  class RecordSet
    extend Forwardable
    attr_reader :set_name, :records, :fields

    def_delegators :@records, :<<, :select, :each, :first, :last, :length

    def self.new_from_array(name, arr = [], record_obj = Record)
      fields = []
      new(
        name,
        arr.map do |record|
          record = record_obj.new(record)
          fields += record.fields
          record
        end,
        fields
      )
    end

    def initialize(set_name, records = [], fields = [])
      @set_name = set_name
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
      RecordSet.new(results)
    end
  end
end
