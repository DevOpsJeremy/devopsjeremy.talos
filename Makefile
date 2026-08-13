.PHONY: docs-reqs

COLLECTION_NAME ?= devopsjeremy.talos
DOCS_DIR ?= docs
DOCS_BUILD_DIR ?= build
DOCS_BUILD_SCRIPT_NAME ?= build.sh
DOCS_BUILD_SCRIPT ?= $(DOCS_BUILD_DIR)/$(DOCS_BUILD_SCRIPT_NAME)
HTML_DIR ?= $(DOCS_BUILD_DIR)/build/html
ANTSIBULL_DOCS_CONFIG ?= antsibull-docs.cfg

base-reqs:
	pip install ansible-core

docs-reqs:
	pip install \
		'antsibull-docs>=2.0.0,<3.0.0' \
		ansible-pygments \
		sphinx \
		'sphinx-ansible-theme>=0.9.0'

$(HTML_DIR):
	bash $(DOCS_BUILD_SCRIPT)

docs-build: $(HTML_DIR)

$(DOCS_DIR):
	$(MAKE) docs-reqs
	mkdir $(DOCS_BUILD_DIR) || true
	antsibull-docs sphinx-init --fail-on-error --use-current --dest-dir $(DOCS_BUILD_DIR) $(COLLECTION_NAME)
	$(MAKE) docs-build

collection-install:
	$(MAKE) base-reqs
	ansible-galaxy collection install --force .
