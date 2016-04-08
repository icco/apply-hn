#! /usr/bin/env ruby
#
# Prints all git ssh urls for repos owned by HRC.

require "rubygems" unless defined?(Gem)
require "bundler/setup"
Bundler.require(:default)

token = ENV["GITHUB_TOKEN"]
raise "GITHUB_TOKEN env variable is empty" if token.nil?
client = Octokit::Client.new(:access_token => token)
client.auto_paginate = true

client.org_repos("Google").each do |r|
  puts r.ssh_url
end
