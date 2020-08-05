
docker cp config/parameters.yml cse301-sulu-docker:/var/www/sulu-standard/app/config/parameters.yml
docker exec cse301-sulu-docker bash -c 'su - www-data -c "sulu-standard/app/console sulu:build dev --no-interaction"'