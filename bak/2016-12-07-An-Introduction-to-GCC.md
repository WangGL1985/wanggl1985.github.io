---
title: An Introduction to GCC
date: 2016-12-07 19:00:01
tags:
    - gcc
---

### Compiling a C program

> Programs can be compiled from a single source file or from multiple source files, and may use system libraries and header files.


<!-- more --->

### Compiling a simple C program


```
#include <stdio.h>

int main (void) 
{
     printf ("Hello, world!\n");
     return 0; 
}
```

To compile the file "hello.c" with gcc:

> gcc -Wall hello.c -o hello


-   `-o` To specifie the machine code name
-   `-Wall` 
    Turn on the most commonly-used compiler warnings, the book recommanded that we should **always use this option!**

### Finding errors in a simple program


The resoure code:

```
#include <stdio.h>

int main (void) 
{ 
    printf ("Two plus two is %f\n", 4); 
    return 0; 
}
```

using the command `gcc -Wall bad.c -o bad `,  and then the compiler will complain:

```
bad.c: In function ‘main’: 
bad.c:6: warning: double format, different type arg (arg 2)
```

### Compiling multiple source files


### Compiling files independently

If a program is stored in a single file then any change to an individual function requires the whole program to be recompiled to produce a new executable.The recompilation of large source files can be very time- consuming.

#### Creating object files from source files

The command-line option ‘-c’ is used to compile a source file to an object file.

```
gcc -Wall -c main.c

```


#### Creating executables from object files

The final step in creating an executable file is to use gcc to link the object files together and fill in the missing addresses of external functions.


```
gcc main.o hello.o -o hello
```

#### Link order of object files

Most current compilers and linkers will search all object files, regard- less of order, but since not all compilers do this it is best to follow the convention of ordering object files from left to right.

#### Recompiling and relinking

In general, linking is faster than compilation—in a large project with many source files, recompiling only those that have been modified can make a significant saving.


### Linking with external libraries

A library is a collection of precompiled object files which can be linked into programs.The standard system libraries are usually found in the directories `/usr/lib` and `/lib`.

For example, the C math library is typically stored in the file `/usr/lib/libm.a` on Unix-like systems. The corre- sponding prototype declarations for the functions in this library are given in the header file `/usr/include/math.h`. 

The C standard library itself is stored in `/usr/lib/libc.a` and contains functions specified in the ANSI/ISO C standard, such as `printf`—this library is linked by default for every C program.


how to link the required library:

-   Add the absoluted path of the library in compile command
-   using `-l` option

    In general, the compiler option `-lNAME` will attempt to link object files with a library file `libNAME.a` in the standard library directories.


#### Link order of libraries


The ordering of libraries on the command line follows the same convec- tion as for object files: they are searched from left to right—a library containing the definition of a function should appear after any source files or object files which use it.

### Using library header files

example code:

```
#include <stdio.h>

int
main()
{
    double x = pow (2.0, 3.0);
    printf("Two cubed is %f\n", x);

    return 0;
}
```


> gcc  pow.c -lm -o pow

the output:

```
pow.c:6:16: warning: implicitly declaring library function 'pow' with type 'double (double, double)'
      [-Wimplicit-function-declaration]
    double x = pow (2.0, 3.0);
               ^
pow.c:6:16: note: include the header <math.h> or explicitly provide a declaration for 'pow'
1 warning generated.
```
