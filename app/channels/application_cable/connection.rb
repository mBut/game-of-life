module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :session

    def connect
      self.session = request.session.id
    end
  end
end
