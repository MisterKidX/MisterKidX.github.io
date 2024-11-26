---
title: Unity Packager
draft: false
date: 2021-11-26
description: a lightweight solution for creating unity packages based on the openUPM model
menu:
  sidebar:
    name: Unity Packager
    identifier: unity-packager
    weight: 5 # how important this is compared to other posts 
    # 1-10 importance
    parent: packages
hero: banner.png
tags: ["game dev", "unity", "DevOps"] 
# categories: Game, Project
categories: ["Packages"]
---

<center> <i> A lightweight package allowing developers to quickly create packages that are easily imported into any unity project. </i> </center>

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
    <th>Type</th>
    <th>Tech Stack</th>
    <th>Platform</th>
    <th>Role</th>
    <th>Status</th>
  </tr>
  <tr>
    <td>git</td>
    <td>C#, <a href="https://openupm.com/" target="_blank">openUPM<a></td>
    <td>Unity</td>
    <td>Creator</td>
    <td><a href="https://github.com/MisterKidX/UnityPackager" target="_blank">Production<a></td>
  </tr>
</table>

<br>
</div>

<p style="font-size: 36px; text-align: center;">
  <a href="https://github.com/MisterKidX/UnityPackager" class="button-link" target="_blank">Use the Package</a>
</p>

<br>

Easily create importable packages for unity with this lightweight git package. UnityPackager not only brings you a structure of easily creating upm packages, it also enforces validation and improves user experience by using type safe values and custom logic. This is what UnityPackager can do for you:
- easily create packages for you future projects
- get a ready-made package with comments noting the different aspects and features of a package (like samples)
- documentation on creating a package and enhancing it with different features
- best practice guide