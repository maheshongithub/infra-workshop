#!/usr/bin/env bash
sudo apt-get update
sudo apt-get install -y unzip openjdk-14-jre-headless
wget https://github.com/maheshongithub/spring-petclinic-rest/archive/refs/heads/master.zip
unzip master.zip
