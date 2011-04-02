require "test/unit"

require "hsms_factory"

class TestHSMSFactory < Test::Unit::TestCase
  def test_well_formed
    len20_data02 = "\x00\x00\x00\x14" + "\x01" * 10 + "\x02" * 10
    len22_data04 = "\x00\x00\x00\x16" + "\x03" * 10 + "\x04" * 12
    len30_data02 = "\x00\x00\x00\x1E" + "\x01" * 10 + "\x02" * 20
    len11_data03 = "\x00\x00\x00\x15" + "\x01" * 10 + "\x03" * 11
    f = HSMSFactory.new
    f.feed(len20_data02)
    f.feed(len22_data04 + len30_data02)
    f.feed(len11_data03)
    assert_equal(20, f[0].length)
    assert_equal(len20_data02, f[0].buffer)
    assert_equal(22, f[1].length)
    assert_equal(len22_data04, f[1].buffer)
    assert_equal(30, f[2].length)
    assert_equal(len30_data02, f[2].buffer)
    assert_equal(21, f[3].length)
    assert_equal(len11_data03, f[3].buffer)
    assert_equal(nil, f[4])
    f.clear
    assert_equal(nil, f[0])
  end
  
  def test_fraction
    f = HSMSFactory.new
    f.feed("\x00\x00\x00\x14" + "\x01" * 3)
    assert_equal(nil, f[0])
    f.feed("\x01" * 7 + "\x02" * 10 + "\x00\x00\x00\x16" + "\x03" * 10 + "\x04" * 12)
    assert_equal(20, f[0].length)
    assert_equal(22, f[1].length)
    assert_equal("\x00\x00\x00\x14" + "\x01" * 10 + "\x02" * 10, f[0].buffer)
    assert_equal(22, f[1].length)
    assert_equal("\x00\x00\x00\x16" + "\x03" * 10 + "\x04" * 12, f[1].buffer)
  end
end
