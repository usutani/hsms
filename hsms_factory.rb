require "hsms_message"

class HSMSFactory
  def initialize
    clear
  end
  
  def clear
    @messages = Array.new
    @message = HSMSMessage.new
  end
  
  def [](index)
    @messages[index]
  end
  
  def <<(message)
    @messages << message
  end
  
  def each
    @messages.each { |message| 
      yield(message)
    }
  end
  
  def feed(org_data)
    work = ""
    work << org_data
    while work.length > 0
      if @message.length == 0
        @message.feed(work.slice!(0, HSMSMessage::LENGTH_BYTES))
      end
      remain = @message.remain_buffer_size
      if remain > work.length
        @message.feed(work)
        return
      end
      @message.feed(work.slice!(0, remain))
      @messages << @message
      @message = HSMSMessage.new
    end
  end
end
