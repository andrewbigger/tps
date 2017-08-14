module Tix
  module CLI
    class Session
      attr_reader :record_sets

      def initialize(record_sets)
        @record_sets = record_sets
      end

      def start
        say('Welcome to Zendesk Search')
        prompt = 'Type \'quit\' to exit at any time, Press any key to continue'
        resp = ask(prompt)
        execute_command_loop if session_start?(resp)
        exit(0)
      end

      private

      def session_start?(resp)
        !resp.strip.casecmp('quit').zero?
      end

      def execute_command_loop
        do_loop = true
        while do_loop
          begin
            Tix::CLI::Menu.new(self).execute
          rescue Quit
            break
          end
        end
      end
    end
  end
end
