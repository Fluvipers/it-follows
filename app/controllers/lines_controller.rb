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

    respond_to do |format|
      if @line.save!
        format.html { redirect_to lines_path, notice: 'Line was successfully created.' }
        format.json { render :show, location: @line}
      else
        format.html { render :edit}
        format.json { render json: @line.errors, status: :unprocessable_entity }
      end
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
