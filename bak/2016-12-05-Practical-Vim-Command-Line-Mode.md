---
title: Practical Vim -- Command-Line Mode
date: 2016-12-05 18:48:41
tags:
    - vim
---

### Tip 27 Meet Vim's Command Line


>Command-Line mode prompts us to enter an Ex command, a search pattern, or an expression. In this tip, we'll meet a selection of Ex commands that operate on the text in a buffer, and we'll learn about some of the special key mappings that can be used in this mode.

Help about `Command-Line` (see :h ex-cmd-indexline)

<!--more-->
#### Special Keys in Vim's Command-line Mode



Command-Line mode is similar to Insert mode in that most of the buttons on the keyboard simply enter a character.


As a general rule, we could say that Ex commands are long range and have the capacity to modify many lines in a single move. Or to condense that even further: Ex commands strike far and wide.

### Tip 28 Execute a Command on One or More Consecutive Lines


>Many Ex commands can be given a [range] of lines to act upon. We can specify the start and end of a range with either a line number, a mark, or a pattern.

```
<!DOCTYPE html>
<!--
 ! Excerpted from "Practical Vim",
 ! published by The Pragmatic Bookshelf.
 ! Copyrights apply to this code. It may not be used to create training material,
 ! courses, books, articles, and the like. Contact us if you are in doubt.
 ! We make no guarantees that this code is fit for any purpose.
 ! Visit http://www.pragmaticprogrammer.com/titles/dnvim for more book information.
-->
<html>
  <head><title>Practical Vim</title></head>
  <body><h1>Practical Vim</h1></body>
</html>
```

#### Use Line Numbers as an Address

The command sequence:

-   `:1`
-   `:print`
-   `:$`
-   `:p`
-   `:3p`

#### Specify a Range of Lines by Address


>:{start},{end}

The command sequence:

-   `:2,5p`
-   `:2`
-   `:.,$p`
-   `:%p`

The `%` symbol also has a special meaning --- it stands for all the lines in the current file.


-   `%s/Practical/Pragmatic/`


#### Specify a Range if Lines by Visual Selection

>:'<,'>

The `'<` symbol is a mark standing for the first line of the visual selection. while `'>` stands for the last line of the visual selection.

#### Specify a Range of Lines by Patterns


```
<!DOCTYPE html>
<!--
 ! Excerpted from "Practical Vim",
 ! published by The Pragmatic Bookshelf.
 ! Copyrights apply to this code. It may not be used to create training material,
 ! courses, books, articles, and the like. Contact us if you are in doubt.
 ! We make no guarantees that this code is fit for any purpose.
 ! Visit http://www.pragmaticprogrammer.com/titles/dnvim for more book information.
-->
<html>
  <head><title>Practical Vim</title></head>
  <body><h1>Practical Vim</h1></body>
</html>
```

>:/<html>/,/<\/html>/p


#### Modify an Address Using an Offset

Suppose that we wanted to run an Ex command on every line inside the <html></html> block but not on the lines that contain the <html> and </html> tags themselves. We could do so using an offset:

>:/<html>/+1,/<\/html>/-1p

The general form for an offset goes like this:

`:{address}+n`


-   `0`  Virtual line above first line of the file

Line 0 doesn’t really exist, but it can be useful as an address in certain con- texts. In particular, it can be used as the final argument in the :copy {address} and :move {address} commands when we want to copy or move a range of lines to the top of a file. We’ll see examples of these commands in the next two tips.


### Tip 29 Duplicate or Move Lines Using `:t` and `:m` Commands

>The :copy command (and its shorthand :t) lets us duplicate one or more lines from one part of the document to another, while the :move command lets us place them somewhere else in the document.

```
Shopping list
    Hardware Store
        Buy new hammer
    Beauty Parlor
        Buy nail polish remover
        Buy nails
```

#### Duplicate Lines with the `:t` Command

>:[range]copy{address}

The command means make a copy of `range` and put it below the `address` line.

some commands:

