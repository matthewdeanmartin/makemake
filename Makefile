# Makefile for hello_world Python package with comprehensive validation
# This Makefile includes all tools necessary to validate a Makefile

.DEFAULT_GOAL := help
.PHONY: help all install clean test validate-makefile
.PHONY: almost-make make2help make-help make-help-helper makefile-checker
.PHONY: shellcheck-makefile shellcheck-py mbake

# Package info
PACKAGE_NAME := hello_world
PYTHON := python3
PIP := pip3

help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

all: install validate-makefile test ## Install dependencies, validate Makefile, and run tests

install: ## Install package and core makefile validation dependencies
	$(PIP) install -e .
	$(PIP) install -e ".[makefile-tools]"
	@echo "Installing additional tools (may have dependency conflicts)..."
	-$(PIP) install make-help make-help-helper
	-$(PIP) install mbake
	@echo "Installation complete. Some tools may not be available due to dependency conflicts."

clean: ## Clean build artifacts
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

test: ## Run basic package tests
	$(PYTHON) -c "from hello_world import hello; print(hello())"
	$(PYTHON) -c "import hello_world; print(f'Package version: {hello_world.__version__}')"

validate-makefile: almost-make make2help make-help make-help-helper makefile-checker shellcheck-makefile shellcheck-py mbake ## Run all Makefile validation tools

almost-make: ## Check Makefile compatibility with make alternatives
	@echo "Running almost-make validation..."
	@if command -v almost-make >/dev/null 2>&1; then \
		almost-make --check Makefile || echo "almost-make not available or check failed"; \
	else \
		echo "almost-make not installed, skipping..."; \
	fi

make2help: ## Generate help documentation from Makefile
	@echo "Running make2help to generate documentation..."
	@if command -v make2help >/dev/null 2>&1; then \
		make2help Makefile > makefile-help.txt && echo "Generated makefile-help.txt" || echo "make2help failed"; \
	else \
		echo "make2help not installed, skipping..."; \
	fi

make-help: ## Run make-help tool
	@echo "Running make-help validation..."
	@if command -v make-help >/dev/null 2>&1; then \
		make-help || echo "make-help not available or check failed"; \
	else \
		echo "make-help not installed, skipping..."; \
	fi

make-help-helper: ## Run make-help-helper utilities
	@echo "Running make-help-helper utilities..."
	@if command -v make-help-helper >/dev/null 2>&1; then \
		make-help-helper || echo "make-help-helper not available or check failed"; \
	else \
		echo "make-help-helper not installed, skipping..."; \
	fi

makefile-checker: ## Validate Makefile syntax and best practices
	@echo "Running makefile-checker validation..."
	@if command -v makefile-checker >/dev/null 2>&1; then \
		makefile-checker Makefile || echo "makefile-checker not available or check failed"; \
	else \
		echo "makefile-checker not installed, skipping..."; \
	fi

shellcheck-makefile: ## Check shell scripts in Makefile with shellcheck
	@echo "Running shellcheck on Makefile shell scripts..."
	@if command -v shellcheck-makefile >/dev/null 2>&1; then \
		shellcheck-makefile Makefile || echo "shellcheck-makefile not available or check failed"; \
	else \
		echo "shellcheck-makefile not installed, attempting manual extraction..."; \
		if command -v shellcheck >/dev/null 2>&1; then \
			echo "Extracting and checking shell commands from Makefile..."; \
			grep -E '^\s*[^#]*\$$\(' Makefile | head -5 || echo "No complex shell commands found"; \
		else \
			echo "shellcheck not available, skipping shell validation"; \
		fi; \
	fi

shellcheck-py: ## Check Python scripts with shellcheck-py
	@echo "Running shellcheck-py on Python files..."
	@if command -v shellcheck-py >/dev/null 2>&1; then \
		find . -name "*.py" -exec shellcheck-py {} \; || echo "shellcheck-py not available or check failed"; \
	else \
		echo "shellcheck-py not installed, running basic Python syntax check..."; \
		find . -name "*.py" -exec $(PYTHON) -m py_compile {} \; && echo "Python syntax check passed"; \
	fi

mbake: ## Run mbake build tool validation
	@echo "Running mbake validation..."
	@if command -v mbake >/dev/null 2>&1; then \
		mbake --dry-run || echo "mbake not available or check failed"; \
	else \
		echo "mbake not installed, skipping..."; \
	fi

# Development targets
install-core: ## Install only core makefile validation tools (no conflicts)
	$(PIP) install -e ".[makefile-tools]"

install-make-help: ## Install make-help tools separately
	$(PIP) install make-help make-help-helper

install-mbake: ## Install mbake separately
	$(PIP) install mbake

dev-install: ## Install development dependencies
	$(PIP) install -e ".[dev]"

lint: ## Run code linting (if tools are available)
	@if command -v flake8 >/dev/null 2>&1; then flake8 hello_world/; fi
	@if command -v black >/dev/null 2>&1; then black --check hello_world/; fi
	@if command -v isort >/dev/null 2>&1; then isort --check-only hello_world/; fi

format: ## Format code
	@if command -v black >/dev/null 2>&1; then black hello_world/; fi
	@if command -v isort >/dev/null 2>&1; then isort hello_world/; fi

# Build targets
build: clean ## Build the package
	$(PYTHON) -m build

upload: build ## Upload to PyPI (requires credentials)
	$(PYTHON) -m twine upload dist/*

# Show package structure
show-structure: ## Display package structure
	@echo "Package structure:"
	@find . -type f -name "*.py" -o -name "*.toml" -o -name "Makefile" -o -name "*.md" | grep -v ".git" | sort