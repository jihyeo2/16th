+++
date = '2025-05-26T23:11:00-04:00'
draft = false
title = "Finding the missing manager"
description = 'Mhm my new manager at GlowObject Inc.'
tags = ["re_csgo"]
categories = ["technical"]
[cover]
image = "images/glowobject.png"
hiddenInList = true
+++

> - **I'll be talking about a part I was stuck at when I was writing a CS:GO glowhack.**
> - {{< collapse summary="**TLDR**" >}}

For a glowhack, you'll need access to the `GlowObjectManager`. If you cannot find it with an offset dumper and need to locate it manually like I did, you should start by looking at functions like **RenderGlowEffects** or **DoPostScreenSpaceEffects** using the keyword **"EntityGlowEffects"**. By analyzing the assemly and setting breakpoints at either function, you can trace and find the address of `GlowObjectManager` (in my case, it was at `client.dll + 0x535fcb8`).

{{</ collapse >}}

---

## GlowHack

What is a GlowHack? Yep, whatever you are thinking is probably right.   

A glowhack makes entity models “glow” through walls, typically in the form of an outline, by modifying how they are rendered in memory. It is not limited to just players--it can be applied to weapons and surrounding objects too. Naturally, this gives the player a huge advantage by revealing opponents regardless of line of sight.  

Pretty intuitive, right?

---

## So...Who Is This GlowObjectManager?

In CS:GO, the `GlowObjectManager` is an object that maintains an array of glow objects, each linked to a specific game entity (like a player). Each glow object contains the color, alpha (transparency), and rendering options that tell the engine how to render the glow effect.

From Valve's source code, specifically from [glow_outline_effect.h](https://github.com/ValveSoftware/source-sdk-2013/blob/39f6dde8fbc238727c020d13b05ecadd31bda4c0/src/game/client/glow_outline_effect.h#L25), I got a better understanding of its layout.

```cpp
class CGlowObjectManager {
	CUtlVector< GlowObjectDefinition_t > m_GlowObjectDefinitions;
	int m_nFirstFreeSlot;
}
```

```cpp
struct GlowObjectDefinition_t {
    EHANDLE m_hEntity;
	Vector m_vGlowColor;
	float m_flGlowAlpha;
	bool m_bRenderWhenOccluded;
	bool m_bRenderWhenUnoccluded;
	int m_nSplitScreenSlot;
	int m_nNextFreeSlot;
};
```

