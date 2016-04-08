#! /usr/bin/env ruby
#
# Scrapes posts from hn and saves them as markdown to this repo.

require "rubygems" unless defined?(Gem)
require "bundler/setup"
Bundler.require(:default)

require "pp"

posts = {}

page = 0
loop do
  # https://hn.algolia.com/api/v1/search_by_date?query=%22apply%20hn%22
  p page
  params = {
    query: "apply hn",
    hitsPerPage: 50,
    page: page,
  }
  request = Typhoeus::Request.new("https://hn.algolia.com/api/v1/search_by_date", method: :get, params: params, headers: {})

  resp = request.run
  jsn = JSON.parse resp.response_body

  break if jsn["nbPages"] <= page

  jsn["hits"].each do |e|
    posts[e["objectID"]] = { title: e["title"], text: e["story_text"] }
  end

  page += 1
end
