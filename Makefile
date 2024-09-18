ML_SRC := './src/[a-zA-Z0-9_]+.ml'
JS_SRC := './_build/default/src/*.js'
CSS_OUT := './www/main.css'
WWW := './www'
PROFILE := 'dev'

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
		--outdir=$(WWW) \
		$(JS_SRC)

.PHONY: bundle-watch
bundle-watch:
	npm x -- esbuild $(JS_SRC) \
		--log-level=error \
		--bundle \
		--outdir=$(WWW) \
		--watch \
		--servedir=$(WWW)

tailwindcss:
	npm x -- \
		tailwindcss -o $(CSS_OUT) --content $(ML_SRC)

tailwindcss-watch:
	npm x -- \
		tailwindcss -o $(CSS_OUT) --content $(ML_SRC) -w

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
