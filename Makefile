PWD=$(shell pwd)
CONTAINER_NAME=react-cli
FIG=docker run
EXEC=docker exec -it
BASH_EXEC=/bin/bash -c
PROJECT_NAME=${appname}
USER=${user}

.PHONY: help start createApp runAndroid runIos
.PHONY: build web/built start/app

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'


##
## Project setup
##---------------------------------------------------------------------------

start:				## Install and start the project. usage: make start user=$USER
start: web/built desactived/adb
	$(EXEC) $(CONTAINER_NAME) $(BASH_EXEC) "react-native init stan && cd stan/ && npm install"

startApp:			## start the container and the app usage: make startApp appname=arg
startApp:
	docker start $(CONTAINER_NAME) && make runAndroid appname=$(PROJECT_NAME)
	

createApp:			## Create App usage: make createApp appname=arg
createApp:
	$(EXEC) $(CONTAINER_NAME) $(BASH_EXEC) "react-native init $(PROJECT_NAME) && cd $(PROJECT_NAME) && npm install"


runAndroid:			## Run Android usage: make runAndroid appname=arg
runAndroid:
	$(EXEC) $(CONTAINER_NAME) $(BASH_EXEC) "cd $(PROJECT_NAME) && react-native run-android"


runIos:				## Run Ios usage: make runIos appname=arg
runIos:
	$(EXEC) $(CONTAINER_NAME) $(BASH_EXEC) "cd $(PROJECT_NAME) && react-native run-ios"

runAndroidLog:			## Run Android Log usage: make runAndroidLog appname=arg
runAndroidLog:
	$(EXEC) $(CONTAINER_NAME) $(BASH_EXEC) "cd $(PROJECT_NAME) && react-native log-android"


runIosLog:			## Run Ios Log usage: make runIosLog appname=arg
runIosLog:
	$(EXEC) $(CONTAINER_NAME) $(BASH_EXEC) "cd $(PROJECT_NAME) && react-native log-android"


startAppOnNewPc:			## Create and start a new container and start the app usage: make startApp appname=arg 
startAppOnNewPc: build web/built desactived/adb
	$(EXEC) $(CONTAINER_NAME) $(BASH_EXEC) "cd $(PROJECT_NAME) && npm install && react-native run-android"


startNpm:			## Run Npm start usage: make startNpm appname=arg
startNpm:
	$(EXEC) $(CONTAINER_NAME) $(BASH_EXEC) "cd $(PROJECT_NAME) && npm start"


dockerStop:			## Stop the container usage: make dockerStop
dockerStop:
	docker stop $(CONTAINER_NAME)



# Internal rules
desactived/adb:
	adb devices
	adb kill-server

build:
	docker build --build-arg user=$(USER) -t react-cli .

web/built: build
	$(FIG) -it -d --privileged -v $(PWD):/app -v /dev/bus/usb:/dev/bus/usb --name=react-cli react-cli