Additionally, while reading [GuidedHacking's glowhack guide](https://guidedhacking.com/threads/external-c-csgo-glowhack-tutorial.11822/), I learned more about the `GlowObjectDefinition_t` structure and was able to piece together the following.

```cpp
struct GllowObjectDefinition_t {
    BYTE buffer0[4]; // padding
    EHANDLE m_hEntity;
	Vector m_vGlowColor;
	float m_flGlowAlpha;
    BYTE buffer1[8];
    float bloomAmount;
    BYTE buffer2[4];
	bool m_bRenderWhenOccluded;
	bool m_bRenderWhenUnoccluded;
    bool fullBloom;
    BYTE buffer3[5];
    int glowStyle;
    BYTE buffer4[4];
};
```

---

## Why do I need the GlowObjectManager?

To write a glowhack, I needed two key pieces of information: the addresses of the `GlowObjectManager` and the `GlowIndex` for each entity. Finding the offset of `GlowIndex` was very easy as the [hazedumper](https://github.com/frk1/hazedumper) (it's an offset dumper I use for CS:GO) just dumped the right offset. However, it didn't return a valid adddress for `GlowObjectManager`. 

So began the hunt.

## Finding the GlowObjectManager

### 1. Pattern Scan with an Updated Signature

My first thought was that the signature hazedumper uses for `GlowObjectManager` was simply outdated. I found an alternative online and tried it with my pattern scanner, but it didn’t return anything valid either.

### 2. String search on IDA Pro

Hoping for obvious string literals around glowObjectManager or functions that use it, I simply searched for keywords like "glowindex" and "glowobject" on IDA Pro. The result was...meh. I did find things like `GLOW_ALPHA`, `GLOW_RGB`, and `m_nGlowModelIndex`. They looked interesting, but I didn't find them helpful.  

This is the moment I realized this wasn't going to be a quick win.

### 3. Google

Out of ideas, I just googled how to manually find the `GlowObjectManager`. And omg, I was lucky enough to find [this post](https://aixxe.net/2017/01/source-internal-glow) by aixxe that explained exactly what I was looking for.

---

## Tracking down GlowObjectManager *(ft. IDA Pro, Cheat Engine, and ReClass.NET)*

### 1. Find interesting functions (Static Analysis)

Following aixxe's steps, I searched "EntityGlowEffects" in IDA Pro and found the function called `RenderGlowEffects`. Checking its cross-references led me to another function called `DoPostScreenSpaceEffects`.

![rendergloweffects](/16th/images/rendergloweffects.png)  

![doposteffects](/16th/images/doposteffects.png)

As mentioned in the post by aixxe, the first argument passed to `RenderGlowEffects` should be the `glowObjectManager`. But the address show in IDA (`client.dll+ 0x46246f8`) was not pointing to glowObjectManager. 

![gom_ida](/16th/images/gom_ida.png)


### 2. Play with the functions (Dynamic Analysis)

Not a problem, I can just set breakpoints and inspect the registers on cheat engine. And I did so. I just placed breakpoints on both `RenderGlowEffects` and `DoPostScreenSpaceEffects` and watched the first argument passed into `RenderGlowEffects`. IDA said it should be in the `esi` register, so I looked into it.  

![rendergloweffects_ce](/16th/images/rendergloweffects_ce.png)  

![doposteffects_ce](/16th/images/doposteffects_ce.png)

From the `esi` register, I found [client.dll + 0x534D6E8] or 0x5D6908C4, but it turned out not to be the glowObjectManager. I was quite puzzled here. I took a moment to sccan nearby memory regions for anything that looked like glowObjectManager to no avail.

![wrongoffset](/16th/images/wrongoffset.png)

Just before calling it quits, I decided to check **every** register passed into `RenderGlowEffects` function.  

And there it was--in the `eax` register for some reason: `client.dll + 0x535fcb8`.

![correctoffset](/16th/images/correctoffset.png)

I added the glowObject layout on ReClass.NET for readibility.

![correctoffsetws](/16th/images/correctoffsetws.png)

(I still don't know why it was found from the `eax` register--which is usually reserved for return values--rather than `esi` as IDA suggested. If you know why, please DM me anytime. Even 4am is fine.)

---

## Finishing up

- At a glance, it might seem like I found the `GlowObjectmanger` in just a couple of hours--but in reality, it took around five days. Not five full 24-hour days, of course, but still a good chunk of time. And when I finally tracked it down, it just felt gooooood, so good. What made it more meaningful I think was that I was able to learn how to manually identify the object, approaching it at different angles and methods, instead of relying on offset dumpers. 

- While GuidedHacking's glowhack guide and aixxe's post are likely enough for anyone with some reverse engineering experience, I wanted to document my own step-by-step process in more detail--mainly because there were a few extra obstacles I ran into that I thought might be helpful to share. Hopefully, it’ll help other beginners like me who are learning along the way. (Who cares if I'm spoonfeeding! For babies, you have to chew the food for them sometimes.)

---

## Lesson Learned

Don’t rely too heavily on IDA Pro. Not because it’s bad--it's incredibly useful--but because you’re often looking at IDA’s interpretation of the binary, not the actual source code. It’s a helpful guess, but a guess nonetheless.

---

## Side note / P.S.

- Writing this post was truly a humbling experience. I didn’t realize how difficult and time-consuming it is to clearly explain what I’ve done and why. I now have a much deeper appreciation for the guides and posts that have taught me so much over the years. 

---

P.S. If you are coming from the multicheat post, here's what you are looking for. Took me 5 days to figure it out. If you can make it faster, I will...  

I will...!

do nothing! I'm kidding... Here's your praise if it was a breeze to ya.

![clapping](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia1.tenor.com%2Fimages%2F1def5116139f411b659c994289e1f32f%2Ftenor.gif%3Fitemid%3D18600029&f=1&nofb=1&ipt=c69db981d5dc73835e4e2158bb976e8ae6b82ee4de996762eb97b7947041d022)

(Just ignore the fact that this gif is titled sarcastic clap:D)