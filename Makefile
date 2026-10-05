.PHONY: build investigate remediate test clean
build:
	./scripts/build.sh
investigate: build
	./scripts/investigate.sh
remediate: build
	./scripts/remediate.sh
test:
	./scripts/test.sh
clean:
	rm -f data/helpdesk.db
