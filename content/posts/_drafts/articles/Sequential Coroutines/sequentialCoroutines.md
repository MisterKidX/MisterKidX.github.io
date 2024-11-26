---
title: "Sequential Coroutines"
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

Sequential Coroutines Handlers
Coroutines have been with us for quite some time and seem to be the native way to handle asynchronous tasking within Unity. Due to their nature and flexible API, we can use them to our advantage to create some cool Chain of Responsibility behavior.
Coroutines are famous for their ability to create behaviours that span across number of frames and still allow for the game to run smoothly and accept inputs. They introduce an API much simpler from that of threads and are a great way to incorporate sequential handling techniques. If you haven’t used them yet, too bad, they’re awesome! 

A Little Bit About Coroutines In Unity
If you know what they are, feel free to skip this section.

Coroutines were introduced into the C# language back when C# 2.0 was released, as the syntax of “yield return” (to be clear, there is no native coroutine library in C#, you would have to build your own API). Unity Developers use them extensively, or should, as they provide a simple API to asynchronous programming and native handling of various parallel tasks within the unity game engine. The signature of a coroutine Method is as follows:

IEnumerator _MethodName(_Parameters)

Where IEnumerator is the return type, which is the base of every coroutine in Unity. _MethodName is the name of the method _Pararmeters are optional parameters to pass to the method. The innards of such a function may look like this:

public IEnumerator SomeRoutine()
{
    yield return new WairForSeconds(1f);
    Debug.Log("Yay!");
}


Our Routine will have to be initiated with a StartCoroutine call from a Monobehaviour script.

Routine _routine = StartCoroutine(SomeRoutine);
Notice how the StartCoroutine call returns a routine object we can work with. We’ll see how it comes to use later on. Pretty simple right? Our routine will wait for one second and then execute the debug call.

Chain of Responsibility
Outside the Unity ecosystem, used fairly enough across many platforms and projects, is a unique behavioral Design Pattern called the Chain of Responsibility. The Chain of Responsibility is a pattern that lets you pass data from one handler to the next, each of them processing that data and deciding what to do with it. Here is a quick example of how it works:

namespace Coroutines
{
    class Program
    {
        // Client Code
        static void Main(string[] args)
        {
            var pHandler = new Parser();
            var sHandler = new SecurityHandler();
            var request = new HTTPRequest(new byte[] { 1, 2, 3, 4, 5 });
 
            sHandler.SetNext(pHandler);
            sHandler.Handle(request);
        }
    }
 
    // Interface to define a request
    public interface IRequest
    {
        byte[] Data { get; }
    }
 
    // Interface to define handlers
    public interface IHandler
    {
        IHandler Next { get; }
        void SetNext(IHandler handler);
        void Handle(IRequest request);
    }
 
    // concrete request
    public class HTTPRequest : IRequest
    {
        public byte[] Data { get; private set; }
 
        public HTTPRequest(byte[] data)
        {
            Data = data;
        }
    }
 
    public class SecurityHandler : IHandler
    {
        public IHandler Next { get; private set; }
 
        public void Handle(IRequest request)
        {
            // Security Logic
 
            Next?.Handle(request);
        }
 
        public void SetNext(IHandler handler)
        {
            Next = handler;
        }
    }
 
    public class Parser : IHandler
    {
        public IHandler Next { get; private set; }
 
        public void Handle(IRequest request)
        {
            var req = TryParse(request);
            if (req != null)
                Next?.Handle(req);
        }
 
        private IRequest TryParse(IRequest request)
        {
            // Some Parsing Logic
            return request;
        }
 
        public void SetNext(IHandler handler)
        {
            Next = handler;
        }
    }
 
}
The client code sets up his handlers and chains them together. Each of the handlers implements an interface so the abstraction could be linked easily. In this case, the security handler will check for any malicious intent in the recieved data. If it finds anything wrong it will just cancel the operation of moving to the next handler, leaving the system safe from potential threat. If it finds the data to be safe, he outputs it to the next handler, in our case the parser. Each handler does its job and moves the data onwards, unless stated otherwise. Is this relevant to Unity’s ecosystem as well? It is, but it’s less elegant. Unity, being a component based engine, would prefer to work with concrete scripts adding custom behaviours rather than implement interfaces across many monobehaviours. In our case, every monobehaviour is a potential handler simply due to the fact that it can run coroutines.

So, since we’re here to talk about games, let’s give some examples in proper context.

