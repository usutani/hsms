require "rubygems"
require "eventmachine"

require "hsms_factory"
require "hsms_state"

class HSMSServer < EM::Connection
  def initialize
    @factory = HSMSFactory.new
    @state = HSMSState.new
    puts @state.to_s
  end
  
  def post_init
    @state.connected
    puts @state.to_s
  end
  
  def unbind
    @state.deselected
    @state.disconnected
    puts @state.to_s
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
    s_type = "\x02"
    select_rsp = "\x00\x00\x00\x0A" + "\x00" * 5 + s_type + "\x00" * 4
    send_data(select_rsp)
    puts select_rsp
  end
end

EM.run do
  host, port = "0.0.0.0", 5000
  EM.start_server(host, port, HSMSServer)
  puts "Now accepting connections on address #{host}, port #{port}"
end
