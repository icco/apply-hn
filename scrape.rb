#! /usr/bin/env ruby
#
# Scrapes posts from hn and saves them as markdown to this repo.

require "rubygems" unless defined?(Gem)
require "bundler/setup"
Bundler.require(:default)

