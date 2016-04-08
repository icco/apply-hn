#! /usr/bin/env ruby
#
# Prints all users and their locations who have starred a repo.

require "rubygems" unless defined?(Gem)
require "bundler/setup"
Bundler.require(:default)

token = ENV["GITHUB_TOKEN"]
raise "GITHUB_TOKEN env variable is empty" if token.nil?
client = Octokit::Client.new(:access_token => token)
client.auto_paginate = true

client.stargazers("icco/Resume").each do |u|
  usr = client.user(u.login)
  puts "#{usr.login}: #{usr.location}"
end
