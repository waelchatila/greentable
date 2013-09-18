module Greentable
  class Configuration
    attr_accessor :defaults

    def initialize
      @defaults = {}
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end
end
