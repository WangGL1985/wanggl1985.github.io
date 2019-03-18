---
title: Practical Vim -- Insert mode
date: 2016-11-30 21:01:27
tags:
    - vim
---

### Tip 13 Make Corrections Instantly frome Insert Mode

> If we make a mistake while composing text in Insert mode, we can fix it immediately. There's no meed to change modes. Besides the backspace key, we can use a couple of ither Insert node commands to make quick corrections.

<!-- more -->
In Insert mode, the backspace key works just as you would expect: it deletes the character in front of the cursor. The following chords are also available to us:

- `ctrl-h`
- `ctrl-w`
- `ctrl-u`

### Tip 14 Get Back to Normal Mode


> Insert mode is specialized for one task -- entering text -- whereas Normal mode is where we spend most of our time(as the name suggests). So ot's important to be able to switch quickly between them. This tip demonstrates a couple of tricks that reduce the friction of mode switching.

switch to Normal mode to from Insert mode:

- `esc`
- `ctrl-[`
- `ctrl-o`

    Swithc to `Insert Normal mode`.

    When the current line is right at the top or bottom of the window, I sometimes want to scroll the screen to see a bit more context. The `zz` command redraws the screen with the current line in the middle of the window, which allows us to read hakf a screent above and below the line we're working om, I'll often trigger this from Insert Normal mode by tapping out `ctrl-ozz`. That puts me straight back into Insert mode so that I cam continue typing uninterrupted.

### Tip 15 Paste from a Register Without Leaving Insert Mode

> Vim's yank and put operations are usually executed from Normal mode, but sometimes we might want to paste text into the document without leaving Insert mode.

```
Practical Vim, by Drew Neil
Read Drew Neil's
```

`yt,`

```
Practical Vim, by Drew Neil
Read Drew Neil's
```
`jA `
```
Practical Vim, by Drew Neil
Read Drew Neil's
```

`ctrl-r0`
```
Practical Vim, by Drew Neil
Read Drew Neil's Practical Vim
```


The `<ctrl-r>{register}` command is convenient for pasting a few words from Insert mode.

### Tip 16  Do Back-of-the-Envelop Calculations in Place

> The expression register allows us to perform calculations and then insert the result directly into our document. In this tips, we'll see one application for this powerful feature.

```
6 chairs, each costing $35, totals $
```

`A`

```
6 chairs, each costing $35, totals $
```

`ctrl-r=6*35<CR>`
```
6 chairs, each costing $35, totals $210
```

### Tip 17 Insert Unusual Characters by Character Code

> Vim can insert any character by its numeric code. This can be handy for entering symbols that are not found on the keyboard.

- `<C-v>u{1234}`
- `<C-v>{nondigit}`
- `<C-k>{char1}{char2}`

### Tip 18 Insert Unusual Characters by Digraph

> Whike Vim allows us to insert any character by its numberic code. these can be hard to remember and awkward to type. We can also insert unusual characters as digraphs: pairs of characters that are easy to remember.

- `<ctrl-k>?I` -->  ¿
- `<ctrl-k>>>` --> »
- `<ctrl-k>12` --> ½

We can view a list of available digraphs by running `:digraphs`, but the output of this command is difficult to digest. A more usable list can be found by looking up `:h digraph-table`

### Tip 19 Overview Existing Text With Replace Mode

> Replace mode is identical to Insert mode, except that it overwrites existing text in the document.

```
Typing in Insert mode extends the line. But in Replace mode
the line length doesn't change.
```

`f.`

```
Typing in Insert mode extends the line. But in Replace mode
the line length doesn't change.
```

`R,b<esc>`


```
Typing in Insert mode extends the line,but in Replace mode
the line length doesn't change.
```






