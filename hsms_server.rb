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
  
  def send_empty_data(s_type)
    select_rsp = "\x00\x00\x00\x0A" + "\x00" * 5 + s_type + "\x00" * 4
    send_data(select_rsp)
  end
  
  def receive_message(message)
    case message.s_type
    # when 0 && @state.is_select
    #   send_empty_data("\x00")
    when 1
      send_empty_data("\x02")
      @state.selected
      puts @state.to_s
    when 3, 9
      send_empty_data("\x04")
      @state.deselected
      puts @state.to_s
    end
  end
end
