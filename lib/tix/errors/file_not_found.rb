class FileNotFound < StandardError
  def message
    <<~MESSAGE
      The file you've provided was not found
      Please check your path and try again
    MESSAGE
  end
end
