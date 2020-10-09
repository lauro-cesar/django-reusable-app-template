MSG="New commit"
APP_DIR=.



.PHONY : help
help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

.PHONY : commit
commit: ## "commit -e MSG="Commit message" : Add changes to git and commit"
	echo $(MSG)
	git add --all
	git commit -a -S -m "$(MSG)"
	git push


.PHONY : configure
configure: ## "Create virtual env and install requirements"
	python3 -m venv .venv && source .venv/bin/activate && pip install --upgrade pip &&  pip install -r requirements.txt

.PHONY : lint
lint: ## "Check linting flake8"
	source .venv/bin/activate &&  flake8  ${APP_DIR} --ignore=E501,F401

.PHONY : build
build: ## "Build piyp package"
	source .venv/bin/activate && python3 setup.py sdist bdist_wheel

.PHONY : upload
upload: ## "Upload package to Pyp"
	source .venv/bin/activate && python3 -m twine upload --skip-existing dist/*

.PHONY : check
check: ## "Upload package to Pyp"
	source .venv/bin/activate && python3 -m twine check  dist/*

.PHONY : test
test: ## "Run test with coverage"
	source .secrets && source .venv/bin/activate && coverage run  manage.py test

.PHONY : cover_report
cover_report: ## "show coverage report
	source .secrets && source .venv/bin/activate  && coverage report -m

.PHONY : code_format
code_format: ## "Format code using black -t py38
	source .venv/bin/activate &&  black ${APP_DIR} -v -t py38

.PHONY : code_format_check
code_format_check: ## "Check code format with black"
	source .venv/bin/activate &&  black ${APP_DIR} -v -t py38 --check --diff
