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
  params = {
    query: "apply hn",
    hitsPerPage: 50,
    page: page,
    tags: "story",
    numericFilters: "created_at_i>=#{Chronic.parse("2016-04-06T18:19:31.000").to_i}",
  }
  p params
  request = Typhoeus::Request.new("https://hn.algolia.com/api/v1/search_by_date", method: :get, params: params, headers: {})

  resp = request.run
  jsn = JSON.parse resp.response_body

  if jsn["error"]
    p jsn
    exit
  end

  break if jsn["nbPages"] <= page

  jsn["hits"].each do |e|
    # posts[e["objectID"]] = { title: e["title"], text: e["story_text"] }
    filename = "posts/#{e["objectID"]}.md"
    if !File.exist? filename
      if e["title"] && e["story_text"]
        text = <<-EOT
# #{e["title"]}

#{e["story_text"]}
        EOT

        File.open(filename, "w") {|f| f.write text }
      end
    end
  end

  page += 1
end
