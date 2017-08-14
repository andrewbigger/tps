require 'highline/import'

module Tix
  module CLI
    class Command
      include Tix::CLI::Renderer

      def initialize(session)
        @session = session
      end

      def ask_s(prompt)
        response = ask(prompt)
        raise Quit if quit?(prompt)
        response.to_s
      end

      def ask_int(prompt)
        ask_s(prompt).to_i
      end

      def ask_sym(prompt)
        ask_s(prompt).to_sym
      end

      def quit?(command)
        command.strip.downcase == 'quit'
      end
    end
  end
end
