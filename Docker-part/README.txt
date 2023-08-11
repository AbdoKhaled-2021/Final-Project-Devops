- With the help of "os module" is python, I was able to save the db logins in environmental variable to be passed in the docker compose or K8s manifest later on
- Dockerfile created with the help of: https://www.google.com/search?q=how+to+build+image+for+python+application&rlz=1C1JZAP_enDE905DE906&oq=how+to+build+image+for+python+application&aqs=chrome..69i57j0i22i30l2.10175j0j4&sourceid=chrome&ie=UTF-8#fpstate=ive&vld=cid:8b4ab585,vid:0eMU23VyzR8
- Requirements usually shared by the developers
- The db dockerfile is just the image of the mysql server and then I copy the locally created db to be initialized by the container when created
- In the docker-compose file:
	I pass the variables needed by the app.py file (where the MYSQL_DATABASE_HOST = mysql-database (the name of the db service) --> It's more like k8s, where the ClusterIP exposes db)
	The MYSQL_ROOT_PASSWORD has to be passed to the container
	If I was not building my own image in the db section:
		I would have added "image: mysql" instead of the "build:" section
		And in this case I would have copied my locally created db by adding the following section:
			volumes:
      			  - ./MySQL_Queries:/docker-entrypoint-initdb.d/:ro