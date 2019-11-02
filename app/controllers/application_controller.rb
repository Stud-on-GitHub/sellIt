class ApplicationController < ActionController::API
  include Knock::Authenticable
  
  # def ping
  #   render json: { response: 'pong'} #test curl -X GET http://localhost:3000/ping => {"response":"pong"}
  # end
end
