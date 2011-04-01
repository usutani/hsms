class ConnectState
  attr_reader :is_connect
  
  def initialize
    @is_connect = false
  end
  
  def connected
    @is_connect = true
  end

  def disconnected
    @is_connect = false
  end
end

class SelectState
  attr_reader :is_select
  
  def initialize
    @is_select = false
  end
  
  def selected
    @is_select = true
  end

  def deselected
    @is_select = false
  end
end

class HSMSState
  attr_reader :connect_state
  attr_reader :select_state
  
  def initialize
    @connect_state = ConnectState.new
    @select_state = SelectState.new
  end
  
  def is_connect
    @connect_state.is_connect
  end
  
  def is_select
    @select_state.is_select
  end
  
  def connected
    @connect_state.connected
  end
  
  def disconnected
    deselected
    @connect_state.disconnected
  end
  
  def can_select
    connected
  end
  
  def selected
    @select_state.selected if can_select
  end
  
  def deselected
    @select_state.deselected
  end
end