Coroutines as Handlers
Your’e building a tower defense game which is unequivocally the best one ever made. All is fine and dandy until you reach the point where the main menu must be built. You don’t want just any plain boring menu, you want a lively one that responds to user actions with awesome aural and visual feedback. So you start off by creating some cool fade ins and outs, color transitions and resizing animations. Your code may look something like this:

public class UIEffects : MonoBehaviour
{
    private void OnMouseDown() 
    {
        StartCoroutine(FadeUI());
        StartCoroutine(ResizeUI());
        StartCoroutine(ColorTransition());
    }
 
    public IEnumerator FadeUI()
    {
        yield return new WaitForSeconds(1);
        // fading the UI logic
    }
 
    public IEnumerator ResizeUI()
    {
        yield return new WaitForSeconds(1);
        // resizing the UI logic
    }
 
    public IEnumerator ColorTransition()
    {
        yield return new WaitForSeconds(1);
        // transitioning color of the UI logic
    }
}
You can clearly see how you call the three coroutines when the user clicks the element. This is nice, and at first you’re very satisfied with the result, but your annoying designer “friend” says that the fade in must happen first, resizing second and the color transition must happen last. You grump your face at this rejection of your fantastic work, but you must comply all the same. Here is how you decide to implement this:

using System.Collections;
using UnityEngine;
 
public class UIEffects : MonoBehaviour
{
    private void OnMouseDown() 
    {
        StartCoroutine(FadeUI());
    }
 
    public IEnumerator FadeUI()
    {
        yield return new WaitForSeconds(1);
        // fading the UI logic
 
        StartCoroutine(ResizeUI());
    }
 
    public IEnumerator ResizeUI()
    {
        yield return new WaitForSeconds(1);
        // resizing the UI logic
 
        StartCoroutine(ColorTransition());
    }
 
    public IEnumerator ColorTransition()
    {
        yield return new WaitForSeconds(1);
        // transitioning color of the UI logic
    }
}
Congratulations! The behaviour the designer intended has been achieved! But let’s face it, it can be done better. Take a look at highlighted code lines, see how you explicitly use one routine in another? Instead, let’s pass the routine to the parameters of the function to generalize our intent.

using System.Collections;
using UnityEngine;
 
public class UIEffects : MonoBehaviour
{
    private void OnMouseDown() 
    {
        var routine = StartCoroutine(FadeUI(ResizeUI(ColorTransition(null))));
    }
 
    public IEnumerator FadeUI(IEnumerator next)
    {
        yield return new WaitForSeconds(1);
        // fading the UI logic
        
        if (next != null)
            StartCoroutine(next);
    }
 
    public IEnumerator ResizeUI(IEnumerator next)
    {
        yield return new WaitForSeconds(1);
        // resizing the UI logic
 
        if (next != null)
            StartCoroutine(next);
    }
 
    public IEnumerator ColorTransition(IEnumerator next)
    {
        yield return new WaitForSeconds(1);
        // transitioning color of the UI logic
 
        if (next != null)
            StartCoroutine(next);
    }
}
Noice. See how it resembles the “Chain of Responsibility” design pattern we talked about earlier? This is the basic of using coroutines as handlers. Basic I say, cause we can do much better.
By the way, notice how we must define the sequencing within the same line of code. You can imagine how long list of handlers can quickly become a mess. We’ll fix that later on when we abstract the handler onto its own class.

Observer, Events, and Event Handlers
The Observer Design Pattern is one of the most common patterns out there and has been implemented natively in most programming languages. In C#, it is called events. Unity did the work for us and created the ready-to-serialize-in-the-inspector class called UnityEvent. For this article, we might generalize and say it is a mere adapter for the native events and actions of the C# programming language, and we’ll use them from this point onward.

Events can be disassembled onto two main idioms: publishers and subscribers (AKA listeners). The publisher is the object that started the event, the subscribers are handling that event the way they seem fit. When declaring an event, you must specify the signature of the functions that can subscribe to it.

You finished the work on the main menu; everyone seems super thrilled and happy to see the designers intent come to life (except you, happiness seem to elude you on purpose). But something is bugging you, nudging on your developer’s itchy bone. You can do better with those coroutines handlers, you must do better!

Links

Coroutines with IEnumerable and yield return
https://docs.unity3d.com/Manual/Coroutines.html

https://github.com/ChevyRay/Coroutines/blob/master/Coroutines.cs

https://docs.unity3d.com/Manual/BestPracticeUnderstandingPerformanceInUnity3.html

https://refactoring.guru/design-patterns/chain-of-responsibility