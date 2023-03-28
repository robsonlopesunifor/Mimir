.PHONY: create-pacts
create-pacts:
	docker-compose exec lola pytest
	docker-compose exec menu pytest

LOLA_VERSION=1.0.0
MENU_VERSION=1.0.0

.PHONY: publish-pacts
publish-pacts:
	docker-compose exec lola pact-broker publish "tests/pacts/*.json" --consumer-app-version=$(LOLA_VERSION)
	docker-compose exec menu pact-broker publish "tests/pacts/*.json" --consumer-app-version=$(MENU_VERSION)


.PHONY: verify-pacts
verify-pacts:
	docker-compose exec menu pytest \
		--pact-publish-results \
		--pact-provider-name=Provider-Menu \
		--pact-provider-version=$(CATALOG_VERSION) \
		tests/verify_pacts.py

.PHONY: up
up:
	docker-compose up -d

.PHONY: down
down:
	docker-compose down

.PHONY: contract-tests
contract-tests:
	make up
	make create-pacts
	make publish-pacts
	make verify-pacts
	make down

