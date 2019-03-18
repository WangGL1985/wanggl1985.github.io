---
title: Practical Vim -- Visual Mode
date: 2016-12-04 14:28:30
tags:
    - vim
---

> Vim has three variants of Visual mode involving working with characters, lines, or rectangular blocks of text. 


<!-- more -->
### Tip 20 Grok Visual Mode

> Visual mode allows us to select a range of text and then operate upon it. However intuitive this might seem, Vim's prespective on selecting text is different from other text editors.


### Tip 21 Define a Visual Selection

> Visual mode's three submodes deal with different kinds of text. In this tip, we'll look at the ways of enabling each visual submode, as well as how to switch between them.


#### Vim has three kinds of Visual mode.

- character-wise Visual mode
- line-wise Visual mode
- Block-wise Visual mode

From Normal mode, you can press `v` by itself to enable character-wise mode. Line-wise Visual mode is enabled by pressing `V`, and block-wise Visual mode by pressing `<C-v>`. Summarized in the following:

- `v` character-wise 
- `V` line-wise
- `<C-v>` block-wise
- `gv` Reselect the last visual selection

#### Switching between visual modes


- `<esc>/<c-[>` Switch to Normal mode
- `v/V/<c-v>`   Switch to Normal mode(when used from character-, line- or block-wise Visual mode, respectively)
- `v`
- `V`
- `<c-v>`
- `o`           Go to other end of highlighted text



#### Toggling the Free end of a selection


The range of a Visual mode selection is marked by two ends: one end is fixed and the other moves freely with our cursor. We can use the o key to toggle the free end. This is really handy if halfway through defining a selection we realize that we started in the wrong place.Rather than leaving Visual mode and starting afresh, we can just hit o and redefine the bounds of the selection. The following demonstrates how we can use this technique:


```
Select from here to here.
```

The command sequences:

- `vbb`
- `o`
- `e`

### Tip 22 Repeat Line-Wise Visual Commands

> When we use the dot command to repeat to a change mode to a visual selection, it repeats the change on the same range of text. In this tip. we'll make a change to line-wise selection and then repeat it with the dot coommand.


```
def fib(n):
    a, b = 0, 1
    while a < n:
        print a,
        a, b = b, a+b
fib(42)
```

The command sequence:

- `Vj`
- `v.`

### Tip 23 Prefer Operators to Visual Commands Where Possiable

> Visual mode may be more intuitive than Vim's Normal mode of operation, but it has a weakness: it doesn't alwarys play well with the dot command. we can route around this weakness by using Normal mode operators when appropriate.


#### Using a visual operator

```
<!--
 ! Excerpted from "Practical Vim",
 ! published by The Pragmatic Bookshelf.
 ! Copyrights apply to this code. It may not be used to create training material, 
 ! courses, books, articles, and the like. Contact us if you are in doubt.
 ! We make no guarantees that this code is fit for any purpose. 
 ! Visit http://www.pragmaticprogrammer.com/titles/dnvim for more book information.
-->
<a href="#">one</a>
<a href="#">two</a>
<a href="#">three</a>
```

The command sequence:

-   `vit`
-   `U`
-   `j.`
-   `j.`


```
<!--
 ! Excerpted from "Practical Vim",
 ! published by The Pragmatic Bookshelf.
 ! Copyrights apply to this code. It may not be used to create training material, 
 ! courses, books, articles, and the like. Contact us if you are in doubt.
 ! We make no guarantees that this code is fit for any purpose. 
 ! Visit http://www.pragmaticprogrammer.com/titles/dnvim for more book information.
-->
<a href="#">ONE</a>
<a href="#">TWO</a>
<a href="#">THRee</a>
```


#### Using a Normal Operator

```
<!--
 ! Excerpted from "Practical Vim",
 ! published by The Pragmatic Bookshelf.
 ! Copyrights apply to this code. It may not be used to create training material, 
 ! courses, books, articles, and the like. Contact us if you are in doubt.
 ! We make no guarantees that this code is fit for any purpose. 
 ! Visit http://www.pragmaticprogrammer.com/titles/dnvim for more book information.
-->
<a href="#">one</a>
<a href="#">two</a>
<a href="#">three</a>
```


The command sequence

-   `gUit`
-   `j.`
-   `j.`





```
<!--
 ! Excerpted from "Practical Vim",
 ! published by The Pragmatic Bookshelf.
 ! Copyrights apply to this code. It may not be used to create training material, 
 ! courses, books, articles, and the like. Contact us if you are in doubt.
 ! We make no guarantees that this code is fit for any purpose. 
 ! Visit http://www.pragmaticprogrammer.com/titles/dnvim for more book information.
-->
<a href="#">ONE</a>
<a href="#">TWO</a>
<a href="#">THREE</a>
```

### Tip 24 Edit Tabular Data with Visual-Block Mode

> We can work rows pf text in any editor, but manipulation columns of text requires a more specialized tool. Vim provides this capability in the form of its Visual-Block mode, which we'll use to transform a plain-texttale.


```
Chapter            Page
Normal mode          15
Insert mode          31
Visual mode          44
```

The command sequence:

-   `<c-v>3j`
-   `x...`
-   `gv`
-   `r|`
-   `yyp`
-   `Vr-`


```
Chapter       | Page
-------------------
Normal mode   |  15
Insert mode   |  31
Visual mode   |  44
```

### Tip 25 Change Columns of Text

>We can use Visual-Block mode to insert text into several lines of text simultane- ously. Visual-Block mode is not just useful to us when working with tabular data. Oftentimes, we can benefit from this feature when working with code.

```
li.one   a{ background-image: url('/images/sprite.png'); }
li.two   a{ background-image: url('/images/sprite.png'); }
li.three a{ background-image: url('/images/sprite.png'); }
```


The command sequence:

-   `<c-v>jje`
-   `c`
-   `components`
-   `esc`


```
li.one   a{ background-image: url('/components/sprite.png'); }
li.two   a{ background-image: url('/components/sprite.png'); }
li.three a{ background-image: url('/components/sprite.png'); }
```



### Tip 26 Append After a Ragged Visual Block

> Visual-Block mode is great for operating on rectangular chunks of code such as lines and columns, but it’s not confined to rectangular regions of text.


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
var foobar = foo + bar
```

The command sequence:

-   `<c-v>jj$`
-   `A;` 
-   `<esc>`

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
var foobar = foo + bar;
```


