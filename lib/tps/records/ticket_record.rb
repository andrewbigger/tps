module Tps
  class TicketRecord < Tps::Record
    def _id_compare(value)
      string_equal?(get(:_id), value)
    end

    def external_id_compare(value)
      string_equal?(get(:external_id), value)
    end

    def tags_compare(value)
      array_include?(get(:tags), value)
    end

    def submitter_id_compare(value)
      string_equal?(get(:submitter_id), value)
    end

    def assignee_id_compare(value)
      string_equal?(get(:assignee_id), value)
    end
  end
end
