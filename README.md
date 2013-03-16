[![Build Status](https://travis-ci.org/JustinJ/ramsdel.png)](https://travis-ci.org/JustinJ/ramsdel)


=======
RaMSDeL
=======

RaMSDeL is a <b>Ra</b>ndom <b>M</b>ove <b>S</b>crambler <b>De</b>finition <b>L</b>anguage

Purpose
=======

The primary purpose of Ramsdel is in my scramble analysis project,
however it is provided here in case someone else has the need to generate
large amounts of random-move scrambles.

The general idea is that scrambles are defined using somewhat familiar syntax, and can create a
wide range of different scramblers.

Usage
=====

An example of a regular 25-move 6-gen 3x3 scrambler would be

`<U,D,L,R,F,B> * 25`

which would produce scramblers such as

`F2 R2 F' U' B R' D2 F R2 U L U R' F' R B U2 L U2 R' L2 B' D2 L' F`

Moves can be left out of the definition to exclude them from the scrambler,
so a definition such as

`<R,U> * 25`

will produce a scramble like

`U R2 U' R' U2 R U' R2 U R U' R U2 R U' R U2 R2 U2 R' U R' U2 R U2`

If you don't want certain moves to be implicitly allowed, such as `R'` from allowing `R`,
square brackets can be used to require each move to be explicitly allowed.

This means that a definition such as

`[R,R',U,U'] * 25`

will yield results similar to

`R' U R U R U R' U R U' R U' R' U' R' U' R U' R U' R' U' R' U R'`

Puzzles
=======

Currently only 3x3 is supported, however if there is any need for other puzzles they can be added.
