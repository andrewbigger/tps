require 'forwardable'
module Tix
  class RecordSet
    extend Forwardable
    attr_reader :records

    def_delegators :@records, :<<, :select, :each, :first, :last, :length

    def self.new_from_array(arr = [], record_obj = Record)
      self.new(arr.map { |record| record_obj.new(record) })
    end

    def initialize(records = [])
      @records = records
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
