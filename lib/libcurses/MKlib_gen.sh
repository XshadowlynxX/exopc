#!/bin/sh
#
# MKlib_gen.sh -- generate sources from curses.h macro definitions
#
# $OpenBSD: MKlib_gen.sh,v 1.4 1998/07/23 21:17:22 millert Exp $
# ($From: MKlib_gen.sh,v 1.11 1998/01/17 14:16:52 Juan.Jose.Garcia.Ripoll Exp $)
#
# The XSI Curses standard requires all curses entry points to exist as
# functions, even though many definitions would normally be shadowed
# by macros.  Rather than hand-hack all that code, we actually
# generate functions from the macros.
#
# This script accepts a file of prototypes on standard input.  It discards
# any that don't have a `generated' comment attached. It then parses each
# prototype (relying on the fact that none of the macros take function 
# pointer or array arguments) and generates C source from it.
#
# Here is what the pipeline stages are doing:
#
# 1. sed: extract prototypes of generated functions
# 2. sed: decorate prototypes with generated arguments a1. a2,...z
# 3. awk: generate the calls with args matching the formals 
# 4. sed: prefix function names in prototypes so the preprocessor won't expand
#         them.
# 5. cpp: macro-expand the file so the macro calls turn into C calls
# 6. awk: strip the expansion junk off the front and add the new header
# 7. sed: squeeze spaces, strip off gen_ prefix, create needed #undef
#

preprocessor="$1 -I../include"
AWK="$2"
ED1=sed1$$.sed
ED2=sed2$$.sed
ED3=sed3$$.sed
AW1=awk1$$.awk
TMP=gen$$.c
trap "rm -f $ED1 $ED2 $ED3 $AW1 $TMP" 0 1 2 5 15

(cat <<EOF
#include <ncurses_cfg.h>
#include <curses.h>

DECLARATIONS

EOF
cat >$ED1 <<EOF1
/^extern.*generated/{
	h
	s/^.*generated:\([^ 	*]*\).*/P_#if_USE_\1_SUPPORT/p
	g
	s/^extern \([^;]*\);.*/\1/p
	g
	s/^.*generated:\([^ 	*]*\).*/P_#endif/p
}
EOF1

cat >$ED2 <<EOF2
/^P_/b nc
/(void)/b nc
	s/,/ a1% /
	s/,/ a2% /
	s/,/ a3% /
	s/,/ a4% /
	s/,/ a5% /
	s/,/ a6% /
	s/,/ a7% /
	s/,/ a8% /
	s/,/ a9% /
	s/,/ a10% /
	s/,/ a11% /
	s/,/ a12% /
	s/,/ a13% /
	s/,/ a14% /
	s/,/ a15% /
	s/*/ * /g
	s/%/ , /g
	s/)/ z)/
:nc
	/(/s// ( /
	s/)/ )/
EOF2

cat >$ED3 <<EOF3
/^P_/{
	s/^P_#if_/#if /
	s/^P_//
	b done
}
	s/		*/ /g
	s/  */ /g
	s/ ,/,/g
	s/ )/)/g
	s/ gen_/ /
	s/^M_/#undef /
	/^%%/s//	/
:done
EOF3

cat >$AW1 <<\EOF1
BEGIN	{
		skip=0;
	}
	/^P_#if/ {
		print "\n"
		print $0
		skip=0;
	}
	/^P_#endif/ {
		print $0
		skip=1;
	}
	$0 !~ /^P_/ {
	if (skip)
		print "\n"
	skip=1;

	print "M_" $2
	print $0;
	print "{";
	argcount = 1;
	if (NF == 5 && $4 == "void")
		argcount = 0;
	if (argcount != 0) {
		for (i = 1; i <= NF; i++)
			if ($i == ",")
				argcount++;
	}

	# suppress trace-code for functions that we cannot do properly here,
	# since they return data.
	dotrace = 1;
	if ($2 == "innstr")
		dotrace = 0;

	call = "%%T((T_CALLED(\""
	args = ""
	comma = ""
	num = 0;
	pointer = 0;
	argtype = ""
	for (i = 1; i <= NF; i++) {
		ch = $i;
		if ( ch == "*" )
			pointer = 1;
		else if ( ch == "va_list" )
			pointer = 1;
		else if ( ch == "char" )
			argtype = "char";
		else if ( ch == "int" )
			argtype = "int";
		else if ( ch == "short" )
			argtype = "short";
		else if ( ch == "chtype" )
			argtype = "chtype";
		else if ( ch == "attr_t" || ch == "NCURSES_ATTR_T" )
			argtype = "attr";

		if ( ch == "," || ch == ")" ) {
			if (pointer) {
				if ( argtype == "char" ) {
					call = call "%s"
					comma = comma "_nc_visbuf2(" num ","
					pointer = 0;
				} else
					call = call "%p"
			} else if (argcount != 0) {
				if ( argtype == "int" || argtype == "short" ) {
					call = call "%d"
					argtype = ""
				} else if ( argtype != "" ) {
					call = call "%s"
					comma = comma "_trace" argtype "2(" num ","
				} else {
					call = call "%#lx"
					comma = comma "(long)"
				}
			}
			if (ch == ",")
				args = args comma "a" ++num;
			else if (argcount != 0)
				args = args comma "z"
			call = call ch
			if (pointer == 0 && argcount != 0 && argtype != "" )
				args = args ")"
			if (args != "")
				comma = ", "
			pointer = 0;
			argtype = ""
		}
		if ( i == 2 || ch == "(" )
			call = call ch
	}
	call = call "\")"
	if (args != "")
		call = call ", " args
	call = call ")); "

	if (dotrace)
		printf "%s", call

	if (match($0, "^void"))
		call = ""
	else if (dotrace)
		call = "returnCode( ";
	else
		call = "%%return ";

	call = call $2 "(";
	for (i = 1; i < argcount; i++)
		call = call "a" i ", ";
	if (argcount != 0)
		call = call "z";
	if (!match($0, "^void"))
		call = call ") ";
	if (dotrace)
		call = call ")";
	print call ";"

	if (match($0, "^void"))
		print "%%returnVoid;"
	print "}";
}
EOF1

sed -n -f $ED1 | sed -f $ED2 \
| $AWK -f $AW1 ) \
| sed \
	-e '/^\([a-z_][a-z_]*\) /s//\1 gen_/' >$TMP
  $preprocessor $TMP 2>/dev/null \
| $AWK '
BEGIN		{
	print "/*"
	print " * DO NOT EDIT THIS FILE BY HAND!"
	print " * It is generated by MKlib_gen.sh."
	print " *"
	print " * This is a file of trivial functions generated from macro"
	print " * definitions in curses.h to satisfy the XSI Curses requirement"
	print " * that every macro also exist as a callable function."
	print " *"
	print " * It will never be linked unless you call one of the entry"
	print " * points with its normal macro definition disabled.  In that"
	print " * case, if you have no shared libraries, it will indirectly"
	print " * pull most of the rest of the library into your link image."
	print " */"
	print "#include <curses.priv.h>"
	print ""
		}
/^DECLARATIONS/	{start = 1; next;}
		{if (start) print $0;}
' \
| sed -f $ED3 \
| sed \
	-e 's/^.*T_CALLED.*returnCode( \([a-z].*) \));/	return \1;/' \
	-e 's/^.*T_CALLED.*returnCode( \((wmove.*) \));/	return \1;/'

