---
title: "The Memory Game - Deep Dive"
date: 2024-11-11
hero: /images/hero.png
description: Deeo dive into why this game is perfect for learning good game design
draft: true
menu:
  sidebar:
    name: Memory Game - Deep Dive
    identifier: memory-game-deep-dive
    weight: 50
tags: ["educational", "kids games"]
categories: ["Game", "Game Design"]
---

You don't have to run to AAA games to learn about game design. On the contrary, classical games and children's game can often teach you the intricates of the field without all the noise.
In this article, we'll dissect the memeory game, a simple children's game which demonstrates all the core features of good game design.

Say what you will of these games, they have existed for a long time in one form or another, and will continue to exist far beyond any modern game we know today. Their longevity stems from their
(simplicity and) use - to teach humans, mostly kids, a skill. If you dissect The Memory Game (TMG from now on) from an MDA viewpoint, you'll notice that it has two distinct mechanics. The first one is
its turn base sequencing. The second, drawing matching cards.

The Memory Game (AKA [concentration](https://en.wikipedia.org/wiki/Concentration_(card_game))) 

## Progression

### Level 1

When I started playing the memory game with my kids, starting at 2.5 yrs. old, the first thing I wanted to teach them was the core mechanic, drawing cards from the pool. To do this, the first "level"
of the game was 2 cards only, of the same type, waiting to be drawn and showcase the first mechanic - flipping cards. In this part I don't even introduce sum-zero objectives to the game,
i.e. no winner and losers, simply drawing cards is enough. After I congratulate them for being super awesome, we draw the next level.

- talk about card collection

### Level 2

In level 2 I introduce 4 cards to the game. In this level, mistakes can happen, and I make sure their match is a mistake. This can easily be achieved by placing two different cards close to the child,
as they are sure to open the ones closest to them (this is vetted, try it out. Works to about the age of 4.5). That mistake is super important to the learning process as now they are introduced to the
dynamics of the game. Now let's be clear, those little rascals will try to flip the other cards as well. Don't let them! Games are a structured experience, teach your kids the fun in that. When they
flip the odd cards I explain what just happened and why they can't collect those unto their side. This is often met with the child's equivilant of "fuck you dad", but I just let them play another turn.
I don't introduce sequencing into the mix just yet. Little kids will often open the same cards over and over again, in this case just explain each time that they should remember the cards placed there
and open from the cards they didn't see yet.

### Self Paced & Balanced

Like a lot of classical games, TNG is self paced. By self paced I mean it has hollistic way to balance and pace itself without the need for further mechanics. Think about it. When a game board is met,
the entire grid of cards is Hidden Information, nobody knows anything. This is perfectly paced as the players are not overwhelmed with information, they just grokk the size of the board. After cards are
starting to flip, the game becomes harder, as you try to keep up with what other players have opened. As cards are starting to disappear into your lap and other player's side the game becomes a bit easier 
(less cards) but also more intense, as mistakes are solely your responsibility and luck can't be blamed. Moreover, as the game progresses, the more cards are flipped, hence the information becomes 
partially available to all players.

An even classical example of a self balanced and paced game is Pool. In pool, whenever you score a ball, you have less balls on the playing field, making your chances 