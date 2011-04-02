require "rubygems"
require "eventmachine"

require "hsms_factory"

class HSMSServer < EM::Connection
  attr_reader :factory
  
  def initialize
    @factory = HSMSFactory.new
  end
  
  def receive_data(data)
    @factory.feed(data)
    @factory.each { |message|
      receive_message(message)
    }
    @factory.clear
  end
  
  def receive_message(message)
    puts message
  end
end

EM.run do
  host, port = "0.0.0.0", 10000
  EM.start_server(host, port, HSMSServer)
  puts "Now accepting connections on address #{host}, port #{port}"
end
