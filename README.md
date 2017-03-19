moodle
=============

A Dockerfile that installs and runs the latest Moodle 3.2 stable, with external MySQL Database.

Tags:
* latest - 3.2 stable

## Installation

```
git clone https://github.com/klasuk/moodle
cd moodle
docker build -t moodle .
```

## Usage

To spawn a new instance of Moodle + smtp + db:

```
docker run -d --name DB -p 3306:3306 -e MYSQL_DATABASE=moodle -e MYSQL_ROOT_PASSWORD=moodle -e MYSQL_USER=moodle -e MYSQL_PASSWORD=moodle mysql
docker run -d -e POSTFIX_myhostname=mysmtp.test.local --name smtp     mwader/postfix-relay
docker run -d -P --name moodle --link DB:DB --link smtp:smtp -e MOODLE_URL=http://192.168.100.20:8080 -e DB_ENV_MYSQL_DATABASE="moodle" -e DB_ENV_MYSQL_USER="moodle" -e MYSQL_PASSWORD=mdlPazz1 -p 8080:80 klasu78/moodle
```

Moodledata will be swapped every time. Mount data from system.

```
docker volume create --name moodledata
docker run -d -P --name moodle -v moodledata:/var/moodledata --link DB:DB --link smtp:smtp -e MOODLE_URL=http://192.168.100.20:8080 -e DB_ENV_MYSQL_DATABASE="moodle" -e DB_ENV_MYSQL_USER="moodle" -e MYSQL_PASSWORD=mdlPazz1 -p 8080:80 klasu78/moodle
```

You can visit the following URL in a browser to get started:

```
http://192.168.100.20:8080 
```

## Caveats
The following aren't handled, considered, or need work: 
* Moodle cronjob not running. Executed by docker it
* log handling (stdout?)

## Credits

This version based on https://github.com/jmhardison
This is a fork of [Jon Auer's](https://github.com/jda/docker-moodle) Dockerfile.
This is a reductionist take on [sergiogomez](https://github.com/sergiogomez/)'s docker-moodle Dockerfile.

