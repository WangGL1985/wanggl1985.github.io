---
title: Practical Vim  -- normal mode
date: 2016-11-29 19:49:12
tags:
- vim
---

As a general rule, if you've paused for long enough to ash the question. "Should I leave Insert mode?" then do it.


<!-- more -->
### Tip 9   Compose Repeatable Changes

> Vim is optimized for repetition, In order to exploit this, we have to be mindful of how we compose our changes.

```
The end is nigh
```
Suppose that our cursor is positioned on the "h" at the end of this line of text, and we want to delete the word "nigh"

- `dbx`
- `bdw`
- `daw`

which is the best? what is the reference bar?

We should always remember that vim is optimized for repetition. If you notice that you have to make the same change in a handful of places, you can attempt to compose your changes in such a way that they can be repeated with the dot command. Rcognizing those
opportunities tajes practice.


### Tip 10 Use Counts to Do Simple Arithmetic

> Most Normal mode commands can be execyuted with a count, We can exploit this feature to do simple arithmetic.


```

.blog, .news { background-image: url(/sprite.png); }
.blog { background-position: 0px 0px }

```
yyp

```
.blog, .news { background-image: url(/sprite.png); }
.blog { background-position: 0px 0px }
.blog { background-position: 0px 0px }
```

cW.news<Esc>

```

.blog, .news { background-image: url(/sprite.png); }
.blog { background-position: 0px 0px }
.news { background-position: 0px 0px }
```
180<C-x>

```
.blog, .news { background-image: url(/sprite.png); }
.blog { background-position: 0px 0px }
.news { background-position: -180px 0px }
```


### Tip 11 Don't Count if You Can Repeat

> We can minimize the keystrokes required to perform certain tasks by providing a count, but that doesn't mean that we should. Consider the pros and cons of counting versus repearing.

```
Delete more than one word
```


- `d2w`

read as "delete two words"
- `2dw`

read as "delete a word two times"
- `dw.`

which is the best?

### Tip 12 Combine and Conquer



> Much of Vim's power stems from the way that operators and motions can be combined. In this tip. we'll look at how this works and consider the implications.


- Operator + Motion = Action

Learning new motions and operators is like learning the vocabulay of Vim.




