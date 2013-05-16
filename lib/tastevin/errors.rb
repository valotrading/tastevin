module Tastevin

  class Error < StandardError
  end

  class ConnectionError < Error
  end

  class LoginError < Error
  end

end
