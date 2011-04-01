require "test/unit"

require "hsms_state"

class TestHSMSState < Test::Unit::TestCase
  def test_connect_state
    c = ConnectState.new
    assert_equal(false, c.is_connect)
    c.connected
    assert_equal(true, c.is_connect)
    c.disconnected
    assert_equal(false, c.is_connect)
  end
  
  def test_select_state
    s = SelectState.new
    assert_equal(false, s.is_select)
    s.selected
    assert_equal(true, s.is_select)
    s.deselected
    assert_equal(false, s.is_select)
  end
  
  def test_hsms_state
    h = HSMSState.new
    assert_equal(false, h.is_connect)
    assert_equal(false, h.is_select)
    h.connected
    assert_equal(true, h.is_connect)
    assert_equal(false, h.is_select)
    h.selected
    assert_equal(true, h.is_connect)
    assert_equal(true, h.is_select)
    h.deselected
    assert_equal(true, h.is_connect)
    assert_equal(false, h.is_select)
    h.disconnected
    assert_equal(false, h.is_connect)
    assert_equal(false, h.is_select)
  end
end
