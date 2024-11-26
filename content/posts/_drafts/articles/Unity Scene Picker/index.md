---
# ALWAYS NAME FILE index.md otherwise problems with hero
# https://toha-guides.netlify.app/posts/writing-posts/organizing/category/
title: "Template" # title of the post
date: 2024-09-16 # Date of the post, can add time -> T06:00:23+06:00
hero: /images/hero.png # the image for the post
description: template for posts #...
theme: Toha
draft: true # signifies if this blog post is still a draft
#if you want to change the default author
# author:
#   name: Md.Habibur Rahman
#   image: /images/authors/habib.jpg
math: false # change this to true to use math functions (delimited by $$ EXPRESSION $$)
menu:
  sidebar:
    name: Template # This defines what would be the name of the document in sidebar file hierarchy
    identifier: template # this will show in the search bar
    weight: 1
    parent: parent-identifier
tags: ["t1", "t2"]
# Unity: scriptable objects, editor
# general: math, algorithms
# development: architecture, coding, C#,
categories: ["template"]
# tech stack: unity
# general: math
# level: beginner, advanced, intermidiate
---

### Preface: the good, the bad, and my rant

If you don't find things that annoy you in a software product (programming language, framework, engine) then you are not really proficient with that product. I don't mean to offend anyone or reduce the effectiveness of great software, but if you don't see the downsides you can't much appreciate the upsides. For example, the [terneray conditional operator](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/conditional-operator) in C# is cool and concise, you can do this with it:

``` cs
bool b = true;
int i = b ? 1 : 0;
```

But you can't do this (submitted it as a proposal - yet can't find it)

``` cs
bool b = true;
b ? Foo() : Bar();
```

And if this seems controversial, take a second to comprehend that we got [file scoped namespaces](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/csharp-10.0/file-scoped-namespaces) only in C# 10 while java had them forever.

Excuse the long winding road to prove a point - software is soft, it needs to change to  make up for its quirkiness or missing features.

So why are we here today? Let's talk about why Unity beautifully serializes all of its internal types and assets, but for some reason they thought it was a good idea to load scenes with strings and integers (I'm being sarcastic).

### Abstract

**Problem Statement** - I want to load scenes in unity but I have to rely on scene names or scene build index

**Solution** - move to another engine || create a new representation for a scene and use an editor script to rely on strong references.

// show image of final solution in unity, both combo box and dragging of reference

### Scenes as Integers & Strings

You probably know why it's a bad idea, but I'll tell you anyhow. Build Indices can change, scenes can be renamed. This the root of all evil when loading scenes. Compare this to having to change a static variable name manualy across an entire domain, over multiple assemblies, without warnings or errors what-so-ever.

If you change the scene build settings all API calls to `SceneManager.LoadScene(buildIndex)` are susceptable to load another scene than the one intended. e.g., if you wanted to load a scene at index 1 and just added a scene to index 0, you will actually load the scene previously at index 0. This is horrendeous, and i'm not being dramatic (well, maybe just a bit), especially if loading scenes is hidden in multiple scene assets.

On the `string` side, it's not [much better](https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley). A simple rename of a scene causes a chain reaction to any scene loading mechanism in the `SceneManagement` namespace (e.g. `SceneManager.LoadScene(sceneName)` ) effectively throwing errors all around.

Developers have accepted this hard truth and have devised methods to deal with this nonesense.

### Traditional ways to deal with scene loading

These methods are not mutually exclusive, and it's definitly not an exahustive list.

If you don't care about this and just wanna skip to the good [stuff](#the-scene-object), be my guest.

#### Use only the first build indices

If you lock your first build indices to specfic scenes, alerting everyone on your team this cannot change, it allows you to use scene loading by index for those scenes only. This can only work properly if you start from index 0. For example, I installed a habit that the scene at index 0 is always the `preload` scene, dedicated to load all neccessary materials before the game \ main menu runs.

