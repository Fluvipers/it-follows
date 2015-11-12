class LinesController < ApplicationController
  def new 
  end
  def create
    name = params['line']['name']
    puts name
  end
end
