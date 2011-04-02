require "test/unit"

require "hsms_message"

class TestHSMSMessage < Test::Unit::TestCase
  def test_length_one_feed
    h = HSMSMessage.new
    assert_equal(0, h.length)
    h.feed("\x10\x02\x30\x04\x50\x06")
    assert_equal(0x10023004, h.length)
  end
  
  def test_length_fractional_feeds
    h = HSMSMessage.new
    h.feed(0xFF)
    assert_equal(0, h.length)
    h.feed(0x00)
    assert_equal(0, h.length)
    h.feed(0x00)
    assert_equal(0, h.length)
    h.feed(0x11)
    assert_equal(0xFF000011, h.length)
    h.feed(0xFF)
    assert_equal(0xFF000011, h.length)
  end
  
  def test_remain_buffer_size
    h = HSMSMessage.new
    assert_equal(HSMSMessage::MAX_BUFFER_SIZE, h.remain_buffer_size)
    3.times { h.feed(0) }
    h.feed(20)
    assert_equal(20, h.remain_buffer_size)
    data = "0" * 10
    h.feed(data)
    assert_equal(10, h.remain_buffer_size)
    h.feed(data)
    assert_equal(0, h.remain_buffer_size)
    h.feed(data)
    assert_equal(0, h.remain_buffer_size)
  end
end
