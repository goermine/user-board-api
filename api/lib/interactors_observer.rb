require 'observer'

module InteractorsObserver
  include Observable

  def on(event, &block)
    registered_events[event] = block
    self
  end

  def succeeded(*obj)
    event_processing(*obj, __method__)
  end

  def failed(*obj)
    event_processing(*obj, __method__)
  end

  def broadcast(event)
    add_observer(self, event)
  end

  private

  def registered_events
    @registered_events ||= {}
  end

  def event_processing(*obj, method)
    if !changed?
      broadcast(method)
      publish(*obj, method)
    else
      registered_events[method].call(*obj)
    end
  end

  def publish(*arg, func)
    registered_events.delete_if { |key| key != func }
    if registered_events[func] && @observer_peers[self] == func
      changed
      notify_observers(*arg)
    end
  end
end
