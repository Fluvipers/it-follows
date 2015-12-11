require "mention_finder"
require "hashtag_finder"
require "line_entry_properties_to_html_inputs_mapper"

class LineEntriesController < ApplicationController
  before_action :authenticate_user!, expect: [:create]

  def index
    @line_entries = find_line.line_entries
    @line_entry_path = params[:line_entries]
  end

  def new
    @line_entry = current_user.line_entries.build
    @url = line_entries_path
    @method =  'post'
    @properties_inputs = build_properties_inputs
  end

  def create
    @line_entry = current_user.line_entries.new(line_entry_params)
    @line_entry.line = find_line

    respond_to do |format|
      if @line_entry.save
        format.html { redirect_to edit_line_entry_path(params[:line_entries], @line_entry) }
        format.json { render json: {id: @line_entry.id, line_entry_path: edit_line_entry_url(params[:line_entries], @line_entry) }, status: :created}
      else
        format.html { render :new }
        format.json { render json: @line_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def external_edit
    @user=current_user
    @line_entry = current_user.line_entries.find(params[:id])
    @mentions = @line_entry.followups.map { |followup| show_mentions(followup.description) }.uniq.flatten
    @hashtags = @line_entry.followups.map { |followup| show_hashtags(followup.description) }.uniq.flatten

    @url = "/#{params[:line_entries]}/#{params[:id]}"
    @method = 'patch'

    @properties_inputs = build_properties_inputs(@line_entry.data)
    render layout: "external"
  end

  def edit
    @user=current_user
    @line_entry = current_user.line_entries.find(params[:id])
    @mentions = @line_entry.followups.map { |followup| show_mentions(followup.description) }.uniq.flatten
    @hashtags = @line_entry.followups.map { |followup| show_hashtags(followup.description) }.uniq.flatten

    @url = "/#{params[:line_entries]}/#{params[:id]}"
    @method = 'patch'

    @properties_inputs = build_properties_inputs(@line_entry.data)
  end

  def update
    @line_entry = current_user.line_entries.find(params[:id])
    x = line_entry_params.merge(line: find_line)
    tasks = x["followups_attributes"]["0"].delete("tasks")
    tasks = tasks.split("\r\n")

    @line_entry.update(x)
    followup = @line_entry.followups.last

    tasks.each do |t|
      followup.tasks.build(description: t, user: current_user)
    end

    attachments = params[:line_entry][:followups_attributes]["0"][:attachments]
    followup.documents = attachments 
    if followup.save
      redirect_to edit_line_entry_path(params[:line_entries], @line_entry)
    else
      render :edit
    end
  end
    
  private

  def show_mentions(description)
    MentionFinder.new(description).find_mentions
  end

  def show_hashtags(description)
    HashtagFinder.new(description).find_hashtags
  end

  def line_entry_params
    params.require(:line_entry).permit(data: line_properties, followups_attributes: [:description, :percentage, :tasks, "0": [:attachments]])
  end

  def find_line
    @line ||= Line.find_by_slug_name(params[:line_entries])
  end

  def line_properties
    find_line.properties.map { |property| property["name"].downcase.to_sym }
  end

  def build_properties_inputs(values={})
    line = find_line
    LineEntryPropertiesToHtmlInputsMapper.new([:line_entry, :data], line.properties, values).map_properties.join("").html_safe
  end
end
