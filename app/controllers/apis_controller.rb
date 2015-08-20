class ApisController < ApplicationController
  def index
    @host = request.host
  end
end
