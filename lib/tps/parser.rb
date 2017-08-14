require 'yajl'

module Tps
  class Parser
    class << self
      def parse(file)
        parser.parse(file)
      end

      def parser
        Yajl::Parser.new(symbolize_keys: true)
      end
    end
  end
end
