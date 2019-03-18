---
title: A pure approach to object-oriented programming
date: 2016-12-31 11:24:46
tags:
  - OOP
---

What is object-oriented programming? How to understand object-oriented programming? How to master object-oriented programming?

- Everything is an object.

  Think of an object as a fancy variable; it stores data, but you can "make request" to that object, asking it to perform operations on itself. In theory, you can take any conceptual component in the problem you're trying to solve and represent it as an object in your program.

- A program is a bunch of objects telling each other what to do by sending messages

  To make a request of an object, you "send a message" to that object. More concretely, you can think of a message as request to call a function that belongs to a particular object.

- Each object has its own memory made up of other objects

  Put another way, you create a new kind of object by making a package containing existing objects. Thus, you can build complexity in a program while hiding it behind the simplicity of objects.

- Every object has a type

  Using the parlance, each object is an instance of a class, in which "class" is synonymous with "type". The most important distinguishing characteristic of a class is "What message can you send to it"?

- All object of a particular type can receive the same message

  This is actually a loaded statement, as you will see later. Because an object of type "circle" is also an object of type "shape", a circle is guaranteed to accept shape messages.
