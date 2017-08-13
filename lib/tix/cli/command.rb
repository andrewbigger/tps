require 'highline/import'

module Tix
  module CLI
    class Command
      include Tix::CLI::Renderer

      def initialize(session)
        @session = session
      end
    end
  end
end
