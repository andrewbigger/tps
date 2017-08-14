module Tix
  module CLI
    class Session
      attr_reader :record_sets
      
      def initialize(record_sets)
        @record_sets = record_sets
      end

      def start
        do_loop = true
        say('Welcome to Zendesk Search')
        response = ask('Type \'quit\' to exit at any time, Press any key to continue')

        do_loop = false if response.downcase.strip == 'quit'

        while do_loop
          begin
            Tix::CLI::Menu.new(self).execute
          rescue Quit
            break
          end
        end

        exit(0)
      end
    end
  end
end
