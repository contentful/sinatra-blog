require 'blog_post'
require 'date'

describe BlogPost do
  let(:date) { DateTime.now }
  let(:fields) { Hash[postTitle: 'postTitle', postBody: 'postBody', postCategory: 'postCategory', createdAt: date ] }
  let(:entry) { double('Entry', fields: fields, sys: {createdAt: date}, id: 'myrandomid') }
  let(:post) { BlogPost.new(entry) }
  subject { post }

  its(:title) { should eq 'postTitle' }
  its(:body) { should eq "<p>postBody</p>\n" }
  its(:category) { should eq 'postCategory' }
  its(:date) { should eq date }
  its(:formatted_date) { should eq '03/21/2014' }
  its(:post_id) { should eq 'myrandomid' }

  its(:slug) { should eq 'posttitle'}
  its(:redis_key_value) { should eq ['posttitle', 'myrandomid'] }

  describe '#slug' do
    it 'creates a slug without special chars' do
      fields[:postTitle] = 'title-!@#$@-good'
      expect(post.slug).to eq 'title-good'
    end

    it 'lowercases the title' do
      fields[:postTitle] = 'CAPS-LOCK'
      expect(post.slug).to eq 'caps-lock'
    end

    it 'replaces spaces with dashes' do
      fields[:postTitle] = 'title with a lot of space'
      expect(post.slug).to eq 'title-with-a-lot-of-space'
    end
  end
end
