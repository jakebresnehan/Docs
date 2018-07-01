build-docs:
	rm -rf .docz
	npm run build
	cp -r assets .docz/dist

netlify:
	make build-docs
	cp .netlify/_redirects .docz/dist
