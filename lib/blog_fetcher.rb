require_relative 'blog_post'
require 'contentful'
require 'ostruct'
require 'redcarpet'

class BlogFetcher
  TTL = 100
  attr_accessor :client, :markdown

  class << self
    def fetch
      fetcher = new
      fetcher.fetch
    end

    def fetch_post(id)
      fetcher = new
      fetcher.fetch_post(id)
    end

    def category_name(id)
      fetcher = new
      fetcher.fetch_category_name(id)
      end
  end

  def initialize
    renderer = Redcarpet::Render::HTML.new(render_options = {})
    @markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    @client = Contentful::Client.new(
                                     access_token:ENV['ACCESS_TOKEN'],
                                     space: ENV['SPACE'],
                                     dynamic_entries: :auto
                                    )
  end


  def fetch_post(id)
    # first try redis then fetch post
    entry = @client.entry(id)
    post = BlogPost.new(parse_entry(entry))
    redis_set_post(post)

    post
  end

  def fetch
    ids = []
    posts = entries.map do |entry|
      post = BlogPost.new(parse_entry(entry))
      redis_set_post(post)
      ids << post.post_id
      post
    end

    redis_set_id_list(ids)
    posts
  end

  def redis_set_post(post)
    $redis.setex(post.post_id, TTL, post.to_json)
    $redis.set(post.slug, post.post_id)
  end

  def redis_set_id_list(ids)
    $redis.rpush(:index, ids)
    $redis.expire(:index, TTL)
  end

  def fetch_category_name(id)
    @client.entry(id).fields[:categoryName]
  end

  def entries
    @client.entries(order: '-sys.createdAt', content_type: '1jwFhFm7nocwWoGgEOCQCQ')
  end

  def parse_entry(entry)
    category = resolve_category(entry.post_category)
    parsed_body = parse_post_body(entry.post_body)
    OpenStruct.new(
                    post_id: entry.id,
                    title: entry.post_title,
                    body: parsed_body,
                    category: category,
                    date: entry.created_at
                    )
  end

  def resolve_category(category)
    BlogFetcher.category_name(category.first["sys"]["id"])
  end

  def parse_post_body(body)
    @markdown.render(body)
  end
end
