class LineEntriesController < ApplicationController
  def index
  end

  def new
    @line_entry = current_user.line_entries.build
  end

  def create
  end
end
