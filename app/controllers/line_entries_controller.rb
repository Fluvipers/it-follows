require "mention_finder"
require "hashtag_finder"
require "line_entry_properties_to_html_inputs_mapper"

class LineEntriesController < ApplicationController

  def index
    @lines = Line.all
    @user = current_user
    if params[:search]
      @line_entries = LineEntry.search_by_name(params[:search][:search])
    else
      @line_entries = find_line.line_entries
    end
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
        format.html { redirect_to new_line_entries_path}
        format.json { render json: @line_entry.errors, status: :unprocessable_entity }
        flash[:notice] = "There's some fields without data."
      end
    end
  end

  def edit
    @user = current_user
    @line_entry = LineEntry.find(params[:id])

    @mentions = @line_entry.followups.map { |followup| show_mentions(followup.description) }.uniq.flatten
    @mentions_tasks = @line_entry.tasks.map { |task| show_mentions(task.description) }.uniq.flatten
    @hashtags = @line_entry.followups.map { |followup| show_hashtags(followup.description) }.uniq.flatten

    if not allowed_to_edit_line_entry?
      render(:file => File.join(Rails.root, 'public/403.html'), :status => :forbidden, :layout => false) and return
    end

    @url = "/#{params[:line_entries]}/#{params[:id]}"
    @method = 'patch'

    @properties_inputs = build_properties_inputs(@line_entry.data)
  end

  def update
    @line_entry = LineEntry.find(params[:id])
    x = line_entry_params.merge(line: find_line)
    tasks = x["followups_attributes"]["0"].delete("tasks")
    tasks = tasks.split("\r\n")

    @line_entry.update(x)
    followup = @line_entry.followups.last
    followup.user = current_user

    attachments = params[:line_entry][:followups_attributes]["0"][:attachments]

    tasks.each do |t|
      followup.tasks.build(description: t, user: current_user) unless t.blank?
    end

    attachments.each {|x| followup.attached_documents.build(document: x)} unless attachments.nil?

    respond_to do |format|
      if followup.save
        format.html { redirect_to edit_line_entry_path(params[:line_entries], @line_entry) }
        format.json { render json: {id: followup.id, description: followup.description, percentage: followup.percentage, user: current_user }, status: :created}
      else
        format.html { render :edit }
        format.json { render json: followup.errors, status: :unprocessable_entity }
        flash[:notice] = "There's some fields without data."
      end
    end

    mentions = find_all_mentions(followup)
    find_mail_by_mentions(mentions).each{ |mail| send_email_involved_users(mail, create_url_by_line)}

  end
    
  private

  def allowed_to_edit_line_entry?
    @line_entry.user_id == @user.id || @mentions.include?(@user.screen_name) || @mentions_tasks.include?(@user.screen_name)
  end

  def find_all_mentions(followup)
    mentions = show_mentions(followup.description)
    mentions.concat(followup.tasks.map{ |task| show_mentions(task.description)})
    mentions.uniq
  end

  def send_email_involved_users(user_email, url)
    TaskMailer.task_email(user_email, url).deliver
  end

  def create_url_by_line
    # TODO: remove hardoded ip
    line = @line_entry.line
    "54.213.111.154/#{line.slug_name}/#{@line_entry.id}/edit"
  end

  def find_mail_by_mentions(mentions)
   mentions.map {|u_sn| User.where(screen_name: u_sn)[0].email if User.where(screen_name: u_sn).present?}.compact
  end

  def show_mentions(description)
    MentionFinder.new(description).find_mentions
  end

  def show_hashtags(description)
    HashtagFinder.new(description).find_hashtags
  end

  def line_entry_params
    params.require(:line_entry).permit(data: line_properties, followups_attributes: [:user_id, :description, :percentage, :tasks, "0": [:attachments]])
  end

  def find_line
    @line ||= Line.find_by_slug_name(params[:line_entries])
  end

  def line_properties
    find_line.properties.map { |property| property.name.downcase.to_sym }
  end

  def build_properties_inputs(values={})
    line = find_line
    LineEntryPropertiesToHtmlInputsMapper.new([:line_entry, :data], line.properties, values).map_properties.join("").html_safe
  end
end
