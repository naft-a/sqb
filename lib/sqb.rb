require 'sqb/query'
require 'sqb/version'
require 'sqb/safe_string'

module SQB
  def self.safe(string)
    SafeString.new(string)
  end
end