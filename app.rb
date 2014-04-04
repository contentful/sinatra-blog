require 'sinatra/base'
require 'haml'
require 'redis'

if ENV['RACK_ENV'] == 'development'
  require 'pry'
  require 'dotenv'
  Dotenv.load
end

require_relative 'lib/blog_fetcher'
require_relative 'lib/blog_post'

class App < Sinatra::Base
  # https://github.com/cloudfoundry-samples/sinatra-cf-twitter/blob/master/sinatwitter.rb
  configure do
    services = JSON.parse(ENV['VCAP_SERVICES'])
    redis_key = services.keys.select { |svc| svc =~ /redis/i }.first
    redis = services[redis_key].first['credentials']
    redis_conf = {:host => redis['hostname'], :port => redis['port'], :password => redis['password']}
    $redis = Redis.new redis_conf
  end


  use Rack::Logger
  configure do
    set :haml, format: :html5
  end

  helpers do
    def link_to_post(post)
      "<a href=\"#{request.base_url}/post/#{post.slug}\">#{post.title}</a>"
    end
  end

  get '/' do

    if $redis.llen(:index) > 0
      @posts = redis_fetch_index
    else
      @posts = BlogFetcher.fetch
    end
    haml :index
  end

  get '/post/:perma_link' do
    perma_link = params[:perma_link]
    id = $redis.get(perma_link)
    if $redis.exists(id)
      post = redis_fetch_post(id)
    else
      post = BlogFetcher.fetch_post(id)
    end

    haml :post, locals: { post: post }
  end

  def redis_fetch_post(id)
    BlogPost.from_json($redis.get(id))
  end

  def redis_fetch_index
    index = $redis.lrange( :index, 0, -1 )
    index.inject([]) do |posts, id|
      posts << redis_fetch_post(id)
    end
  end
end
