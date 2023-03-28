#!/usr/bin/env bash

apt-get update
apt-get -y install build-essential

pip install --upgrade pip
pip install poetry==1.4.0
poetry config virtualenvs.create false && poetry install --with dev

pytest Lola/tests
pytest Menu/tests

CART_VERSION=1.0.0
CATALOG_VERSION=1.0.0
ACCOUNTING_VERSION=1.0.0

echo "publish-pacts"
pact-broker publish "*.json" --consumer-app-version=1.0.0
pact-broker publish "*.json" --consumer-app-version=1.0.0

#pytest --pact-broker-url=http://localhost:9292/ --pact-provider-name=Menu/tests/verify_pacts.py
#pytest --pact-broker-url=http://localhost:9292/ --pact-provider-name=Lola/tests/verify_pacts.py
