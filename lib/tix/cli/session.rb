module Tix
  module CLI
    class Session
      attr_reader :record_sets
      
      def initialize(record_sets)
        @record_sets = record_sets
      end

      def start
        
      end

      def execute(command)
        case command.downcase.strip
        when 'quit'
          exit(0)
        end
      end
    end
  end
end
