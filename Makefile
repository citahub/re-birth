# run this command for first time
setup:
	docker-compose build
	docker-compose run --rm app bundle exec rake db:setup

# build images
build:
	docker-compose build

# run app daemon
up:
	docker-compose up -d

# run app
start:
	docker-compose up

# stop app
down:
	docker-compose down

# run after update repo
update:
	docker-compose build
	docker-compose run --rm app bundle exec rake db:migrate

# enter rails console
console:
	docker-compose run --rm app rails console

ps:
	docker-compose ps
