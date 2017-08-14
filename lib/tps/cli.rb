require 'tps/cli/renderer'
require 'tps/cli/command'
require 'tps/cli/commands/list'
require 'tps/cli/commands/menu'
require 'tps/cli/commands/search'
require 'tps/cli/session'
require 'tps/errors/file_not_found'
require 'tps/errors/file_not_readable'

module Tps
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
        Tps::RecordSet.new_from_array(name, Tps::Parser.parse(file))
      end
    end

    def self.print_help
      puts 'USAGE: tps --orgs=ORGS --users=USERS --tickets=TICKETS'
      puts 'FLAGS: --orgs    = organization json file'
      puts '       --users   = user json file'
      puts '       --tickets = tickets json file'
      puts ''
      puts 'add --trace to inspect errors'
      puts ''
    end
  end
end
