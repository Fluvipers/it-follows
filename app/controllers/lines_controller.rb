class LinesController < ApplicationController
  def index
    @lines = Line.all
  end

  def new
    @line = Line.new
    5.times { @line.properties.build }
  end

  def create
    params = remove_empty_properties(line_params)
    @line = Line.new(params)
    if @line.save!
      flash[:notice] = "Linea creada exitosamente"
      redirect_to lines_path
    else
      render :edit
    end
  end

  private
  def line_params
    params.require(:line).permit(:name, properties_attributes: [:name, :required])
  end

  def remove_empty_properties(line_params)
    if line_params["properties_attributes"]
      options = line_params["properties_attributes"].each_with_object({}) do |(index, ro), options_attributes|
        options_attributes[index] = ro if ro["name"].present?
      end
      line_params["properties_attributes"] = options
    end
    line_params
  end
end
