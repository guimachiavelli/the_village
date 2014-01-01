The Village
=====================

A simulation of a coastal village, based on Nico Muhly's score "I drink the air before me". 

There isn't a specific, final goal for this project, but the idea is:
* create a stage village with buildings, characters and terrain 
* said characters interact more or less randomly and depending on specific events
* these interactions will generate different phrases of the story of said village
* the story of the village will eventually end and we'll have a small, pseudo-generative narrative
* the story will be stored and a new village will be created

this is also a bit of a formal exercise, trying to keep frameworks, libraries and plugins to a minimum, at the same time trying my hand at and practice several technologies and techniques I'm interested in: BDD/TDD via mocha/chai, coffeescript, grunt, websockets and node. 


## Code structure

More to come here, but, for now, as a quick description:

* **lib/**: contains all the code related to the actual "village", from basic elements to pathfinding logic
* **test/**: contains all the tests for the logic of the village, from world creation to event handling to the character's actions. all tests use mocha/chai.
* **routes/**: contains all the routing, which is quite basic at this time, and, I imagine, will not grow on complexity that much
* **views/**: templates, for now just a basic index page to keep an eye on things I can't monitor that well with tests right now
* **public/**: public files, such as images, css and js files
* **village.coffee**: responsible for getting all the dependencies and creating the actual village
* **app.coffee**: server config and startup, also bootstraps the village process
