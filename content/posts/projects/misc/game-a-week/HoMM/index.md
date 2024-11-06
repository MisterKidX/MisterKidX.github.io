---
title: GaW - Heroes of Might & Magic
draft: false
date: 2024-04-11
description: talk about the game
menu:
  sidebar:
    name: HoMM
    identifier: heroes-of-might-and-magic
    weight: 1
    parent: game-a-week
hero: banner.png
tags: ["game design", "game development", "prototype", "pc", "unity"] 
categories: ["Game", "Project", "Avocation", "Game a Week"]
---

Heroes of Might & Magic III is one of my all time favourite games. It proposes 4 core systesms (heroes, castles, exploration and combat) each feeding each other to create a hollistic and compelling gameplay. Trying to imitate it in one week was both challenging and incredibly fun.

<style>
  .button-link {
    background-color: #008CBA;
    color: white;
    padding: 10px 20px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    border-radius: 5px;
  }
  .button-link:hover {
    background-color: #005f6b;
  }
</style>

<p style="font-size: 36px; text-align: center;">
  <a href="https://misterkidx.itch.io/game-a-week-heroes-of-might-and-magic" class="button-link" target="_blank">Play the Prototype</a>
</p>

## Tech Stack

- Unity [6.23](https://unity.com/releases/editor/whats-new/6000.0.23#notes)
- Unity's 2D packages
- Unity's [Tilemap](https://docs.unity3d.com/2021.3/Documentation/Manual/Tilemap.html) System
- C# scripts

This is the first time I've worked with Unity's tilemap system. It took me a while to get used to it, especially understanding that tiles do not have state, rather they are a [flyweight](https://en.wikipedia.org/wiki/Flyweight_pattern) object copied to their respective positions wherever you place them. I'm still haunted by my aweful decision to make the tilemap hold data and affect combat logic, instead of seperating it to a data layer. All and all I'm glad I chose the tilemap system, especially because it streamlined the level editing part. I'm not sure I would have used it in a production project though, seems like the overhead of connecting to the system and driving custom behaviour is worse than just building it from the ground up (minus the editor tools).

You can watch how I decoded the tilemap into data in the `LevelManager.cs -> DecompileLevel()`.

## Versions

Feel free to visit the [git](https://github.com/MisterKidX/GameAWeek/tree/HeroesOfMightAndMagic) repo and go through the versions, they are all tagged.

### Version 0.1 - Main Menu

Being me I started with the most useless part of the game that proves nothing of it - the main menu. This might seem like an odd decision, but when you start a new project the blank paper paralysis looms over and sometimes you just need to start somewhere. It doesn't matter where you start, it only matters that you do.

Core frontend features:

- move to nonexisting gameplay by pressing a button
- choose a name which will be viewed nowhere
- choose a starting castle
- choose a color
- you can add and remove players

The good thing I got out of this menu is finalizing how I will load game content and use it. For example, the castle dropdown is automatically populated by all designer defined castles. 

![](v0.1-MainManu.gif)

Now that the main menu is done, I needed to confront which system I am going to tackle first. My view on prototypes have never changed - they need to prove gameplay. What is the core in HoMM? In the terms of systems, it's **heroes** and **castles**, occupying a 2D **game map**. When two opposing entities collide, they enter a **battle**. This what makes the game for me.

### Version 0.15 - Basic Heroes & Castles

Perhaps the true name of the game, Heroes & Castles are entities that are the core of HoMM - they drive gameplay, interactions, outcomes and friction. Tackling them first would be the smartest thing to do. While looking fairly simplistic and underwhelming on the frontend quite a lot was done to get the game going - mainly in terms of working with the tilemap system. Now the level designer can place Ground tiles and CastleEntrance Tiles to decide how the level will look. The placed Castle Entrance tiles are read by the level manager who then proceeds to inject a castle with the player's color and a hero. this is the first interaction between the level design and the game's systems, a crucial part for the rest of development.

Core frontend features:

- heroes and castles are shown with the correct color


![](v0.15-HeroesAndCastles.png)

It's maybe a good time to stop and talk about the architecture I was already using.


#### Core Architecture - MVI: Model View Instance

MVI is my fabrication, although I have seen it in different forms across other game projects. MVI is the unholy child of [MVC](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) and [MVP](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter) it proposes to solve the complex interaction between designers, programmers and artists while also decopling state from data and gameobjects (in Unitys case) from the business logic. This is not a pattern which is specific for unity, but works well with the engine nonetheless.

- Models: unlike typical MVC models, models in MVI do not change state. Ever. They are immutable types intended on holding data, nothing else. They represent designers definitions of different entities. *Designers deal with models*.
- Instances: are the living entities in the game and hold the mutable state missing from their attached model. In many ways they are like gameobjects, but with pure data, no manifestation in the scene. *Programmers deal with Instances*.
- Views: are manifestastions of Instances. Each instance can have multiple views. Views are what the player sees and interact with, although all they do is follow the state of their instance and present it properly. Viewes can also be connected to a model instead of an instance. *Artists, UI\UX and Tech Artists deal with Views*;

I love MVI, and when it comes to systems heavy games I use it whenever I can.

So in the case of our HoMM prorotype, I created different models for heroes and castles. Once the game loads, a new instance of each model is created to represent a live entity in the game. Then the views proceed to showing those instances in the scene.

### Version 0.2 - Hero Movement, Gameplay UI, Interactables & Sequencing \[30:41\]

Traversal is important in HoMM, both in combat and in the game world. Positioning of the hero on the map triggers so many other systems, so it needs to be adressed ASAP. Moreover, my [A*](https://en.wikipedia.org/wiki/A*_search_algorithm) and [Dikjstra's](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) were pretty rusty and I needed to tackle that. The interaction between the tilemap system to the game's systems paid off - creating interactables and movement blockers was fairly easy.

Core Frontend Features:

- heroes move about the map
- terrain types affect movement
- there are trees which block movement
- 2 unique resources, gold and gems
- the player can grab (interact with) resource stacks which add to the player's resource pool
- the player can capture mines (don't do anything just yet)
- sequencing! players can now finish their turn and pass it to the next player
- gameplay UI - mostly wireframe, but can be used to pass turns and see resources

![](v0.2-HeroMovement.gif)

### Version 0.4 - Castles & Units \[19:27\]

I spent 9 hours building the castle view and the player's interaction with it. There's a lot of UI here, and the player can interact with her units populating the units bar. This version crossed the 50% mark. but I was hopeful. I knew a lot of my time went on designing systems rather than implementing content. I knew that even 5 hours would be enough to make the demo level somewhat playable. As long as the systems are constructed, everything else will fall into place.

Core frontend features:

- Time system, days move forward (other systems can interact with the passage of days)
- Castles main view
- Heroes can visit castles and change their unit lineup
- Can buy buildings from castles which is reflected in the castle view
- Can purchase units depending on your built buildings
- Units replenish each week according to their Growth stat

<div style="text-align: center;">
    <img src="v4_1.png" style="width: 300px; height: auto;">
    <img src="v4_2.png" style="width: 300px; height: auto;">
    <br>
    <br>
    <img src="v4_3.png" style="width: 300px; height: auto;">
</div>

### Version 0.85 - Combat & Neutrals \[08:19\]

Combat was a big one. I even stayed true to original game by making the grid hexagonal, which in turn pushed me into revising another A* algorithm. Seemingly a simple change in neighbors, my A* was tightly coupled to the world traversal grid, and the new A* needed to read the combat map (this is obviously a design flaw, see my comments on this [below](#if-this-was-production)).

Implementing unit combat AI seemed daunting at first. I remember that in the [preliminary design](https://drive.google.com/drive/folders/1rnz0OZENPm-wVKP767vL-LVhQs5o4fRf?usp=drive_link) phase I promised myself not to go into it. Instead, I decided that the other player will play for the neutrals. But, if you think about it, implementing unit combat AI is actually simple - find the nearest opposing unit, move to the closest availble tile to that unit and if possible, attack. Ranged units are even easier than that. The complex AI is the Heroe's - which of course I didn't implement.

Core Frontend Features:
- neutral units can be created and placed on the map in the editor
- can enter combat with neutral units
- combat has outcomes screen
- heroes can enter combat with each other

![](v85_combat.gif)

### Version 1.2 - Content & Game Loop \[-00:41\]

Unlike most programmers think, a game is not only its systems, its also the sheer breadth of content and gameplay design that goes into it. Given the last version state, the prototype could barely be called a game, it was a proof that the mechanics work, but not that they are coherent enough to be fun. But thanks to the extended time I worked on the systems, creating content was fast. At least on the technical side, being creative after 40+ hrs of work is another issue.

Core Frontend Features:
- added wood and ore resources
- mines now work and there's a mine for each resource
- castles can now be captured
- game can be concluded (lose and win)
- tavern was added to the buildings, you can now build a hero when your main dies
- human castle completed
- undead castle added
- made the level more interesting to traverse and interact with

![](v1.2_content.png)

### Version 1.4f - Game Feel \[-10:00\]

A game is nothing without polish, and although this is a prototype, I felt the dire need to polish it up. Simply adding music changed everything.

Core Frontend Features:
- added projectile for archers
- added backgrounds for combat
- added music, ambiance and sfx
- added theme music for castles
- main menu looks sick
- heroes animate in traversal
- added contextual cursors
- balanced units, resources and castle buildings
- a lot of minor fixes and chages that give a more coherent and fun experience

<p style="font-size: 36px; text-align: center;">
  <a href="https://misterkidx.itch.io/game-a-week-heroes-of-might-and-magic" class="button-link" target="_blank">Play the Prototype</a>
</p>

{{< youtube id="8TbZqxHaDEM" autoplay="false" >}}

## Summation

### Known Mechanics Left Behind

As you might notice, not all HoMM game features are implemented, in 50 hrs. that would be impossible. But, I chose carefuly what to leave behind. You might notice there isn't a:

- Fog of war
- minimap
- context ui
- RPG mechanics for heroes
- Spells
- Many interactabled
- more stuff I forgot

While these are essential for a full game, I believe a prototype that's designed to prove gameplay can sustain itself without them. If you would let me play this and tell me "imagine heroes have rpg progression" I would nod in complete understanding. On the contray, if you told me to imagine the traversal mechanics or the combat, I would tell you to just develop it. People have a harder time imagining gameplay than visualizing known systems. Gameplay loop is more improtant than another half baked mechanic.

### If This Was a Production Game...

Oh boy. The only thing I would've done is keep MVI, and still I would build it properly, with factories and code generation. Here are just some of things I would change:

- Code quality, obviously
- The A* algorithm should be indifferent to the game's intent. Honestly, it's an algorithm that you should take with you to other projects. Moreover, I don't think A* is especially needed here, Dijkstra's shortest path would do better. I would consider using [Greedy Best First Search](https://en.wikipedia.org/wiki/Best-first_search) for checking if movement is even possible on the game map. I would use [Breadth First Search](https://en.wikipedia.org/wiki/Breadth-first_search) for finding available to walk combat tiles. Since this is a turn based game, I didn't find A* very useful.
- I would reconsider using Unity's tilemap. While being very handy for artists, I found it less convenient as a developer. I would also consider using a level editor to allow player created maps and to streamline the level creation for level designers.

### Extending

While the code is a shitshow, extending the content (not the mechanics) of the game is rather easy. This includes: new heroes, castles, units, neutrals, ground tiles, resources and interactables. Watch the video below to get a sense of it.

### Hours

Hour Summary

* Predesign - 1.5 hrs.
* Core - 50 hrs.
* Extra Fluff - 10 hrs.
* Publishing -  1 hr.

## Links

- [Play the Game](https://misterkidx.itch.io/game-a-week-heroes-of-might-and-magic)
- [Design](https://drive.google.com/drive/folders/1rnz0OZENPm-wVKP767vL-LVhQs5o4fRf?usp=drive_link)
- [Trello](https://trello.com/b/60tShNZe/homm) - This is where I managed my tasks.
- [Git](https://github.com/MisterKidX/GameAWeek/tree/HeroesOfMightAndMagic) - Be warned! Code quality is shit. You can find all assets I used under ThirdPartyAssets folder (credits.txt lists where I got them from)
- [Live Developement Sessions](https://www.youtube.com/playlist?list=PLzXqQUJnihnxOvVBvgLyUPKKk8bGXFTcX) - Watch me make a fool of myself during the live sessions
- [GaW Rules](https://www.dorbendor.com/posts/projects/misc/game-a-week/rules/)