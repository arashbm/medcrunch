#!/usr/bin/env ruby
# encoding: utf-8

require 'reader'

# queues all files
ARGV.each do |filename|
  ArticleReaderWorker.perform_async filename
end
