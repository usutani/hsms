require "test/unit"

require "hsms_state"

class TestHSMSState < Test::Unit::TestCase
  def test_connect_state
    c = ConnectState.new
    assert_equal(false, c.is_connect)
    assert_equal("NOT CONNECTED", c.to_s)
    c.connected
    assert_equal(true, c.is_connect)
    assert_equal("CONNECTED", c.to_s)
    c.disconnected
    assert_equal(false, c.is_connect)
    assert_equal("NOT CONNECTED", c.to_s)
  end
  
  def test_select_state
    s = SelectState.new
    assert_equal(false, s.is_select)
    assert_equal("NOT SELECTED", s.to_s)
    s.selected
    assert_equal(true, s.is_select)
    assert_equal("SELECTED", s.to_s)
    s.deselected
    assert_equal(false, s.is_select)
    assert_equal("NOT SELECTED", s.to_s)
  end
  
  def test_hsms_state
    h = HSMSState.new
    assert_equal(false, h.is_connect)
    assert_equal(false, h.is_select)
    assert_equal("HSMS Status: NOT CONNECTED, NOT SELECTED", h.to_s)
    h.connected
    assert_equal(true, h.is_connect)
    assert_equal(false, h.is_select)
    assert_equal("HSMS Status: CONNECTED, NOT SELECTED", h.to_s)
    h.selected
    assert_equal(true, h.is_connect)
    assert_equal(true, h.is_select)
    assert_equal("HSMS Status: CONNECTED, SELECTED", h.to_s)
    h.deselected
    assert_equal(true, h.is_connect)
    assert_equal(false, h.is_select)
    assert_equal("HSMS Status: CONNECTED, NOT SELECTED", h.to_s)
    h.disconnected
    assert_equal(false, h.is_connect)
    assert_equal(false, h.is_select)
    assert_equal("HSMS Status: NOT CONNECTED, NOT SELECTED", h.to_s)
  end
end
