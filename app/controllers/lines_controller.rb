class LinesController < ApplicationController
  def index
    @lines = Line.all
  end

  def new 
    @line = Line.new
    @line.properties = Array.new(5, {name:'', required: false})
  end

  def create
    @line = Line.new
    @line.name = line_params[:name]
    @line.user_id = current_user.id

    
    if @line.save
      flash[:notice] = "Linea creada exitosamente"
      redirect_to lines_path
    else
      redirect_to lines_path
      #render :edit
    end
  end

  private
  def line_params
    puts params.inspect
    params.require(:line).permit(:name, properties:[:name])
  end
end
