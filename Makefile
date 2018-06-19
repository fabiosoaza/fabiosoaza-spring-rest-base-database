docker-build-images: docker-build-postgres docker-build-liquibase	

docker-build-postgres:
	docker build . -f Dockerfile-postgres  -t fabiosoaza/spring-rest-base-database:latest

docker-build-liquibase:
	docker build . -f Dockerfile-liquibase  -t fabiosoaza/spring-rest-base-liquibase:latest

docker-run-postgres: 
	docker rm -f db || true
	docker run -d --name db -p5432:5432 --name db fabiosoaza/spring-rest-base-database:latest

docker-run-liquibase-update: 
	docker rm -f liquibase-spring-rest-base || true
	sleep 5
	docker run -d  --name liquibase-spring-rest-base --link db:db -e DB_HOST=db -e DB_NAME=test -e DB_PORT=5432 -e DB_USER=test -e DB_PASS=test -e SSL_MODE=disable -v $(shell pwd)/spring-rest-base/database-changelogs:/liquibase/changelogs/  fabiosoaza/spring-rest-base-liquibase:latest run-liquibase update 

docker-create-database: docker-build-images docker-run-postgres docker-run-liquibase-update
