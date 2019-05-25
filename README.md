# DMI-TCAT Docker Container


This is containerization of [Digital Methods Initiative Twitter
Capture and Analysis Toolset
(DMI-TCAT)](https://github.com/digitalmethodsinitiative/dmi-tcat) aimed
at easier deployment.

A few key differences with mainline DMI-TCAT:

- Web server is [Nginx](https://www.nginx.com/resources/wiki).
- Daemons run as [supervisor](http://supervisord.org/) processes.
- Web authorizations are disabled.
- URL expander is disabled.

This containerization is only tested on Linux.


## Deployment with `docker`

This covers standard installation with docker. You don't have to clone
this repository to run it, but you must prepare your MySQL connection
manually.

1.  Install [docker](https://docs.docker.com/install/linux/docker-ce/debian/#install-docker-ce-1)
    if you haven't already.

2.  Pull the image from Docker hub:

    ```
	$ docker pull rsur/tcat:latest
	```

3.  Assuming you already have MySQL up and running, create MySQL
    database and user for your TCAT installation, roughly as follows:

    ```
    $ mysql -u root
    > CREATE USER tcat IDENTIFIED BY 'seekerit';
    > CREATE DATABASE tcat_db;
    > GRANT ALL PRIVILEGES ON tcat_db.* TO 'tcat'@'%';
    > \q
    ```

4. Create a text file like containing environment variables like so:

    ```
    $ cat .env-standalone
    TCAT_ROLE=track
    TCAT_BASE_URL=http://localhost:8881/
    
    TCAT_HTTP_PORT=8881
    TCAT_CACHE_DIR=/tmp/tcat-cache
    TCAT_LOGS_DIR=/tmp/tcat-logs
    
    TCAT_DBUSER=tcat
    TCAT_DBPASS=seekerit
    TCAT_DBNAME=tcat_db
    TCAT_DBHOST=localhost

    CONS_KEY=XxXxXxXxXxXxXxXxXxXxXxXxX
    CONS_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    CONS_USER_TOKEN=YYYYYYYYY-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    CONS_USER_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    ```

    or you can just copy `_env.sample` from this repo as
    `.env-standalone` and edit from there. Make sure `TCAT_DB*`
	variables match your MySQL setup.

5.  Run the container:

    ```
    $ docker run --rm -it --env-file .env-standalone -p 8881:80 \
    > rsur/tcat-latest
    ```

    There should be log messages appearing on your screen. If something
    goes wrong, have a look at TCAT log file located at `/tmp/tcat-logs`
    as shown in sample environment file above.

6.  Open TCAT from your web browser:

    ```
    $ x-www-browser http://localhost:8881
    ```

    and do your usual TCAT activity from there.

7.  When you're done, go to terminal where docker was started, and
    press Ctrl+C.


## Deployment with `docker-compose`

This covers installation under docker-compose. The database is using
MariaDB and prepared automatically. Unless you're experimenting with
standalone deployment, this is the preferred way to go.

1.  Install docker.

2.  Install [docker-compose](https://docs.docker.com/compose/install/).

3.  Copy `_env.sample` to `.env`. Edit this file to match your settings,
    almost identical to environment file for docker above. Pay attention
    to `MARIA_DIR` variable. It's where your MariaDB working directory
    is located on your filesystem.

4.  Run `docker-compose` for testing:

    ```
    $ docker-compose up
    ```

    This will pull dependencies, create MariaDB container, and various
    other things until a web server is finally launched. The log
    messages on screen will tell you what to do if something goes wrong.
    When you're done with the test, shut down the container by pressing
    Ctrl+C.

5.  Run your container again, but this time, let it daemonized.

    ```
    $ docker-compose up -d
    ```

6.  Open TCAT from browser as usual.

7.  When you're done, go to terminal where docker-compose was started,
    and shut it down with:

	```
	$ docker-compose down
	```

**CAVEAT:** On first run, there's a chance that MariaDB database has
not yet been initialized but TCAT is already running. To overcome this,
turn off the containers as shown in 7) and turn them on again as in 5).


## TODO: Securing Installation

This setup is not for Internet deployment. Only use this on your local
computer or internal network.

