class LineEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :line

  validates_presence_of :data

  attr_accessor :title, :advertiser, :client

  after_initialize :set_default_data

  def set_default_data
    self.data={title: '', advertiser: '', client: ''}
  end

  def title=(value)
    self.data = self.data || {}
    self.data['title'] = value
  end

  def title
    self.data['title']
  end

  def advertiser=(value)
    self.data['advertiser'] = value
  end

  def advertiser
    self.data['advertiser']
  end

  def client=(value)
    self.data['client'] = value
  end

  def client
    self.data['client']
  end
end
