class LinesController < ApplicationController
  def index
    @lines = Line.all
  end

  def new 
    @line = Line.new
  end

  def create
    @line = Line.new(line_params)
    
    if @line.save
      flash[:notice] = "Linea creada exitosamente"
      redirect_to lines_path
    else
      render :edit
    end
  end

  private
  def line_params
    params.require(:line).permit(:name)
  end
end
