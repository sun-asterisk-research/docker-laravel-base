generate:
	@./generate.sh
	@for versions in $$(ls versions_*.yml); do \
		APPEND=true ./generate.sh $$versions || exit 1; \
	done

clean:
	@./generate.sh clean
	@for versions in $$(ls versions_*.yml); do \
		./generate.sh clean $$versions || exit 1; \
	done

# Validate every versions file first, so a bad one stops make all before anything is removed
check:
	@for versions in versions.yml $$(ls versions_*.yml); do \
		./generate.sh check $$versions || exit 1; \
	done

all: check clean generate
