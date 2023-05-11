# Variables
CHART_NAME := gtm-cloud-helm
CHART_VERSION := $(shell yq e '.version' Chart.yaml)
NAMESPACE := my-namespace
RELEASE_NAME := my-release

# Tasks
.PHONY: lint
lint:
	@echo "==> Linting the chart"
	helm lint .

.PHONY: install
install:
	@echo "==> Installing the chart"
	helm install $(RELEASE_NAME) . --namespace $(NAMESPACE) --create-namespace --wait

.PHONY: upgrade
upgrade:
	@echo "==> Upgrading the chart"
	helm upgrade $(RELEASE_NAME) . --namespace $(NAMESPACE)

.PHONY: uninstall
uninstall:
	@echo "==> Uninstalling the chart"
	helm uninstall $(RELEASE_NAME) --namespace $(NAMESPACE)

.PHONY: dry-run
dry-run:
	@echo "==> Rendering templates (dry-run)"
	helm template $(RELEASE_NAME) . --namespace $(NAMESPACE)

.PHONY: test
test: lint dry-run
	@echo "==> Running chart tests"
	helm test $(RELEASE_NAME) --namespace $(NAMESPACE)

.PHONY: package
package:
	@echo "==> Packaging the chart"
	helm package . --destination . --version $(CHART_VERSION)

.PHONY: clean
clean:
	@echo "==> Cleaning up"
	rm -f $(CHART_NAME)-*.tgz
