require 'tps/errors/quit'

module Tps
  module CLI
    class Menu < Tps::CLI::Command
      def execute
        print_options
        select_option
      end

      def print_options
        say('Select search options:')
        say('* Press 1 to search Zendesk')
        say('* Press 2 to view a list of searchable fields')
        say('* Type \'quit\' to exit')
        br
      end

      def select_option
        case ask_sym('What would you like to do?')
        when :_1
          Tps::CLI::Search.new(@session).execute
        when :_2
          Tps::CLI::List.new(@session).execute
        when :quit
          raise Quit
        else
          report_unknown_option
        end
      end

      private

      def report_unknown_option
        say('Unknown option')
        br
        select_option
      end
    end
  end
end
