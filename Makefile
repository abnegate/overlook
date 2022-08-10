all: build

build:
	@swift build 

install:
	@mv .build/release/overlook /usr/local/bin/

clean:
	@swift package clean

xcode:
	@rm -rf overlook.xcodeproject
	@swift package generate-xcodeproj

run: build
	@.build/debug/overlook

release: clean
	@swift build --configuration release

