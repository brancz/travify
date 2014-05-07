#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"
require "json"
require "libnotify"

conn = Bunny.new(ENV["RABBITMQ_BIGWIG_URL"], :automatically_recover => false)
conn.start

ch = conn.create_channel
q = ch.queue("notifications")

begin
  puts "Waiting for messages. To exit press CTRL+C"
  q.subscribe(:block => true) do |delivery_info, properties, body|
    notifications = JSON.parse(body)
    notifications.each do |k,v|
      Libnotify.show summary: "Travis Build #{k}", body: v["build_status"]
      #v["build_url"]
    end
  end
rescue Interrupt => _
  conn.close

  exit(0)
end