-   `:6t.`
-   `t6`
-   `t.`
-   `t$`
-   `'<,'>t0`

#### Move Line with the `:m` Command


>:[range]move{address}


Repeating the last Ex command is as easy as pressing @:  so this method is more easily reproducible than using Normal mode commands.


### Tips 30 Run Normal Mode Commands Access a Range

>If we want to run a Normal mode command on a series of consecutive lines, we can do so using the :normal command. When used in combination with the dot command or a macro, we can perform repetitive tasks with very little effort.

```
/***
 * Excerpted from "Practical Vim",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit http://www.pragmaticprogrammer.com/titles/dnvim for more book information.
***/
var foo = 1
var bar = 'a'
var baz = 'z'
var foobar = foo + bar
var foobarbaz = foo + bar + baz
```

The command sequence:

-   `A<esc>;`
-   `jVG`
-   `:'<,'normal.`

```
/***
 * Excerpted from "Practical Vim",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit http://www.pragmaticprogrammer.com/titles/dnvim for more book information.
***/
var foo = 1;
var bar = 'a';
var baz = 'z';
var foobar = foo + bar;
var foobarbaz = foo + bar + baz;
```

The :'<,'>normal . command can be read as follows: “For each line in the visual selection, execute the Normal mode . command.”


Some commands:

-   `%normal A;`
-   `:%normal i//`



### Tip 31 Repeat the Last Ex Command


### Tip 32 Tab-Complete Your Ex Commands

>Just like in the shell, we can use the the prompt.

`:col<c-d>`, The command asks Vim to reveal a list of possible completions. we could use the `<c-d>` command to show all the options:

>:colorscheme <c-d>


### Tip 33 Insert Current Word at the Command Prompt

>Even in Command-Line mode, Vim always knows where the cursor is positioned and which split window is active. To save time, we can insert the current word (or WORD) from the active document onto our command prompt.



```
/***
 * Excerpted from "Practical Vim",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit http://www.pragmaticprogrammer.com/titles/dnvim for more book information.
***/
var tally;
for (tally=1; tally <= 10; tally++) {
  // do something with tally
};
```

The command seqence:

-   `*`
-   `cwcounter<esc>`

```
/***
 * Excerpted from "Practical Vim",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit http://www.pragmaticprogrammer.com/titles/dnvim for more book information.
***/
var tally;
for (tally=1; tally <= 10; tally++) {
  // do something with tally
};
```

`:%s//<c-t><c-w>/g`, While `<C-r><C-w>` gets the word under the cursor, we can instead use `<C-r><C-a>` if we want to get the WORD,For another application, try opening your vimrc file, place your cursor on a setting, and then type `:help <C-r><C-w>` to look up the documentation for that setting.


### Tip 34 Recall Commands from History


>Vim records the commands that we enter in Command-Line mode and provides two ways of recalling them: scrolling through past command-lines with the cursor keys or dialing up the command-line window.



### Tip 35 Run Commands in the Shell


>We can easily invoke external programs without leaving Vim. Best of all, we can send the contents of a buffer as standard input to a command or use the standard output from an external command to populate our buffer.

#### Executing Programs in the Shell

The command sequence

-   `:!ls`
-   `:!ruby %`
-   `:shell`
-   `$pwd`
-   `$ls`
-   `$exit`

#### Using the Contents of a Buffer for Standard Input or Output

-   `:write !sh `
-   `:write ! sh`
-   `:write! sh`

#### Filtering the Contents of a Buffer Through an External Command

```
first name,last name,email
john,smith,john@example.com
drew,neil,drew@vimcasts.org
jane,doe,jane@example.com
```

`:2,$!sort -t',' -k2`,


```
jane,doe,jane@example.com
first name,last name,email
drew,neil,drew@vimcasts.org
john,smith,john@example.com
```

if we place our cursor on line 2 and then invoke !G , Vim opens a prompt with the :.,$! range set up for us. We still have to type out the rest of the {filter} command, but it saves a little work.
