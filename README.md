## Start Projet

```
1) Prerequis
```
- installer [docker](https://www.docker.com/) et 
[docker-compose](https://docs.docker.com/compose/install/)
  

## Init project

- Default project is Stan
```
$ docker-compose run web create-react-native-app stan-app
```

- Create new projet react app
```
$ docker-compose run web create-react-app stan-app
```

## COMMAND

- execute with npm
```
$ docker run -v ${PWD}:/app react-cli npm [command]
```

- execute with yarn
```
$ docker run -v ${PWD}:/app react-cli yarn [command]
```