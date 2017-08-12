require 'yajl'

module Tix
  class Parser
    def self.parse(file)
      parser.parse(file)
    end
    
    def self.parser
      Yajl::Parser.new(symbolize_keys: true)
    end
  end
end
