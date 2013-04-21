class Post < ActiveRecord::Base
  translates :content, :title
  attr_accessible :content, :title, :tags_attributes, :friendly_id, :main_picture

  has_many :comments
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :tags, :allow_destroy => true

  self.per_page = Settings.posts.per_page

  def to_param
    friendly_id.nil? ? id : [id, friendly_id.parameterize].join("-")
  end

  def self.find_by_tag(tag_name, locale=I18n.locale)
    ids = Tag.find_by_name(tag_name).posts.pluck(:id)
    Post.with_translations(I18n.locale).where(:id => ids)
  end
end
