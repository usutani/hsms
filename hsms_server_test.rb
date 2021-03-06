require "test/unit"

require 'socket'
require "hsms_server"

class TestHSMSServer < Test::Unit::TestCase
  def empty_data(s_type)
    "\x00\x00\x00\x0A" + "\x00" * 5 + s_type + "\x00" * 4
  end
  
  def test_select_deselect
    EM.run {
      host, port = "0.0.0.0", 5000
      EM.start_server(host, port, HSMSServer)
      fork {
        s = TCPSocket.open(host, port)
        s.write(empty_data("\x01"))
        assert_equal(empty_data("\x02"), s.read(14))
        3.times {
          s.write(empty_data("\x00"))
          assert_equal(empty_data("\x00"), s.read(14))
        }
        s.write(empty_data("\x03"))
        assert_equal(empty_data("\x04"), s.read(14))
        s.close
      }
      EM.add_timer(1) { 
        EM.stop
      }
    }
  end
end
