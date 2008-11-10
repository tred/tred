class TestsController < ApplicationController
  
  def show
    headers['Content-type'] = 'text/plain'
    render :text => params.inspect
  end
  
end
