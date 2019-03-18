---
title: Compilation options
date: 2016-12-07 19:56:09
tags:
    - gcc
---

### Setting search paths

A common problem when compiling a program using library header files is the error:

>FIFE.h: No such file or directory

This occurs if a header file is not present in the standard include file directories used by gcc. A similar problem can occur for libraries:

>/usr/bin/ld: cannot find library

This happens if a library used for linking is not present in the standard library directories used by gcc.

<!-- more -->

By default, gcc searches the following directories for header files:

```
/usr/local/include/
/usr/include/
```

and the following directories for libraries:

```
/usr/local/lib/
/usr/lib/
```


When additional libraries are installed in other directories it is nec- essary to extend the search paths, in order for the libraries to be found. The compiler options `-I` and r`-L` add new directories to the beginning of the include path and library search path respectively.

#### Search path example

Adding the appropriate directory to the include path with the command-line option `-I` allows the program to be compiled, but not linked:

>gcc -Wall -I/opt/gdbm-1.8.3/include dbmain.c -lgdbm

The directory containing the library is still missing from the link path. It can be added to the link path using the following option:

>-L/opt/gdbm-1.8.3/lib/


The following command line allows the program to be compiled and linked: 

> gcc -Wall -I/opt/gdbm-1.8.3/include -L/opt/gdbm-1.8.3/lib dbmain.c -lgdbm


#### Environment variables


The search paths for header files and libraries can also be controlled through environment variables in the shell.

#### Extended search paths

Following the standard Unix convention for search paths, several direc- tories can be specified together in an environment variable as a colon separated list:

>DIR1:DIR2:DIR3:... 

The directories are then searched in order from left to right. A single dot `.` can be used to specify the current directory. 


When environment variables and command-line options are used to- gether the compiler searches the directories in the following order:

1. command-line options ‘-I’ and ‘-L’, from left to right
2. directories specified by environment variables, such as C_INCLUDE_ PATH and LIBRARY_PATH
3. default system directories

### Shared libraries and static libraries

static linking can be forced with the `-static` option to gcc to avoid the use of shared libraries:


```
gcc -Wall -static -I/opt/gdbm-1.8.3/include/ -L/opt/gdbm-1.8.3/lib/ dbmain.c -lgdbm
```

link directly with the static library:

```
gcc -Wall -I/opt/gdbm-1.8.3/include dbmain.c /opt/gdbm-1.8.3/lib/libgdbm.a
```

link with the shared library:

```
gcc -Wall -I/opt/gdbm-1.8.3/include dbmain.c /opt/gdbm-1.8.3/lib/libgdbm.so

```


### C language standards

#### ANSI/ISO

Occasionally a valid ANSI/ISO program may be incompatible with the extensions in GNU C. To deal with this situation, the compiler option `-ansi` disables those GNU extensions which conflict with the ANSI/ISO standard. On systems using the GNU C Library (glibc) it also disables extensions to the C standard library. This allows programs written for ANSI/ISO C to be compiled without any unwanted effects from GNU extensions.


For example:

```c
#include <stdio.h>


int
main()
{

        const char asm[] = "this is a test";

        printf("the string asm is %s \n", asm);

        return 0;
}
```


The variable name `asm` is valid under the ANSI/ISO standard, but this program will not compile in GNU C because `asm` is a GNU C keyword extension.


Using the `-ansi` option disable the asm keyword extension. the program will be compiled correctly.

#### Strict ANSI/ISO


The command-line option `-pedantic` in combination with `-ansi` will cause gcc to reject all GNU C extensions, not just those that are incompatiable with the ANSI/ISO standard.



#### Selecting specific standards

The specific language standard used by GCC can be controlled with the `-std` option. The following C language standards are supported:

-   `-std=c89`
-   `-std=iso9899:199409`
-   `-std=c99`

### Warning options in -Wall

Option `-Wall` enables warnings for many common errors, and should always be used. It combines a large number of other, more specific, warning options which can also be selected individually. Here is a summary of these options:

-   `-Wcomment`
-   `-Wformat`
-   `-Wunused`
-   `-Wimplicit`
-   `-Wreturn-type`



### Additional warning options


GCC provides many other warning options that are not included in`-Wall`, but are often useful. Typically these produce warnings for source code which may be technically valid but is very likely to cause prob- lems.

-   `-W`
    
    ```c
    int 
    foo (unsigned int x)
    {
        if(x<0)
            return 0;
        else
            return 1;
    }
```

```
Woption.c:9:10: warning: comparison of unsigned expression < 0 is always false [-Wtautological-compare]
    if(x <0)
       ~ ^~
1 warning generated.
```

-   `-Wconversion`
    This option warns about implicit type conversions that could cause unexpected results.
-   `-Wshadow`
    This option warns about the redeclaration of a variable name in a scope where it has already been declared.
-   `Wcast-qual`
    This option warns about pointers that are cast to remove a type qualifier, such as const.
-   `Wwrite-strings`
    This option implicitly gives all string constants defined in the pro- gram a const qualifier, causing a compile-time warning if there is an attempt to overwrite them.
-   `-Wtraditional`
    This option warns about parts of the code which would be inter- preted differently by an ANSI/ISO compiler and a “traditional” pre-ANSI compiler. 


The options above produce diagnostic warning messages, but allow the compilation to continue and produce an object file or executable. For large programs it can be desirable to catch all the warnings by stopping the compilation whenever a warning is generated. The `-Werror` option changes the default behavior by converting warnings into errors, stopping the compilation whenever a warning occurs.
