require_relative 'blog_fetcher'
require 'date'
require 'json'

class BlogPost
  attr_reader :title, :body, :category, :date, :markdown, :post_id


  class << self
    def from_json(json)
      entry = OpenStruct.new(JSON.parse(json))
      entry.date = DateTime.parse(entry.date)
      new(entry)
    end
  end

  def initialize(entry)
    @post_id = entry.post_id
    @title = entry.title
    @body = entry.body
    @category = entry.category
    @date = entry.date
  end

  def formatted_date
    date.strftime("%m/%d/%Y")
  end

  def slug
    title.downcase.gsub(/[^a-z1-9]+/, '-').chomp('-')
  end

  def redis_key_value
    Hash[
         slug: slug,
         post_id: post_id
        ]
  end

  def to_hash
    Hash[
         post_id: post_id,
         title: title,
         body: body,
         category: category,
         date: date
        ]
  end

  def to_json
    self.to_hash.to_json
  end
end
