require "mention_finder"
require "hashtag_finder"
require "line_entry_properties_to_html_inputs_mapper"

class LineEntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @line_entries = LineEntry.all
    @line_entry_path = params[:line_entries]
  end

  def new
    @line_entry = current_user.line_entries.build
    @url = line_entries_path
    @method =  'post'
    line = Line.last
    @inputs = LineEntryPropertiesToHtmlInputsMapper.new([:line_entry, :data], line.properties).map_properties.join("").html_safe
  end

  def create
    line = Line.last

    @line_entry = current_user.line_entries.new(line_entry_params(line))
    @line_entry.line = line

    if @line_entry.save
      redirect_to edit_line_entry_path(params[:line_entries], @line_entry)
    else
      render 'new'
    end
  end

  def edit
    @line_entry = LineEntry.find(params[:id])
    @mentions = @line_entry.followups.map { |followup| show_mentions(followup.description) }.uniq.flatten
    @hashtags = @line_entry.followups.map { |followup| show_hashtags(followup.description) }.uniq.flatten
    @url = "/#{params[:line_entries]}/#{params[:id]}"
    @method = 'patch'
    line = Line.last
    @inputs = LineEntryPropertiesToHtmlInputsMapper.new([:line_entry, :data], line.properties, @line_entry.data).map_properties.join("").html_safe
  end

  def update
    line = Line.last

    @line_entry = current_user.line_entries.find(params[:id])
    x = line_entry_params(line).merge(line: line)
    tasks = x["followups_attributes"]["0"].delete("tasks")
    tasks = tasks.split("xx")

    @line_entry.update(x)
    followup = @line_entry.followups.last
    followup.tasks.build(description: tasks[0])
    followup.tasks.build(description: tasks[1])
    attachments = params[:line_entry][:followups_attributes]["0"][:attachments]
    followup.documents = attachments 
    followup.save!
    redirect_to edit_line_entry_path(params[:line_entries], @line_entry)
  end
    
  private

  def show_mentions(description)
    MentionFinder.new(description).find_mentions
  end

  def show_hashtags(description)
    HashtagFinder.new(description).find_hashtags
  end

  def line_entry_params(line)
    line_properties = line.properties.map { |property| property["name"].downcase.to_sym }
    params.require(:line_entry).permit(data: line_properties, followups_attributes: [:description, :percentage, :tasks, "0": [:attachments]])
  end
end
