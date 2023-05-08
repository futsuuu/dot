.PHONY: build
build: smpt nvim

.PHONY: smpt
smpt:
	@echo ""
	@echo "# release build of smpt"
	@cd smpt && cargo build --release

.PHONY: nvim
nvim:
	@echo ""
	@echo "# generate colorscheme for neovim"
	@cd dot/neovim/generator/robot && deno task run
