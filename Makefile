define green
	@tput setaf 2
	@tput bold
	@echo $1
	@tput sgr0
endef
in_venv=venv/bin/activate
py_pkg=nextbus

.PHONY: default
default: venv clean_pyc flake8 unit_tests
	$(call green,"[Build successful]")

venv: venv/bin/activate
venv/bin/activate: requirements.test.txt
	test -d venv || virtualenv venv
	. venv/bin/activate; pip install -r requirements.test.txt
	$(call green,"[Making venv successful]")

.PHONY: clean_pyc
clean_pyc:
	find . -name "$(py_pkg)/*.pyc" -delete
	$(call green,"[Cleanup loitering pyc files]")

.PHONY: flake8
flake8: venv
	. $(in_venv); flake8 $(py_pkg)/*.py
	$(call green,"[Static analysis (flake8) successful]")

.PHONY: unit_tests
unit_tests:
	. $(in_venv); nosetests -q --with-xunit --exe --cover-erase -a '!wip' \
		--with-coverage --cover-package=$(py_pkg)
	$(call green,"[Unit tests successful]")

.PHONY: wheel
wheel: venv default
	. $(in_venv); python setup.py bdist_wheel
	$(call green,"[Build of wheel successful]")

.PHONY: run
run: venv
	. $(in_venv); python web.py

.PHONY: clean
clean:
	rm -Rf venv
