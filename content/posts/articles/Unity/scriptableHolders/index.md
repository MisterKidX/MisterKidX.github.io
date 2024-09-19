---
title: "Scriptable Holders"
date: 2024-09-18
description: "Scriptable Holders are Decorators for Serializable classes. They provide a simple way to hook plain code into the unity engine."
theme: Toha
draft: false
menu:
  sidebar:
    name: Scriptable Holders
    identifier: scriptable-holders
    weight: 1
    parent: unity
hero: Banner_ScriptableHolders.png
tags: ["unity", "scriptable objects", "architecture", "coding", "C#", "editor"]
categories: ["unity", "advanced"]
---

### Preface

[Scriptable Objects](https://docs.unity3d.com/Manual/class-ScriptableObject.html) (SOs) are awesome. It's been said before, it will be said in the future and currently, many Unity devs use them to architect their code and write great games. But (you knew this was coming), they are still a tight coupling to the unity engine - Scriptable Objects only make sense inside the unity framework. I noticed most Unity devs don't give a f*** about this, but I do give plenty. To avoid my rant about how writing C# in Unity is like driving a Bugatti at 10 MPH on the freeway I'll just say that I like to write [Plain Old C# Objects](https://en.wikipedia.org/wiki/Plain_old_CLR_object) ([POCOS](https://www.youtube.com/watch?v=yg8116aeD7E&ab_channel=DisneyMusicVEVO)) and that writing code that is not tightly coupled to a specific framework is generally a good thing.

Stemming from this assumption, and admitting that not all code files are yours to change and just inherit from ScriptableObject, I created Scriptable Holders - simple SOs that decorate serializable classes and allow me to hook my plain classes back into Unity.

Scriptable Holders are a framework-specific solution for unity. In essence, they are [Decorators](https://refactoring.guru/design-patterns/decorator) for POCOS - they provide an easy way to hook POCOS into the unity framework. In a semantic way, scriptable holders are like the old [Nullable\<T\>](https://learn.microsoft.com/en-us/dotnet/api/system.nullable-1?view=net-8.0) implementation in C#, or [Lazy\<T\>](https://learn.microsoft.com/en-us/dotnet/api/system.lazy-1?view=net-8.0). They just wrap around a value to give it special properties, in this case, hooking it to unity.

I originally needed them a couple of years back while wanting to debug and create client-side mock environments for my client's server. I wrapped serializable API responses, thus allowing both me and the QA to quickly change and view the response in editor time to suit our needs.

<p float="left" align="center">
  <img src="MockAPI.svg" width="30%" />
  <img src="MockAPIHolder.svg" width="30%" />
  <img src="scriptableHolderAPIResponse_noEditor.png" width="30%" />
</p>

### Abstract

**Problem Statement** - I want to hook my C# code to unity without inheriting from `ScriptableObject`, either because I can't or because I don't want to tightly couple my code.

**Solution** - Scriptable Holders: SOs designed to hold an external serialized class value.

#### Code Solution

Let's create an abstract class that will hold the structure of what Scriptable Holders (SH) do. Derived classes would just need to inherit from this base class and add an attribute for creating the SO.

``` C#
public abstract class ScriptableHolder<T> : ScriptableObject
{
    public T Value;
}
```

<p>

this sets us on a good path[^1]. Let's test an implementation and see it in the Unity editor.

``` cs
[UnityEngine.CreateAssetMenu(menuName = "Create Player Mock API Holder")]
public class PlayerMockAPIResponseHolder : ScriptableHolder<PlayerMockAPIResponse> { }
```

``` cs
[Serializable]
public class PlayerMockAPIResponse
{
    public string Name;
    public int Money;
    public int Damage;
    public float DamageReduction;
}
```

<p>
<p align="center">
 <img title="Player Mock Response Holder" alt="an image of an SO holding reference to the mock API class" src="scriptableHolderAPIResponse_noEditor.png">
</p>

Now we have a base class for holding external values. All this SO does is wrap around the T value, in this case, the `PlayerMockAPIResponse`. Imagine you get an API response from your server and want to debug its values easily: create local mock responses, mutate existing responses, visually see the response, and allow less technical staff to view the data.

You can also easily use the ScriptableHolder\<T\> class as a member of any other class, and monobehaviours will serialize it properly.

``` cs
public class MBTestSH : MonoBehaviour
{
    public ScriptableHolder<PlayerMockAPIResponse> genric;
    public PlayerMockAPIResponseHolder dervied;
}
```

<p align="center">
 <img src="MBTestSH.png">
</p>

This is enough to start using this framework solution, but... I've used holders for quite some time and seeing that annoying foldout arrow and having all the data indented annoyed the living hell out of me. It's time for some editor scripting y'all.

### Editor

In our editor scripting journey, we are going to do the following:

- we are going to get rid of that annoying foldout arrow
- we are going to apply the editor script to all inheriting members of ScriptableHolder base class
- we are going to deny wrapping around MonoBehaviours
- we are going to deny wrapping around none supported types
- we are going to set a customized icon for all holders
- we are going to set a customized icon for bad holders

#### The Annoying Foldout Arrow

You would expect Unity to have a simple API method for this, or even something hidden you could extract with reflection. But no. We have to do it manually.

``` cs
using System.Reflection;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(ScriptableHolder<>), true)]
public class ScriptableHolderEditor : Editor
{
    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        SerializedProperty valueProp = serializedObject.FindProperty("Value");

        if (valueProp != null && valueProp.propertyType == SerializedPropertyType.Generic)
        {
            var SOType = target.GetType();
            var type = SOType.GetField("Value").FieldType;
            var fields = type.GetFields(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);

            foreach (var field in fields)
            {
                SerializedProperty fieldProp = valueProp.FindPropertyRelative(field.Name);

                if (fieldProp != null)
                    EditorGUILayout.PropertyField(fieldProp, new GUIContent(ObjectNames.NicifyVariableName(field.Name)));
            }
        }

        serializedObject.ApplyModifiedProperties();
    }
}
```

<p>

All and all this is pretty straightforward. We collect all fields of the serialized class, find their respective Serialized Properties, and serialize them back. Using Serialized Properties assures us we only show the fields that should be serialized, and we hook into Unity's Do\Undo system and save system.

[`ObjectNames`](https://docs.unity3d.com/ScriptReference/ObjectNames.html) is a helper class for displaying field names nicely (e.g. field name could be _myVar and display is My Var).

Pay attention to [`[CustomEditor(typeof(ScriptableHolder<>), true)]`](https://docs.unity3d.com/ScriptReference/CustomEditor-ctor.html), we added another boolean argument with a `true` value. This will allow our editor script to be drawn for all inheriting classes of ScriptableHolder<>. Without this, you would see no changes to the editor representation of holder objects.

Open Unity, create a new instance of `PlayerMockAPIResponseHolder` and watch that nicely none-tabbed data. That menacing arrow is gone.

<p align="center">
 <img title="Player Mock Response Holder" alt="an image of an SO holding reference to the mock API class with the editor script" src="scriptableHolderAPIResponse.png">

<p align="center" style="color:gray;font-size:12px"> <i>"Oh, thank god" - OCD game dev</i> </p></p>

#### Denying Bad Generic Arguments

Our Scriptable Holder is intended to hold a reference to Serializable POCOS, nothing else. Although theoretically, it can hold any value, I didn't find any reason to support this via editor script ([YAGNI](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it)). This means we need to notify anyone using a Scriptable Holder that she is doing something wrong. Adding the following `else` clauses closes the deal.

``` cs
else if (valueProp != null && valueProp.propertyType == SerializedPropertyType.ObjectReference)
    EditorGUILayout.HelpBox("You cannot wrap values that derive from UnityEngine.Object.", MessageType.Warning);
else
    EditorGUILayout.HelpBox("No valid 'Value' property found.", MessageType.Warning);
```

<p>

Now this is how things look like if we try to wrap around a Gameobject.

<p align="center">
 <img title="Player Mock Response Holder" alt="an image of an SO holding reference to the mock API class with the editor script" src="WrappingGameobject.png"></p>

#### Improving Editor UX

To differentiate our Scriptable Holders from other common-peasent scriptable objects we need a customized icon. While setting icons can be done through the editor, in this case, it'll not work. Since `ScriptableHolder` is abstract, it never has instances, and derived classes do not "inherit" icons. We must do this through our editor script, as follows:

``` cs
// this is instead of setting the icon manualy for each new derived ScriptableHolder
public override Texture2D RenderStaticPreview(string assetPath, Object[] subAssets, int width, int height)
{
    var icon = AssetDatabase.LoadAssetAtPath<Texture2D>("Assets/Gizmos/ScriptableHolder Icon.png");
    EditorGUIUtility.SetIconForObject(target, icon);

    return base.RenderStaticPreview(assetPath, subAssets, width, height);
}
```

<p>

<p align="center">
 <img src="inspectorIcon.png"></p>
 <p align="center">
 <img src="heirarchyIcon.png"></p>

Of course, we need a texture named so in the Gizmos folder[^2], if you are building this on your own instead of forking the repo, you can go ahead and use the icon i've prepared in the repo.

There's one final touch before wer'e through. I want Scriptable Holders with bad generic argument to show a warning icon. Let's refactor:

``` cs
// this is instead of setting the icon manualy for each new derived ScriptableHolder
public override Texture2D RenderStaticPreview(string assetPath, Object[] subAssets, int width, int height)
{
    SerializedProperty valueProp = serializedObject.FindProperty("Value");

    if (valueProp != null && valueProp.propertyType == SerializedPropertyType.Generic)
    {
        var icon = AssetDatabase.LoadAssetAtPath<Texture2D>("Assets/Gizmos/ScriptableHolder Icon.png");

        EditorGUIUtility.SetIconForObject(target, icon);
    }
    else
    {
        EditorGUIUtility.SetIconForObject(target, EditorGUIUtility.IconContent("console.warnicon@2x").image as Texture2D);
    }

    return base.RenderStaticPreview(assetPath, subAssets, width, height);
}
```

<p>

Nothing fancy here, maybe just a bit cryptic. The [`EditorGuiUtility.IconContent`](https://docs.unity3d.com/ScriptReference/EditorGUIUtility.IconContent.html) allows us to fetch internal and default unity icons. 

### Summary

Scriptable Hodlers are great. They allow us to Decorate a serializable class with the capabilites of a Scriptable Object, easily hooking the class to unity and keeping the original code clean and decoupled. They are simple, scarcely used, and they would not change the way you work with Unity - which is exactly why I like them.

##### Important Links

[🔗 My Git Repo for Article](https://github.com/MisterKidX/Articles/tree/ScriptableHolders) - find a complete unity project with all code samples present

[🔗 My Unity Coding Toolset Repo](https://github.com/MisterKidX/UnityCodingToolset) - my coding package for unity, which scriptable holders is a part of (doesn't really deserve a standalone package)

 [🔗 Unity Editor Icons](https://github.com/jasursadikov/unity-editor-icons) - Check out this great repo for all the editor internal icons.

#### Final Code

``` cs
using System;
using UnityEngine;

public abstract class ScriptableHolder<T> : ScriptableObject
{
    public T Value;
}

[Serializable]
public class PlayerMockAPIResponse
{
    public string Name;
    public int Money;
    public int Damage;
    public float DamageReduction;
}
```

``` cs
using System.Reflection;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(ScriptableHolder<>), true)]
public class ScriptableHolderEditor : Editor
{
    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        SerializedProperty valueProp = serializedObject.FindProperty("Value");

        if (valueProp != null && valueProp.propertyType == SerializedPropertyType.Generic)
        {
            var SOType = target.GetType();
            var type = SOType.GetField("Value").FieldType;
            var fields = type.GetFields(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);

            foreach (var field in fields)
            {
                SerializedProperty fieldProp = valueProp.FindPropertyRelative(field.Name);

                if (fieldProp != null)
                    EditorGUILayout.PropertyField(fieldProp, new GUIContent(ObjectNames.NicifyVariableName(field.Name)));
            }
        }
        else if (valueProp != null && valueProp.propertyType == SerializedPropertyType.ObjectReference)
            EditorGUILayout.HelpBox("You cannot wrap values that derive from UnityEngine.Object.", MessageType.Warning);
        else
            EditorGUILayout.HelpBox("No valid 'Value' property found.", MessageType.Warning);

        serializedObject.ApplyModifiedProperties();
    }

    // this is instead of setting the icon manualy for each new derived ScriptableHolder
    public override Texture2D RenderStaticPreview(string assetPath, Object[] subAssets, int width, int height)
    {
        SerializedProperty valueProp = serializedObject.FindProperty("Value");

        if (valueProp != null && valueProp.propertyType == SerializedPropertyType.Generic)
        {
            var icon = AssetDatabase.LoadAssetAtPath<Texture2D>("Assets/Gizmos/ScriptableHolder Icon.png");

            EditorGUIUtility.SetIconForObject(target, icon);
        }
        else
        {
            EditorGUIUtility.SetIconForObject(target, EditorGUIUtility.IconContent("console.warnicon@2x").image as Texture2D);
        }

        return base.RenderStaticPreview(assetPath, subAssets, width, height);
    }
}
```

``` cs
[UnityEngine.CreateAssetMenu(menuName = "Create Player Mock API Holder")]
public class PlayerMockAPIResponseHolder : ScriptableHolder<PlayerMockAPIResponse> { }
```

[^1]: If you are worried about encapsulation of the Value field, you can use a virtual property to allow inheritors to define their own access modifier to the value.

[^2]: You don't have to place the image in the Gizmos folder or name it so, but... Images places in the Gizmos and named in the following pattern "\<SCRIPTNAME\> Icon" will replace the icon for the script.