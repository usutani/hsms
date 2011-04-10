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
  
  def receive_message(message)
    case message.s_type
    when SType::DATA_MESSAGE
      send_data(HSMSMessage.empty_data(SType::DATA_MESSAGE))
    when SType::SELECT_REQ
      send_data(HSMSMessage.empty_data(SType::SELECT_RSP))
      @state.selected
      puts @state.to_s
    when SType::DESELECT_REQ, SType::SEPARATE_REQ
      send_data(HSMSMessage.empty_data(SType::DESELECT_RSP))
      @state.deselected
      puts @state.to_s
    end
  end
end
