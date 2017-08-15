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
    SET_CONFIG = {
      orgs:    { set_name: 'Organizations', class: Tps::OrganizationRecord },
      users:   { set_name: 'Users', class: Tps::UserRecord },
      tickets: { set_name: 'Tickets', class: Tps::TicketRecord }
    }.freeze

    class <<self
      def verify_files(input_files)
        input_files.each do |_type, file|
          raise FileNotFound    unless file.is_a?(File)
          raise FileNotFound    unless File.exist?(file)
          raise FileNotReadable unless File.readable?(file)
        end
      end

      def load_record_sets(input_files)
        input_files.map do |type, file|
          Tps::RecordSet.new_from_array(
            set_name_for(type, file),
            Tps::Parser.parse(file),
            record_class_for(type, file)
          )
        end
      end

      def print_help
        puts 'USAGE: tps --orgs=ORGS --users=USERS --tickets=TICKETS'
        puts 'FLAGS: --orgs    = organization json file'
        puts '       --users   = user json file'
        puts '       --tickets = tickets json file'
        puts ''
        puts 'add --trace to inspect errors'
        puts ''
      end

      def get_record_config(type, file)
        return SET_CONFIG[type] if SET_CONFIG.key?(type)
        { set_name: File.basename(file), class: Tps::Record }
      end

      def set_name_for(type, file)
        get_record_config(type, file)[:set_name]
      end

      def record_class_for(type, file)
        get_record_config(type, file)[:class]
      end
    end
  end
end
