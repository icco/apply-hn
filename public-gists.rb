#! /usr/bin/env ruby
#
# Lists public gists and all raw files for public gists of users in the HRC
# org.

require "rubygems" unless defined?(Gem)
require "bundler/setup"
Bundler.require(:default)

token = ENV["GITHUB_TOKEN"]
raise "GITHUB_TOKEN env variable is empty" if token.nil?
client = Octokit::Client.new(:access_token => token)
client.auto_paginate = true

client.organization_members("HillaryClinton").each do |u|
  gists = client.gists(u.login)

  puts " --- #{u.login}: #{gists.count}"
  gists.each do |g|

    puts " --- --- #{g.html_url}"
    g.files.each do |_, f|
      puts " * #{f.raw_url}"
    end
  end
end
