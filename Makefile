ZPOOL=""
SERVER=""
SRC_BASE?="/usr/src"

install:
	echo -e "import os\ntry:\n  if not os.listdir('$(SRC_BASE)'): exit('$(SRC_BASE) must be populated!')\nexcept FileNotFoundError:\n  exit('$(SRC_BASE) must be populated!')" | python3
	test -d .git && git pull || true
	test -d .git && git submodule init py-libzfs && git submodule update py-libzfs || true
	python3 -m ensurepip
	export FREEBSD_SRC=$(SRC_BASE) && cd py-libzfs && ./configure && python3 setup.py build && python3 setup.py install
	python3 -m pip install -Ur requirements.txt .
uninstall:
	python3 -m pip uninstall -y iocage-lib iocage-cli
test:
	pytest --zpool $(ZPOOL) --server $(SERVER)
help:
	@echo "    install"
	@echo "        Installs iocage"
	@echo "    uninstall"
	@echo "        Removes iocage."
	@echo "    test"
	@echo "        Run unit tests with pytest"