// show picture

#### Use and Enforce a Naming Scheme

Naming stuff is hard, we all know it, and scenes are no different. Yes, "sewers_112_new_rainIncluded" is not a good name. By enforcing a naming convetion on your scenes, you not only create better project structure, you also make it easier to load scenes based on a pattern rather than a magical string value. These patterns will allow you to load scenes from code without even looking at the scene name.

Both these methods are nice but they are still very much error prone.

// show a picture

#### Create validation tools

Validation tools are the realm of diligent developers who are eager to have a machine tell them when they go astray. They are like Goldylocks porridge bowls, too much will siphon development time from what really matters (your game or your family, choose now), too little will cause human error to make one of the programmers spend 3 days solving a bug that shouldn't have happened in the first place, and just enough will make your development smoother[^1].

Assume we enforce a [naming scheme](#use-and-enforce-a-naming-scheme). Enforcing it socially without validation is nice but not bulletproof. Misspells, new teammates, fatigue, git reverts and over caffinating can certainly break naming conventions.

A simple validation tool, hooking to a [Processor](https://docs.unity3d.com/ScriptReference/AssetModificationProcessor.html) class, will take you a long way. Now whenever anyone tries to name a scene in a way that deson't sit with the convention (I know we all hate regex but its useful), you pop a modal and tell them to f*** off. 

This is the [Fail Gracefully](https://en.wikipedia.org/wiki/Fault_tolerance#Terminology) ideology - for example, you know you need to reference stuff in the inspector but you sometimes forget. isn't nice that Unity tells you that in the logs? Don't let your team make mistakes that could easily be avoided.

#### Wrap the unity SceneManagement API

The most basic thing you can do is make all scene loading by name reference a `string` `const` rather than a literal[^2]. You can then move on to create a class that wraps around the API and prehaps turn those strings into `enum`s, and provide a safer way to load scenes.

A more advanced approach would be to wrap all scenes in a scriptable object. I really like this approach and its also easy to validate vs. the built scenes.

#### Don't use scenes

Yep. Some of my clients had 1-2 scenes and that's it. Everything else was done with prefabs and scriptable objects. Scenes are a tool, you don't have to use them (although I quite like'em).

### Scene Assets to the Rescue

Did you know unity has MULTIPLE definitions of a scene?
- There's the runtime version most of us know, the struct [`SceneManagement.Scene`](https://docs.unity3d.com/ScriptReference/SceneManagement.Scene.html )
- an asset version for edit time known as [`SceneAsset`](https://docs.unity3d.com/ScriptReference/SceneAsset.html)

Scene Assets are awesome. They are exactly what we need to control the referencing of scenes from our serialized objects.

Armed with this newfound knowledge we set out to create a new class that will truly represent scenes, both in editor and in runtime.

#### Scene Object

Scene objects wrap around the concept of a scene at runtime, i.e. its index and name.

!!!! Need to address the fact that a scene change in the editor doen't reflect immediately on all Scene objects

### Addressing the Obvious: Failing Builds

Our only failed, and most important test, is the changing name\dir\index before build. here are ways to solve this:
- Editor Utility.Set Dirty
- Preprocessors for scene assets
- Build Processors
- saving the scene assets during editor time and converting it to string and int in the end
- using scene build processor to find all monobehaviours which hold a reference to Scene and update them manualy. Make sure when a scene name\dir is changed that a frash build must be made.
- I THINK THIS IS IT! wrap scenes with an SO and register a custom dependency between them. Any changes to the scene will be reflected through the SO immediately, and the [ScenePicker] attribute will use the SO's instead of the scenes directly.

I'll handle this in a next chapter

### [ScenePicker] for strings and integers

While decorating `string` types and `int` types has a pretty straightforward approach, its also extremely naive. Consider these test cases:
- scene renaming
- scene moves directory
- scene is renamed and moved to another directory
- restarting unity editor
- changing scene build indices
- no scenes in build index
- delete referenced scene
- make changes to the scene outside unity

If you use the regular approach with strings and integers for loading scenes, you would expect that changing scene build order or renaming scenes might have a catastrophic result with scene loading in your game. but if you use a [ScenePicker] attribute which shows a string\int field as a selectable scene asset, you would expect it to be a **hard reference** to that scene, not something that can easily be broken. In order to do so you must write a lot more code.

It's important to note that IMGUI interfaces, i.e. inspectors, are only repainted if the user inetracts with them (even a nouse hover is interaction).

Its improtant to note that these are all problems that may only arrise at Edit time, not at runtime.

#### integers

integer base scene pickers are cool becuase you can only reference scenes from the build index through a combo box, which is cool.

// insert picture here

Alas, changes to the build index can be made, which will directly affect what the integer value points to. Imagine you have 3 scenes in the build index - s1, s2, and s3 - and an integer value points to scene at index 1 (hence s2). Now you delete s1 from the scene index and suddenly that integer value points to s3. that would be ok if the integer was seralized as an Int field but it isn't, it is seralized as a reference to the scene, hence the expectations of the user changes.

So, what would be the steps to make that decorated integer field hold a reference to the scene itself? Let's pseudocode that shit:

1. Know when the scene index changes, specififcally when a scene is deleted or rearranged. This can be esily done with `EditorBuildSettings.sceneListChanged`
2. Each integer field decorated with [ScenePicker] must now change its value according to these rules:
    - If the scene was deleted from the build settings it should point to no scene
    - if the scene was not affected by the change do nothing
    - if the scene index changed, change the value of the int field

I now found two approaches to solve this.

##### Access all files containing [ScenePicker] and change their values

This requires some ground work. You would have to access every scene (and their monobehaviours), prefab, and scriptable object and change that value directly. This can be done with unity's API, or if the assets are forced to text, can also be done by changing the file directly - which is faster and easier but you risk data corruption.

This was my first approach at trying to solve this issue, but I quickly realized I am overengineering.

##### Create a table [...]

#### strings

strings are used with the SceneManagement API to load scene by names. Like their integer friends, they are susceptible to changes and are not a good way to keep your architecture safe from miniscule mistakes.

My first approach with `[ScenePicker]` strings was to save the scene GUID as the string value

// show code example here

This passes all of the relevant tests and its pretty solid - at least for us the developers. The client suffers though, as now she must use multiple API calls to load a scene. Instead of making her life easy, we just added extra steps. You could say I'm being dramatic, and a simple extension method would do the work (it would), but I don't liek writing small tools that change how people work with a framework - for that I write big tools.

// show API for loading a scene from its GUID

The string value should remain what it is, the name of the scene. Alas this approach has similar problems to that of its [string](#strings) counterpart. Here's the pseudocode

1. Know when a scene was changed. This can be done with the [`AssetModificationProcessor`](https://docs.unity3d.com/ScriptReference/AssetModificationProcessor.html) or other Processor classes.
2. Now we must do exactly what we did with the integer field, access all strings decorated with \[ScenePicker\] and change their value to the scene's name. Again, this is not simple, and needs a lot of testing to make sure we are not corrupting the project.

All and all \[ScenePicker\] looks cool on strings and integers, but it is actually a lot harder to implement to get good, rigid and stable results.

### When done with writing
- read proof
- apply external links
- add images
- link to repo

### Where to publish
- Facebook: Israeli unity 3d developers
- LinkedIn: my feed
- LinkedIn: Unity Group
- Reddit: Unity group
- Twitter
- Unity Forums (https://discussions.unity.com/)

[^1] I remember we had out git repo explode with garbage .asset files and what not. I used a git hook to deny all of the development team to push a file larger than 4mb, thus saving our git repo from exploding.

[^2] literals are values you write directly in your code like "hello", 1, 1.0f