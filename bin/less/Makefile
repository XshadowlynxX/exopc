# Generated automatically from Makefile.in by configure.
# Makefile for less.

#### Start of system configuration section. ####

srcdir = .

CC = gcc
INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644

#
# XXX - OpenBSD modificatations
#
INSTALL_MAN=install_man
MANPAGES=less.nro lesskey.nro
INSTALLDIRS=installdirs
LESS_HLP=more.help

CFLAGS = -g -O
CFLAGS_COMPILE_ONLY = -c
LDFLAGS = 
O=o

LIBS =   -lcurses -ltermcap

prefix = /usr/local
exec_prefix = ${prefix}

# Where the installed binary goes.
bindir = ${exec_prefix}/bin
binprefix = 

# Where the help file goes.
datadir = ${prefix}/share

mandir = ${prefix}/man/man${manext}
manext = 1
manprefix = 

#### End of system configuration section. ####

SHELL = /bin/sh

# This rule allows us to supply the necessary -D options
# in addition to whatever the user asks for.
.c.o:
	${CC} -I. ${CFLAGS_COMPILE_ONLY} ${CPPFLAGS} ${CFLAGS} $<

SRC =	main.c screen.c brac.c ch.c charset.c cmdbuf.c \
	command.c decode.c edit.c filename.c forwback.c \
	help.c ifile.c input.c jump.c line.c linenum.c \
	lsystem.c mark.c optfunc.c option.c opttbl.c os.c \
	output.c position.c prompt.c search.c signal.c \
	tags.c ttyin.c version.c  
OBJ =	main.${O} screen.${O} brac.${O} ch.${O} charset.${O} cmdbuf.${O} \
	command.${O} decode.${O} edit.${O} filename.${O} forwback.${O} \
	help.${O} ifile.${O} input.${O} jump.${O} line.${O} linenum.${O} \
	lsystem.${O} mark.${O} optfunc.${O} option.${O} opttbl.${O} os.${O} \
	output.${O} position.${O} prompt.${O} search.${O} signal.${O} \
	tags.${O} ttyin.${O} version.${O}  
DISTFILES = ${SRC} regexp.c regexp.h \
	INSTALL Makefile.in README NEWS \
	configure configure.in acconfig.h lesskey.c \
	cmd.h funcs.h less.h lesskey.h option.h position.h \
	install.sh defines.h.in defines.h.top mkinstalldirs \
	less.nro lesskey.nro less.man lesskey.man less.hlp \
	Makefile.dos defines.dos doscreen.c \
	Makefile.os2 defines.os2

all: less lesskey

less: ${OBJ}
	${CC} ${LDFLAGS} -o $@ ${OBJ} ${LIBS}

lesskey: lesskey.${O} version.${O}
	${CC} ${LDFLAGS} -o $@ lesskey.${O} version.${O}

${OBJ}: less.h defines.h funcs.h

filename.${O}: filename.c
	${CC} -c -DHELPFILE=\"${datadir}/${LESS_HLP}\" -I. ${CPPFLAGS} ${CFLAGS} ${srcdir}/filename.c

install: all less.hlp $(INSTALL_MAN) $(INSTALLDIRS)
	${INSTALL_PROGRAM} less ${bindir}/${binprefix}less
	${INSTALL_PROGRAM} lesskey ${bindir}/${binprefix}lesskey
	${INSTALL_DATA} ${srcdir}/less.hlp ${datadir}/${LESS_HLP}

installdirs: mkinstalldirs
	${srcdir}/mkinstalldirs ${bindir} ${datadir} ${mandir}

install_man: ${MANPAGES}
	${INSTALL_DATA} ${srcdir}/less.nro ${mandir}/${manprefix}less.${manext}
	${INSTALL_DATA} ${srcdir}/lesskey.nro ${mandir}/${manprefix}lesskey.${manext}

uninstall:
	rm -f ${bindir}/${binprefix}less ${bindir}/${binprefix}lesskey
	rm -f ${datadir}/${LESS_HLP}
	rm -f ${mandir}/less.${manext} ${mandir}/lesskey.${manext}

info:
install-info:
dvi:
check:
installcheck:

TAGS:
	cd ${srcdir} && etags *.c *.h

# config.status might not change defines.h
# Don't rerun config.status if we just configured (so there's no stamp-h).
defines.h: stamp-h
stamp-h: defines.h.in config.status
	test ! -f stamp-h || CONFIG_FILES= CONFIG_HEADERS=defines.h ./config.status
	touch stamp-h
Makefile: Makefile.in config.status
	CONFIG_FILES=Makefile CONFIG_HEADERS= ./config.status
config.status: ${srcdir}/configure
	./config.status --recheck

configure: configure.in
	autoheader
	autoconf

lint:
	lint -I. ${CPPFLAGS} ${SRC}
newfuncs:
	mv -f funcs.h funcs.h.old
	awk -f mkfuncs.awk ${SRC} >funcs.h
clean:
	rm -f *.${O} core less lesskey

mostlyclean: clean

distclean: clean
	rm -f Makefile config.status config.log config.cache defines.h stamp-h

realclean: distclean
	rm -f TAGS

dist: ${DISTFILES}
	if [ ! -d release ]; then mkdir release; fi
	@REL=`sed -e '/char version/!d' -e 's/[^0-9.]*\([0-9.]*\).*/less-\1/' -e q version.c`; \
	rm -rf release/$$REL; mkdir release/$$REL; \
	echo "Creating release/$$REL/$$REL.tar.gz"; \
	rm -rf $$REL; mkdir $$REL; \
	for file in ${DISTFILES}; do \
	  ln $$file $$REL || \
	  { echo "cannot link, copying $$file"; cp -p $$file $$REL; }; \
	done; \
	tar -chf - $$REL | gzip -c >release/$$REL/$$REL.tar.gz; \
	rm -rf $$REL

tagall:
	@REL=`sed -e '/char version/!d' -e 's/[^0-9.]*\([0-9.]*\).*/v\1/' -e q version.c`; \
	echo "tagging $$REL"; \
	$(RCS) -N$$REL: RCS/*,v
