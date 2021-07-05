.EXPORT_ALL_VARIABLES:

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

PROJECT_NAME=demo
PROJECT_VERSION=0.0.dev0
FULLNAME=${PROJECT_NAME}-${PROJECT_VERSION}
PACKAGE_NAME=${FULLNAME}-py3-none-any.whl

default: isset-PROJECT_NAME
	@echo "Tasks in \033[1;32m${PROJECT_NAME}\033[0m:"
	@cat Makefile

isset-%:
	@if [ -z '${${*}}' ]; then echo 'ERROR: variable $* not set' && exit 1; fi

notebook:
	@jupyter notebook --ip=0.0.0.0 --allow-root notebooks

lint:
	mypy src/* --ignore-missing-imports
	flake8 src --ignore=$(shell cat .flakeignore)

dev:
	pip install -e .

test: dev
	pytest --doctest-modules --junitxml=junit/test-results.xml
	bandit -r src -f xml -o junit/security.xml || true

build: clean
	pip install wheel
	python setup.py bdist_wheel

clean:
	@rm -rf .pytest_cache/ .mypy_cache/ junit/ build/ dist/
	@find . -not -path './.venv*' -path '*/__pycache__*' -delete
	@find . -not -path './.venv*' -path '*/*.egg-info*' -delete

documentation: isset-PROJECT_NAME
	rm -rf doc/build
	rm -rf doc/source/docstring
	sphinx-apidoc -f -o docs/source/docstring src/${PROJECT_NAME}
	cd docs && make html

installable: isset-PROJECT_NAME isset-FULLNAME dev
	pyinstaller -D -F -n ${FULLNAME}.exe -c src/${PROJECT_NAME}/main.py --icon=res/${PROJECT_NAME}.ico

dockerize: build
	docker build --rm -f "Dockerfile" -t demo .

run:
	docker run --rm -it demo

install-package-databricks: isset-PACKAGE_NAME isset-CLUSTERID
	@echo Installing 'dist/${FULLNAME}' on databricks...
	databricks fs cp dist/${PACKAGE_NAME} dbfs:/libraries/${PACKAGE_NAME} --overwrite
	databricks libraries install --whl dbfs:/libraries/${PACKAGE_NAME} --cluster-id ${CLUSTERID}

install-package-synapse: isset-WHEELNAME isset-SYNAPSE_WORKSPACE_NAME isset-SYNAPSE_SPARKPOOL_NAME isset-SYNAPSE_SA_NAME isset-SYNAPSE_CONTAINER_NAME
	@echo Installing 'dist/${PACKAGE_NAME}' on azure synapse...
	az storage fs file upload \
		-s dist/${PACKAGE_NAME} \
		-p synapse/workspaces/${SYNAPSE_WORKSPACE_NAME}/sparkpools/${SYNAPSE_SPARKPOOL_NAME}/libraries/python/${PACKAGE_NAME} \
		-f ${SYNAPSE_CONTAINER_NAME} \
		--account-name ${SYNAPSE_SA_NAME} \
		--auth-mode login \
		--overwrite
