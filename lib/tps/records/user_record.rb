module Tps
  class UserRecord < Tps::Record
    def _id_compare(value)
      string_equal?(get(:_id), value)
    end

    def external_id_compare(value)
      string_equal?(get(:external_id), value)
    end

    def organization_id_compare(value)
      string_equal?(get(:organization_id), value)
    end

    def tags_compare(value)
      array_include?(get(:tags), value)
    end

    def role_compare(value)
      string_equal?(get(:role), value)
    end
  end
end
