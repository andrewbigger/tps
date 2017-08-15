module Tps
  class OrganizationRecord < Tps::Record
    def _id_compare(value)
      string_equal?(get(:_id), value)
    end

    def external_id_compare(value)
      string_equal?(get(:external_id), value)
    end

    def domain_names_compare(value)
      array_include?(get(:domain_names), value)
    end

    def tags_compare(value)
      array_include?(get(:tags), value)
    end
  end
end
