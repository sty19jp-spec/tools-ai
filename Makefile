.PHONY: help new-tool

help:
	@echo "targets:"
	@echo "  new-tool name=<toolname>   Create a new tool skeleton under tools/"

new-tool:
	@test -n "$(name)" || (echo "ERROR: name is required. Usage: make new-tool name=antigravity" && exit 1)
	@mkdir -p tools/$(name)
	@test -f tools/$(name)/README.md || echo "# $(name)" > tools/$(name)/README.md
	@echo "Created tools/$(name)/"
