require 'tix/errors/quit'

module Tix
  module CLI
    class Menu < Tix::CLI::Command
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
          Tix::CLI::Search.new(@session).execute
        when :_2
          Tix::CLI::List.new(@session).execute
        when :quit
          raise Quit
        else
          say('Unknown option')
          br
          select_option
        end
      end
    end
  end
end
