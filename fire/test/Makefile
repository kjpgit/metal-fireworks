.PHONY: testme

TEST = main.swift ../Fire.swift ../Math.swift ../Buffer.swift

testme:
	swiftc -O -whole-module-optimization -o run $(TEST)
