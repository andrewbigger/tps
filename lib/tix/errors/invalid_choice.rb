class InvalidChoice < StandardError
  def message
    <<~MESSAGE
      The file you've provided is not readable
      Please check that you have the correct access permissions
    MESSAGE
  end
end
