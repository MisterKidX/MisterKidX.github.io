---
title: "Model View Instance - An old way to look at game architecture"
date: 2020-06-08
hero: /images/hero.png
description: Blah Blah
draft: true
menu:
  sidebar:
    name: Sequential Coroutines
    identifier: sequentialCoroutines
    weight: 1
tags: ["Unity", "Coroutines"]
categories: ["What"]
---

# What is MVI
MVI is a game architecture pattern that stands for Model-View-Instance. It follows the dogma of MVC closely with the changes neccessary to think beyond UI and into game entities and simulation. For the remainder of this article I want you to know two things:
1. I will use the unity game engine to demonstrate the qualities of MVI. This does not mean MVI is specific to unity in any way, I actually discovered it while I was working on an exercise project in Monogame.
2. To allegorize the utility of MVI we will pretend we are working a new RPG game with monsters, items, characters and the whole shabang. Don't worry, I will also give examples from previous projects of mine.

![alt text](mvi-cover.webp)

MVI is first and foremost a production architecture. Its intended to solve the pipeline of the Game Designer -> Developer -> Artist \ Tech Artist. Each team member can work seperatly in his own world without relying on the other's status of work. In unity terms, this means that game designers work with scriptable objects, programmers work with code and artists work with prefabs. Outside of unity designers could work with json, programmers with POCOs and artists with simple scripts that connect the instance to the view.

MVI stands for Model View Instance and at its core it breaks down traditional OOP concepts such as objects being state and behaviour. In MVI, models are read and data only classes that contain designer definitions, numerics (balance), and references. Models are just sheets of papaer the designer uses to manifest her ideas. if we apply that to our example, a model can be something like this

```yaml
type: Enemy
Name: Goblin
description: a greenish creature with the stature of a human kid
HP: 10
Damage: 5
```
this model is of course extremely simple but it'll do the job. 

So what are instances? Instances are instances of models, and they provide the state for the data. An instance is an actual entity that takes place in the world, while models are just data. Models <-> Instance have a cardinality of one to many, as in one model can have multiple instances with different state.

Imagine our player meeting 3 goblins in a dark cave, what would that mean in terms of instances and models?
There will be one model for the goblins and one model for the player. There will be 3 instances of goblins, and 1 instance of player. Get the gist? If a player defeats a goblin, that instance can be disposed of and its no longer part of the simulation. It is important to say that all instances point to their model, they are fully aware of it and can use the data stored there to run logic on their part. You might have guessed it already but instances are the domain of the programmers. They make sure behaviour runs smoothly and that new additions\changes to the model are reflected through the instance.

so what are views and why do we need them? It is true that instances are objects that are part of the game simulation, but that doesn't mean the player actually sees anything. That is where views come into play. Views represent instances (and models, we'll see soon) in many different forms and shapes. A view can be a 3D model (like our goblin) but it can also be a UI element (like out goblin's hp bar). Views point to their representing instance, and use its data to run its view logic. Instace <-> Views have a relationship of one to many, as in one instance may have multiple views. It is important to note that unlike the traditional (MVC)Views, MVI views can receive callbacks from the engine and pass it on to the instance. Moreover, views do not neccessarily represent instances, they can also represent models. Imagine you have a codex machanic, one which shows all the enemies you have fought. The codex holds different models, and not different instances of models. Even further, you want the codex to have a cool 3d representation of the inquired enemy, you would create a view for the model, not a specific instance. 

Views are the realm of artists. They are, after all, views.