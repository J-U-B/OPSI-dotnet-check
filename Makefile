############################################################
# OPSI package Makefile (generic)
# Version: 1.3
# Jens Boettge <boettge@mpi-halle.mpg.de>
# 2021-02-10 12:38:31 +0100
############################################################

.PHONY: header clean mpimsp o4i mpimsp_test o4i_test all_test all_prod all help

OPSI_BUILDER := $(shell which opsi-makepackage)
ifeq ($(OPSI_BUILDER),)
	override OPSI_BUILDER := $(shell which opsi-makeproductfile)
	ifeq ($(OPSI_BUILDER),)
		$(error Error: opsi-make(package|productfile) not found!)
	endif
endif
$(info * OPSI_BUILDER = $(OPSI_BUILDER))

header:
	@echo "=================================================="
	@echo "             Building OPSI package(s)"
	@echo "=================================================="

mpimsp: header
	@echo "---------- building MPIMSP package -------------------------------"
	@make 	TESTPREFIX=""	 \
			ORGNAME="MPIMSP" \
			ORGPREFIX=""     \
			STAGE="release"  \
	build

o4i: header
	@echo "---------- building O4I package ----------------------------------"
	@make 	TESTPREFIX=""    \
			ORGNAME="O4I"    \
			ORGPREFIX="o4i_" \
			STAGE="release"  \
	build

mpimsp_test: header
	@echo "---------- building MPIMSP testing package -----------------------"
	@make 	TESTPREFIX="0_"	 \
			ORGNAME="MPIMSP" \
			ORGPREFIX=""     \
			STAGE="testing"  \
	build

o4i_test: header
	@echo "---------- building O4I testing package --------------------------"
	@make 	TESTPREFIX="test_"  \
			ORGNAME="O4I"    \
			ORGPREFIX="o4i_" \
			STAGE="testing"  \
	build

o4i_test_0: header
	@echo "---------- building O4I testing package --------------------------"
	@make 	TESTPREFIX="0_"  \
			ORGNAME="O4I"    \
			ORGPREFIX="o4i_" \
			STAGE="testing"  \
	build

o4i_test_noprefix: header
	@echo "---------- building O4I testing package --------------------------"
	@make 	TESTPREFIX=""    \
			ORGNAME="O4I"    \
			ORGPREFIX="o4i_" \
			STAGE="testing"  \
	build

clean: header
	@echo "---------- cleaning packages, checksums and zsync ----------------"
	@rm -f *.md5 *.opsi *.zsync
	
help: header
	@echo "----- valid targets: -----"
	@echo "* mpimsp"
	@echo "* mpimsp_test"
	@echo "* o4i"
	@echo "* o4i_test"
	@echo "* all_prod"
	@echo "* all_test"

all_test:  header mpimsp_test o4i_test o4i_test_0

all_prod : header mpimsp o4i

build:
	@rm -f OPSI/control
	@sed 	-e "s/{{TESTPREFIX}}/${TESTPREFIX}/" \
			-e "s/{{ORGPREFIX}}/${ORGPREFIX}/" \
			-e "s/{{ORGNAME}}/${ORGNAME}/" \
			-e "s/{{STAGE}}/${STAGE}/" \
			< OPSI/control.in > OPSI/control
	#@$(OPSI_BUILDER) -k -m -z
	@$(OPSI_BUILDER) -k -m


all_test:  header mpimsp_test o4i_test

all_prod : header mpimsp o4i

all : header mpimsp o4i mpimsp_test o4i_test
