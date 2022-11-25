dnl automated feature report at the end of configure script.
dnl it also AC_DEFINE() and AM_CONDITIONAL the matching variable.
dnl for example, "usb" (--with-usb) will give
dnl nut_with_usb and WITH_USB (both macros, and
dnl AM_CONDITIONAL)

AC_DEFUN([NUT_REPORT_FILE],
[
    dnl arg#1 = description (summary)
    dnl arg#2 = value
    dnl arg#3 = file tag (e.g. number)
    dnl arg#4 = file title (e.g. "NUT Configuration summary:")
    if test -z "${nut_report_feature_flag$3}"; then
        nut_report_feature_flag$3="1"
        ac_clean_files="${ac_clean_files} config.nut_report_feature.log.$3"
        if [ "$3" = 1 ]; then
            echo "$4"
        else
            echo ""
            echo "$4"
        fi > "config.nut_report_feature.log.$3"
        echo "$4" | sed 's/./=/g' >> "config.nut_report_feature.log.$3"
        echo "" >> "config.nut_report_feature.log.$3"
    fi
    echo "* $1: $2" >> "config.nut_report_feature.log.$3"
])

AC_DEFUN([NUT_REPORT],
[
    dnl arg#1 = description (summary)
    dnl arg#2 = value
    NUT_REPORT_FILE($1, $2, 1, "NUT Configuration summary:")
])

AC_DEFUN([NUT_REPORT_FEATURE],
[
    dnl arg#1 = summary/config.log description
    dnl arg#2 = test flag ("yes" or not)
    dnl arg#3 = value
    dnl arg#4 = autoconf varname
    dnl arg#5 = longer description (autoconf comment)
   AC_MSG_CHECKING([whether to $1])
   AC_MSG_RESULT([$2 $3])
   NUT_REPORT([$1], [$2 $3])

   AM_CONDITIONAL([$4], test "$2" = "yes")
   if test "$2" = "yes"; then
      AC_DEFINE_UNQUOTED($4, 1, $5)
   fi
])

AC_DEFUN([NUT_REPORT_SETTING],
[
    dnl arg#1 = summary/config.log description
    dnl arg#2 = autoconf varname
    dnl arg#3 = value
    dnl arg#4 = description (summary and autoconf)
   AC_MSG_CHECKING([setting for $1])
   AC_MSG_RESULT([$3])
   NUT_REPORT([$1], [$3])

   dnl Note: unlike features, settings do not imply an AutoMake toggle
   AC_DEFINE_UNQUOTED($2, $3, $4)
])

AC_DEFUN([NUT_REPORT_COMPILERS],
[
   (echo ""
    echo "NUT Compiler settings:"
    echo "----------------------"
    echo ""
    printf '* CC      \t: %s\n' "$CC"
    printf '* CFLAGS  \t: %s\n' "$CFLAGS"
    printf '* CXX     \t: %s\n' "$CXX"
    printf '* CXXFLAGS\t: %s\n' "$CXXFLAGS"
    printf '* CPP     \t: %s\n' "$CPP"
    printf '* CPPFLAGS\t: %s\n' "$CPPFLAGS"
   ) > config.nut_report_feature.log.9
])

AC_DEFUN([NUT_PRINT_FEATURE_REPORT],
[
    dnl By (legacy) default we remove this report file
    dnl For CI we want to publish its artifact
    dnl Manageable by "--enable-keep_nut_report_feature"
    echo ""
    AS_IF([test x"${nut_enable_keep_nut_report_feature-}" = xyes],
        [AC_MSG_NOTICE([Will keep config.nut_report_feature.log])
         cat config.nut_report_feature.log.* > config.nut_report_feature.log
         cat config.nut_report_feature.log
        ],
        [dnl Remove if exists from old builds
         ac_clean_files="${ac_clean_files} config.nut_report_feature.log"
         cat config.nut_report_feature.log.*
        ])
])
