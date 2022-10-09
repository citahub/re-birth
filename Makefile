# run this command for first time
setup:
	docker-compose run --rm app bundle exec rake db:setup DISABLE_DATABASE_ENVIRONMENT_CHECK=1

# build images
build:
	docker-compose build

# run app daemon
up:
	@mkdir -p tmp/pids
	docker-compose up -d

# run app
start:
	@mkdir -p tmp/pids
	docker-compose up

# stop app
down:
	docker-compose down

# run after update repo
update:
	docker-compose run --rm app bundle exec rake db:migrate

# enter rails console
console:
	docker-compose run --rm app rails console

ps:
	docker-compose ps
