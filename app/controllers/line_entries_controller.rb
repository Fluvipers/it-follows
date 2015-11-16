class LineEntriesController < ApplicationController
  def index
  end

  def new
    @line_entry = current_user.line_entries.build
  end

  def create
    @line_entry = current_user.line_entries.new
    x = line_entry_params.merge(line: Line.last)
    @line_entry.attributes = x
    if @line_entry.save
      redirect_to edit_line_entry_path(@line_entry)
    else
      render 'edit'
    end
  end

  def edit
    @line_entry = LineEntry.last
  end

  def line_entry_params
    params.require(:line_entry).permit(:title, :advertiser, :client)
  end
end
