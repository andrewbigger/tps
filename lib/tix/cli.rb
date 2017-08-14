require 'tix/cli/renderer'
require 'tix/cli/command'
require 'tix/cli/commands/list'
require 'tix/cli/commands/menu'
require 'tix/cli/commands/search'
require 'tix/cli/session'
require 'tix/errors/file_not_found'
require 'tix/errors/file_not_readable'

module Tix
  module CLI
    def self.verify_files(*input_files)
      input_files.each do |file|
        raise FileNotFound    unless file.is_a?(File)
        raise FileNotFound    unless File.exist?(file)
        raise FileNotReadable unless File.readable?(file)
      end
    end

    def self.load_record_sets(*input_files)
      input_files.map do |file|
        name = File.basename(file)
        Tix::RecordSet.new_from_array(name, Tix::Parser.parse(file))
      end
    end
  end
end
