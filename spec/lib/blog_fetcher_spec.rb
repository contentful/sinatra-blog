require 'blog_fetcher'

describe BlogFetcher do
  let(:fetcher) { BlogFetcher.new }
  subject { fetcher }
  its(:client) {should be_instance_of Contentful::Client }
end
