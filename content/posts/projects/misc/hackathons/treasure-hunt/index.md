---
title: "Treasure Hunt"
date: 2021-01-31
description: 1v1 async multiplayer game where each player hides his treasure, and tries to find his opponents.
menu:
  sidebar:
    name: Treasure Hunt 
    identifier: treasure-hunt
    weight: 35
    parent: hackathons
hero: banner.gif
tags: ["casual", "unity", "game jam", "webgl", "game design", "game dev"]
categories: ["Game", "Project", "Hackathon"]
---

<center> <i> 1v1 multiplayer game in which  each player hides his treasure, and tries to find his opponents.  </i> </center>

<div align="center" style="width: 100%">

<style>
    /* Basic styling for readability */
    table {
        width: 90%;
        margin: 20px auto;
        border-collapse: collapse;
        font-family: Arial, sans-serif;
    }
    th, td {
        padding: 12px 15px;
        text-align: center;
        border: 1px solid #ddd;
    }
    th {
        background-color: #add8e6; /* Light blue color */
        font-weight: bold;
    }
    tr:nth-child(even) {
        background-color: #f9f9f9;
    }
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

<table>
  <tr>
    <th>Genre</th>
    <th>Tech Stack</th>
    <th>Platform</th>
    <th>Role</th>
    <th>Status</th>
    <th>Part of</th>
  </tr>
  <tr>
    <td>Casual</td>
    <td>Unity, PlayFab</td>
    <td>PC, WebGL</td>
    <td>Game Designer, Unity Developer</td>
    <td>Completed</td>
    <td><a href="https://v3.globalgamejam.org/2021/games/find-treasure-3" target="_blank">GGJ 2021<a></td>
  </tr>
</table>

<br>
</div>

<p style="font-size: 36px; text-align: center;">
  <a href="https://misterkidx.itch.io/treasure-hunt" class="button-link" target="_blank">Play the Game</a>
</p>
<p align="center">
Make sure you look for a match with atleast one more player!
</p>

<br>

##### Overview

It was SO-MUCH-FUN making this game (excuse the all-caps but I really mean it) in the 2021 Global Game Jam. In just **48** hours (- kids time) we managed, me and my buddy Gilad, to create this beautiful, simple, fun game. What I love about this design is its simplicity and elegance. A Core mechanic, finding the opponents treasure with radars and nothing more. This core mechanic is so much fun that every other gameplay element that would have been added would just detract from the core experience.

<div align="center">
  <img src="sc1.jpg" alt="" style="width: 40%; display: inline-block; margin: 0 auto;" />
  <img src="sc3.jpg" alt="" style="width: 40%; display: inline-block; margin: 0 auto;" />
</div>

##### The Game

The gameplay is simple enough for a child, move around using the WASD, hide your treasure in the map and then find the opponents treasure before he gets to yours. The main radar is a circular one that grows bigger as you hold the action button, but there are small radars with small radius that can be placed for a couple location to pinpoint the exact location of the treasure once you're near it. And of course all of this is backed by a countdown timer, so you're racing against the clock as well!

The entire "multiplayer" aspect of the game is actually based on PlayFab backend services. While not its original intent, I misused the platform's features to make it that both players could enter a multiplayer sessions and send messages to each other. This way I could sync the position of the treasures for both players. Hackathons is all about hacking for me :D

{{< youtube id="AJNCNuRPxgo" autoplay="false" >}}