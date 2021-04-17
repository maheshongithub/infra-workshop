#!/usr/bin/env bash

export SPRING_DATASOURCE_URL=${jdbc_url}
export SPRING_DATASOURCE_PASSWORD=${postgres_user_password}

cd /home/ubuntu/spring-petclinic-rest-master
./mvnw spring-boot:run &
