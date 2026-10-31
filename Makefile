CMDSTAN_VERSION ?= 2.40.0
CMDSTAN_ROOT ?= $(HOME)/.cmdstan
CMDSTAN_HOME ?= $(CMDSTAN_ROOT)/cmdstan-$(CMDSTAN_VERSION)

.PHONY: install check test
install:
	mkdir -p $(CMDSTAN_ROOT)
	curl -fsSL https://github.com/stan-dev/cmdstan/releases/download/v$(CMDSTAN_VERSION)/cmdstan-$(CMDSTAN_VERSION).tar.gz \
		| tar -xz -C $(CMDSTAN_ROOT)
	$(MAKE) -C $(CMDSTAN_HOME) build -j4

check:
	@test -d $(CMDSTAN_HOME) || { echo "Missing $(CMDSTAN_HOME)"; exit 1; }
	@for tool in stanc stansummary diagnose; do \
		test -x $(CMDSTAN_HOME)/bin/$$tool || { echo "Missing bin/$$tool: run make install-cmdstan"; exit 1; }; \
	done
	@$(CMDSTAN_HOME)/bin/stanc --version
	@echo "CmdStan $(CMDSTAN_VERSION) present at $(CMDSTAN_HOME)"

test: check
	$(MAKE) -C $(CMDSTAN_HOME) examples/bernoulli/bernoulli
	@tmp=$$(mktemp -d) && trap 'rm -rf "$$tmp"' EXIT && \
	$(CMDSTAN_HOME)/examples/bernoulli/bernoulli sample \
	    data file=$(CMDSTAN_HOME)/examples/bernoulli/bernoulli.data.json \
	    output file=$$tmp/output.csv > /dev/null && \
	test $$(grep -vc '^#' $$tmp/output.csv) -ge 1001 && \
	$(CMDSTAN_HOME)/bin/stansummary $$tmp/output.csv && \
	echo "CmdStan smoke test passed"

