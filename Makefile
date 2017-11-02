all: lib ocp-sha
lib: ocp-sha.cma ocp-sha.cmxa

ocp-sha.cmxa: src/SHA.mli src/SHA.ml
	ocamlopt -I src -a $^ -o $@

ocp-sha.cma: src/SHA.mli src/SHA.ml
	ocamlc -I src -a $^ -o $@

ocp-sha: ocp-sha.cmxa src/ocp_sha_main.ml
	ocamlopt -I src unix.cmxa bigarray.cmxa $^ -o $@

test-init:
	rm -rf test
	mkdir test
	cp Makefile README.md src/*.ml* test
	touch test/00
	echo -n "a" >test/01
	echo -n "ab" >test/02
	dd if=/dev/zero of=test/03 bs=254 count=1
	dd if=/dev/zero of=test/04 bs=255 count=1
	dd if=/dev/zero of=test/05 bs=256 count=1
	dd if=/dev/zero of=test/06 bs=257 count=1
	dd if=/dev/zero of=test/07 bs=500 count=1
	dd if=/dev/zero of=test/08 bs=511 count=1
	dd if=/dev/zero of=test/09 bs=512 count=1
	dd if=/dev/zero of=test/10 bs=513 count=1
	dd if=/dev/urandom of=test/11 bs=512 count=1000
	cp test/11 test/12
	dd if=/dev/urandom of=test/12 seek=1000 bs=1 count=1 conv=notrunc
	cp test/11 test/13
	dd if=/dev/urandom of=test/13 seek=1000 bs=520 count=1 conv=notrunc
	dd if=/dev/urandom of=test/14 seek=1000 bs=520 count=100000
	touch test-init

define run-test
	for t in test/*; do \
	  ref=`time -f "openssl: %es" openssl sha$(1) $$t |cut -d' ' -f2`; \
	  res=`time -f "ocp-sha: %es" ./ocp-sha $(1) $$t`; \
	  if [ "$$ref" != "$$res" ]; then \
	    echo "[31mFAIL[m SHA$(1) $$t\n    $$res, should be\n    $$ref"; \
	    : exit 1; \
	  else \
	    echo "[32mPASS[m SHA$(1) $$t"; \
	  fi; \
	done
endef

test256: ocp-sha
	@$(call run-test,256)

test512: ocp-sha
	@$(call run-test,512)

test: test-init ocp-sha
	@$(call run-test,256)
	@$(call run-test,512)
