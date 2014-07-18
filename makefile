build:
	coffee --compile --output js/ src/
build-watch:
	coffee -o js/ -cw src/
run:
	nodemon js/index.js