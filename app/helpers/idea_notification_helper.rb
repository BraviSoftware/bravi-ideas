require 'socketIO'

class Messenger
  def self.send_message!(name, args)
    begin
      SocketIO.connect('http://localhost:8080', sync: true) do
        after_start do
          emit('new-idea', 'test')
          disconnect
        end
      end
    rescue
    end
  end
end