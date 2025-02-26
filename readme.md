Moztopia Devstation - This is a basic empty project using the primary stacks that we tend to work with in house.

You need to change:

application.code-workspace :: All references to 'devstation' should be renamed to your project root folder name.

docker-compose.yml :: Configure the .env file for a new project ... except the network name. .. configure that in the docker-compose.yml file.

Remember, this is very alpha-y software and you should use at your own risk. We welcome feedback.
