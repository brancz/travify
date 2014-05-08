Travify
=======

Travis notification hub, with push notifications based on RabbitMQ.

For local tests:

	export RABBITMQ_BIGWIG_URL=amqp://localhost

For use with heroku:

	heroku create
	heroku addons:add rabbitmq-bigwig

Then point the travis hook to `appname.herokuapp.com/webhook/travis`

For the client you will need to have libnotify-dev and the corresponding rubygem
installed.

	sudo apt-get install libnotify-dev
	gem install libnotify

Then you can start the client.

	ruby -rubygems receive.rb
