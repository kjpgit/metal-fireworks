.PHONY: testme

TEST = main.swift ../src/Fire.swift ../lib/Math.swift ../lib/Buffer.swift \
	../lib/Clock.swift

testme:
	swiftc -O -whole-module-optimization -o run $(TEST)
