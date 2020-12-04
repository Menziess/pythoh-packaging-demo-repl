.EXPORT_ALL_VARIABLES:

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

default:
	@echo "Tasks in \033[1;32mpython-packaging\033[0m:"
	@cat Makefile

isset-%:
	@if [ -z '${${*}}' ]; then echo 'ERROR: variable $* not set' && exit 1; fi

notebook:
	@jupyter notebook --ip=0.0.0.0 --allow-root notebooks

lint:
	mypy src --ignore-missing-imports
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

dockerize: build
	docker build --rm -f "Dockerfile" -t demo:latest .

run:
	docker run --rm -it demo:latest

install-package-databricks:
	@echo Installing 'dist/${WHEELNAME}' on databricks...
	databricks fs cp dist/${WHEELNAME} dbfs:/libraries/${WHEELNAME} --overwrite
	databricks libraries install --whl dbfs:/libraries/${WHEELNAME} --cluster-id ${CLUSTERID}

install-package-synapse: isset-WHEELNAME isset-SYNAPSE_WORKSPACE_NAME isset-SYNAPSE_SPARKPOOL_NAME isset-SYNAPSE_SA_NAME isset-SYNAPSE_CONTAINER_NAME
	@echo Installing 'dist/${WHEELNAME}' on azure synapse...
	az storage fs file upload \
		-s dist/${WHEELNAME} \
		-p synapse/workspaces/${SYNAPSE_WORKSPACE_NAME}/sparkpools/${SYNAPSE_SPARKPOOL_NAME}/libraries/python/${WHEELNAME} \
		-f ${SYNAPSE_CONTAINER_NAME} \
		--account-name ${SYNAPSE_SA_NAME} \
		--auth-mode login \
		--overwrite
