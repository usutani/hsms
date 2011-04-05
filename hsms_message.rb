class HSMSMessage
  MAX_BUFFER_SIZE = 0xFFFFFFFF
  LENGTH_BYTES = 4
  HEADER_BYTES = 10
  
  attr_reader :buffer
  
  def initialize
    @buffer = ""
    @length = 0
  end
  
  def feed(data)
    return if remain_buffer_size == 0
    @buffer << data
  end
  
  # TODO?
  # Request resend command if received length < header bytes.
  def length
    return @length unless @length == 0
    return 0 if buffer.length < LENGTH_BYTES
    LENGTH_BYTES.times { |i|
      @length <<= 8
      @length += @buffer[i]
    }
    return @length
  end
  
  def remain_buffer_size
    return MAX_BUFFER_SIZE if length == 0
    return LENGTH_BYTES + @length - @buffer.length
  end
end
