class LineEntriesController < ApplicationController
  def index
  end

  def new
    @line_entry = current_user.line_entries.build
  end

  def create
    @line_entry = current_user.line_entries.new(line_entry_params)
    @line_entry.save
    render 'edit'
  end

  def edit
  end

  def line_entry_params
    params.require(:line_entry).permit(:title, :advertiser, :client)
  end
end
