DEFINES := -Dopenssl_3.0.x
TAILWIND := ./tailwindcss

.PHONY: fetch css css-watch build run clean build-dir

fetch:
	corral fetch

css:
	$(TAILWIND) -i assets/tailwind.css -o assets/app.css --minify

css-watch:
	$(TAILWIND) -i assets/tailwind.css -o assets/app.css --watch

build: css | build-dir
	corral run -- ponyc $(DEFINES) --bin-name todo --output build ./bin

run: build
	./build/todo

clean:
	rm -rf build

build-dir:
	mkdir -p build
