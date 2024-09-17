SRC := ./_build/default/src/main.bc.js
BUNDLE := ./www/bundle.js
CSS := ./www/bundle.css
WWW := ./www
PROFILE := dev

.PHONY: build
build:
	dune build --profile=$(PROFILE)

.PHONY: watch
watch:
	dune build -w --profile=$(PROFILE)

.PHONY: bundle
bundle: build
	npm x -- esbuild \
		--log-level=error \
		--bundle \
		--minify \
		--outfile=$(BUNDLE) \
		$(SRC)

.PHONY: bundle-watch
bundle-watch:
	npm x -- esbuild $(SRC) \
		--log-level=error \
		--bundle \
		--outfile=$(BUNDLE) \
		--watch \
		--servedir=$(WWW)

tailwindcss:
	npm x -- \
		tailwindcss -o $(CSS) --content "./src/[a-zA-Z0-9_]+.ml"

tailwindcss-watch:
	npm x -- \
		tailwindcss -o $(CSS) --content "./src/[a-zA-Z0-9_]+.ml" -w

.PHONY: serve
serve: build
	npm x -- concurrently \
		'make watch' \
		'make tailwindcss-watch' \
		'make bundle-watch'
	
.PHONY: dist
dist:
	make tailwindcss
	make PROFILE=release bundle

.PHONY: clean
clean:
	dune clean
