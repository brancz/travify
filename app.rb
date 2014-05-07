require 'sinatra'
require 'json'
require 'bunny'

class TravisWebhook < Sinatra::Base
  notifications = {}

  get '/' do
    content_type 'application/json'
    notifications.to_json
  end

  post '/webhook/travis' do
    payload = JSON.parse(params[:payload])
    build_status = payload['status_message']
    build_url = payload['build_url']
    notifications[repo_slug] = {}
    notifications[repo_slug]["build_status"] = build_status
    notifications[repo_slug]["build_url"] = build_url
    response = notifications.to_json
    channel.default_exchange.publish(response, :routing_key => queue.name)
    response
  end

  def repo_slug
    env['HTTP_TRAVIS_REPO_SLUG']
  end

  def channel
    $ch
  end
  
  def queue
    $queue
  end
end

$stdout.sync = true
$conn = Bunny.new(ENV["RABBITMQ_BIGWIG_URL"])
$conn.start
$ch = $conn.create_channel
$queue = $ch.queue("notifications")
TravisWebhook.run!
