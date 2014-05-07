Travify
=======

Travis notification hub, with push notifications based on RabbitMQ.

For local tests:

	export RABBITMQ_BIGWIG_URL=amqp://localhost

For use with heroku:

	heroku create
	heroku addons:add rabbitmq-bigwig

Then point the travis hook to `appname.herokuapp.com/webhook/travis`
