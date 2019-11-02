class TableTestController < ApplicationController
  def ping
    if current_user
      render json: { response: 'authorized pong'}
    else
      render json: { response: 'unauthorized'}
    end
  end
end

#$ curl -X POST "http://localhost:3000/user_token" -d '{"auth": {"username": "azerty", "password": "azerty"}}' -H "Content-Type: application/json" 
#=>$ {"jwt":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1NzI4MTcwMDMsInN1YiI6MX0.l57TbmYtRPIolVORlFblUJv6KliWPQI5zGAwxxxGBIo"}
# curl -X GET http://localhost:3000/ping -H "Authorization: JWT eyJ0eXAiOiJKV1QiLCJciOiJIUzI1NiJ9.eyJleHAiOjE1NzI4MTcwMDMsInN1YiI6MX0.l57TbmYtRPIolVORlFblUJv6KliWPQI5zGAwxxxGBIo"
#=>$ {"response":"authorized pong"}