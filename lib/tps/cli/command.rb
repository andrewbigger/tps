require 'highline/import'

module Tps
  module CLI
    class Command
      include Tps::CLI::Renderer

      def initialize(session)
        @session = session
      end

      def br
        say("\n")
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
        response = ask_s(prompt).to_s
        response = "_#{response}" if number?(response)
        response.to_sym
      end

      def number?(response)
        return true if response == '0'
        return true if response.to_i.positive?
        false
      end

      def quit?(command)
        command.strip.casecmp('quit').zero?
      end
    end
  end
end
