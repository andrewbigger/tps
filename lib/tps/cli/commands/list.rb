module Tps
  module CLI
    class List < Tps::CLI::Command
      def execute
        @session.record_sets.each do |record_set|
          print_fields(record_set)
        end
      end

      def print_fields(record_set)
        say '-----------------------------'
        say "Search #{record_set.name} with"
        render(record_set.fields)
        br
      end
    end
  end
end
