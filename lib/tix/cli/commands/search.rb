require 'tix/errors/invalid_choice'
require 'tix/errors/quit'
module Tix
  module CLI
    class Search < Tix::CLI::Command
      def execute
        select_record_set
        select_term
        select_value
        print_results
      rescue InvalidChoice
        say 'Unknown attribute or option, please try again'
        br
      end

      def choices
        count = 0
        @session.record_sets.map do |record_set|
          count += 1
          "#{count}) #{record_set.name}"
        end.join(', ')
      end

      def select_record_set
        response = ask_int("Select #{choices}")
        set_choice = response - 1
        raise InvalidChoice if set_choice.negative?
        @record_set = @session.record_sets[set_choice]
      end

      def select_term
        response = ask_sym('Select search term')
        @term = response
        raise InvalidChoice unless @record_set.fields.include?(@term)
      end

      def select_value
        @value = ask_s('Enter search value')
      end

      def print_results
        results = @record_set.where(@term => @value)
        say 'No results found' if results.empty?
        results.each { |result| render(result.data) }
        br
      end
    end
  end
end
