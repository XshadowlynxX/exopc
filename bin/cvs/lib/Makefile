# Generated automatically from Makefile.in by configure.
# Makefile for library files used by GNU CVS.
# Do not use this makefile directly, but only from `../Makefile'.
# Copyright (C) 1986, 1988-1994 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

# $CVSid: @(#)Makefile.in 1.21 94/09/24 $
srcdir     = .
top_srcdir = ..
cvs_srcdir = ../src

SHELL = /bin/sh

prefix = /usr
exec_prefix = ${prefix}

SOURCES = \
	argmatch.c \
	dup2.c \
	fnmatch.c \
	ftruncate.c \
	getdate.c \
	getdate.y \
	getline.c \
	getopt.c \
	getopt1.c \
	getwd.c \
	hostname.c \
	md5.c \
	mkdir.c \
	regex.c \
	rename.c \
	savecwd.c \
	sighandle.c \
	strdup.c \
	strstr.c \
	strerror.c \
	strippath.c \
	stripslash.c \
	strtoul.c \
	valloc.c \
	vasprintf.c \
	waitpid.c \
	xgetwd.c \
	yesno.c

HEADERS = getline.h getopt.h fnmatch.h regex.h system.h wait.h md5.h savecwd.h

OBJECTS = \
     vasprintf.o regex.o \
    argmatch.o \
    getline.o \
    getopt.o \
    getopt1.o \
    md5.o \
    savecwd.o \
    sighandle.o \
    strippath.o \
    stripslash.o \
    xgetwd.o \
    yesno.o \
    getdate.o

DISTFILES = \
	.cvsignore ChangeLog ChangeLog.fsf Makefile.in \
	${SOURCES} ${HEADERS} build_lib.com

DEFS = -DHAVE_CONFIG_H
RANLIB = ranlib

CC       = gcc
CFLAGS = -g
CPPFLAGS=

YACC = bison -y

.c.o:
	$(CC) $(CPPFLAGS) -I.. -I$(srcdir) -I$(cvs_srcdir) \
              $(DEFS) $(CFLAGS) -c $<

all: libcvs.a
.PHONY: all

install: all
.PHONY: install

installdirs:
.PHONY: installdirs

tags: $(DISTFILES)
	ctags `for i in $(DISTFILES); do echo $(srcdir)/$$i; done`

TAGS: $(DISTFILES)
	etags `for i in $(DISTFILES); do echo $(srcdir)/$$i; done`

ls:
	@echo $(DISTFILES)
.PHONY: ls

clean:
	rm -f *.a *.o
.PHONY: clean

distclean: clean
	rm -f tags TAGS Makefile
.PHONY: distclean

realclean: distclean
	rm -f *.tab.c getdate.c
.PHONY: realclean

dist-dir:
	mkdir ${DISTDIR}
	for i in ${DISTFILES}; do \
	  ln $(srcdir)/$${i} ${DISTDIR}; \
	done
.PHONY: dist-dir

libcvs.a: $(OBJECTS)
	$(AR) cr $@ $(OBJECTS)
	-$(RANLIB) $@

getdate.c: getdate.y
	@echo expect 10 shift/reduce conflicts
	$(YACC) $(srcdir)/getdate.y
	-@if test -f y.tab.c; then \
	   mv y.tab.c getdate.c ;\
	else \
	   if test -f getdate.tab.c ; then \
	       mv getdate.tab.c getdate.c ; \
	   else \
	       echo '*** Unable to create getdate.c' ;\
	   fi ;\
	fi

fnmatch.o: fnmatch.h
getopt1.o: getopt.h
regex.o: regex.h
getwd.o: system.h
md5.o: md5.h

xlint:
	@echo xlint does nothing

subdir = lib
Makefile: ../config.status Makefile.in
	cd .. && CONFIG_FILES=$(subdir)/$@ CONFIG_HEADERS= ./config.status

#../config.status: ../configure
#	cd .. ; $(SHELL) config.status --recheck

#../configure: ../configure.in
#	cd $(top_srcdir) ; autoconf
