class BaseInteractor
  include InteractorsObserver

  def perform
    raise 'Override this method in your interactor'
  end

  # # rollback can be used if it's necessary
  # def rollback
  # end

  def run!
    begin
      perform
    rescue
      # rollback
      raise
    end

    self
  end

  # def errors
  #   @errors ||= Errors.new
  # end
end
