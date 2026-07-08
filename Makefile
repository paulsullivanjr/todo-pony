DEFINES := -Dopenssl_3.0.x

.PHONY: fetch build run clean build-dir

fetch:
	corral fetch

build: | build-dir
	corral run -- ponyc $(DEFINES) --bin-name todo --output build ./bin

run: build
	./build/todo

clean:
	rm -rf build

build-dir:
	mkdir -p build
