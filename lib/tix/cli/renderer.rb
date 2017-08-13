require 'pry'
require 'pp'

module Tix
  module CLI
    module Renderer
      def render(obj)
        render_array(obj) if obj.is_a?(Array)
        render_hash(obj)  if obj.is_a?(Hash)
      end

      def render_array(arr)
        Pry::ColorPrinter.pp(arr)
      end

      def render_hash(hsh)
        Pry::ColorPrinter.pp(hsh)
      end
    end
  end
end
