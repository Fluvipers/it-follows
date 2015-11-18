require "mention_finder"
class LineEntriesController < ApplicationController
  def index
    @line_entries = LineEntry.all
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
    @line_entry = LineEntry.find(params[:id])
    @mentions = @line_entry.followups.map { |followup| show_mentions(followup.description) }.uniq.flatten
  end

  def update
    @line_entry = current_user.line_entries.find(params[:id])
    x = line_entry_params.merge(line: Line.last)
    tasks = x["followups_attributes"]["0"].delete("tasks")
    tasks = tasks.split("xx")

    @line_entry.update(x)
    followup = @line_entry.followups.last
    followup.tasks.build(description: tasks[0])
    followup.tasks.build(description: tasks[1])
    attachments = params[:line_entry][:followups_attributes]["0"][:attachments]
    followup.documents = attachments 
    followup.save!
    redirect_to edit_line_entry_path(@line_entry)
  end
    
  def show_mentions(description)
    MentionFinder.new(description).find_mentions
  end

  private
  def line_entry_params
    params.require(:line_entry).permit(:title, :advertiser, :client, followups_attributes: [:description, :percentage, :tasks, "0": [:attachments]]) 
  end
end
