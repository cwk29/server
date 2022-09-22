# GraphQL API Server

This is a server that connects to a MongoDB database accepting requests from our frontend Angular UI.

## How to run locally

1. Run a MongoDB container exposing PORT 27017
1. `npm start`

## How to run as a container from our image

1. `docker build . -t server:latest`
1. Run a MongoDB container exposing PORT 27017
1. Get IP of running MongoDB container
1. `docker run server:latest -p 4000 -e MONGO_DB_URI=mongodb://your-mongo-ip:27017` --> env var doesn't work on CLI but does through Docker Desktop
