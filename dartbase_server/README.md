# dartbase_server

A RESTful server implementation for the Cheap Ass Game "Starbase Jeff" in Dart.

##What is this?##

This repository contains a simple RESTful server implementation for
playing the Cheap Ass Game "Starbase Jeff". It's my favorite board game ever.

##Getting Started##
1. Download the Dart Editor from [dartlang.org](https://www.dartlang.org).
2. Clone this project to a folder.
3. In the Dart Editor, go to File -> "Open Existing Folder" and open the cloned project folder
4. Make sure you have the required dependencies specified in `pubspec.yaml`. If you're missing
any of these, try selecting a file in the project, and then running Tools > Pub Get, and
Tools > Pub Upgrade if that fails.

##Running##
1. To run the server right-click on the `main.dart` file and select Run to start the server on your
local machine.
2. Go to `http://localhost:8080/serverStatus` to test that your server is returning data. See `dartbase_server.dart`
for other routes.

##Testing##
1. To run the unit tests right-click on the `test\all.dart` file and select Run.
You should see console output saying All X tests passed.

Project Status
--------------

### Completed

* Grabbed server template, basic pieces from other projects and setup in github
* Card and board static data
* Card and board utility methods
* Game and round data objects
* Game logic for making initial card selections
* Legal placement detection

### Todo
* Initial REST routes for getting game data
* Game data resource/actor
* Game Logic (game data, players, turn logic, move logic)
* Legal sabotage detection
* Multiple simultaneous games allowed
* Move/game history log which stores/logs all moves played
* Server game state CRUD via messages
* Send game data as JSON object
* Receive player info and start game
* Receive move submissions
* Update state on move submission
* Text client via REST interface
* Run file input through text client for testing
* Possibly send out a "game over" message directly to clients
* Index web page with instructions and link to client
* Web GUI client
* AI players (random, simple, smart)
* Watch AI-only game
* Auto-refreshing game viewer
* More codeship settings for deploying the server and running application tests
* Advanced Jeff rules (capsules)

### Routes
Plan for routes to be implemented:

    GET     /                     # Index page, welcome message
    GET     /games                # Get a list of games in progress
    POST    /games                # Post a new game request
    GET     /games/:id            # Get data for a game
    DELETE  /games/:id            # End a game
    PUT     /games/:id/player     # Add a player to a game
    GET     /games/:id/player/:pid  # get data for player
    PUT     /games/:id/start      # Start a game if enough players
    GET     /games/:id/move       # Get allowable moves given a card type
    PUT     /games/:id/move       # Send a move

Development Tools
-----------------
* [Dart](https://www.dartlang.org) Dart programming language, SDK, and IDE from Google
* [Redstone](http://redstonedart.org) Dart package for doing RESTful web server routes
* [Github](https://github.com/Mixolyde/dartless_server) GIT version control repository
* [Postman](http://www.getpostman.com/) Easy and powerful REST API testing toolkit
* [Codeship](https://codeship.com) Easy automated build and deployment service
* [Coveralls](https://coveralls.io/) Web service for hosting unit test Code Coverage reports
* [dart-coveralls](https://github.com/duse-io/dart-coveralls) Tool for calculating unit test code coverage and auto-posting it to coveralls.io

Continuous Integration
----------------------
See the current [build project](https://codeship.com/projects/78160), or use Codeship to create your own.

##Build Status##
[ ![Codeship Status for Mixolyde/dartbasejeff](https://codeship.com/projects/01d6eb50-d5c5-0132-a9ce-26dfd4cc1a97/status?branch=master)](https://codeship.com/projects/78160)

[![Coverage Status](https://coveralls.io/repos/Mixolyde/dartbasejeff/badge.svg?branch=master)](https://coveralls.io/r/Mixolyde/dartbasejeff?branch=master)
