+++
date = '2025-07-25T19:47:00-04:00'
draft = false
title = "Jerry's fart stinks"
description = "What a name for my very first CSGO multicheat. Yep, that's all me at 3am."
tags = ["re_csgo"]
categories = ["technical"]
+++

> - **I'll be going over my first CSGO multicheat. At the time of writing, I'm not even sure what I'll end up talking about here, oops.**
> - {{< collapse summary="**TLDR**" >}}

Author: Julie Oh  
Product: CSGO multicheat  
Product Name: Jerry's fart stinks  
Features: [Features](/16th/posts/jerrysfartstinks/#features)
  
This probably reads more like a product label than a TLDR. Eh whatever, my super genius readers will still get it.
{{</ collapse >}}

---

## Github Repo

[CSGO-multihack](https://github.com/jihyeo2/CSGO-multihack)

---

## A bit of background

I've always enjoyed messing around CSGO and other FPS games, writing mini cheats like flyhack, godmode, aimbot--you name it. One day, I figured it was time to lock in and build a full-on multicheat. (If you are wondering what made me, feel free to DM me--especially dear recruiters:D) Anyways, this is the final product. Not "final" as in the last cheat I'll ever write, but the polished version of my first full CSGO multicheat release.

---

## Jerry's fart stinks

Umm..just a quick note. It is a top secret who Jerry is (I signed the NDA) or whether his fart actually stinks--but you know, it's the content that matters, right? (wink wink) Pretty sure it was around 3am when I came up with the name.

### Important Notice

I didn't do any work around bypassing anticheat, so this only works on private servers for CSGO legacy version. But really, all cheats *should* be used on private servers to respect other players and prevent yourself from getting banned. Remember, there are always this one group of people you can troll--your friends. Just ~~kidnap~~convince them to join your private server. That's basically how I got my cheat playtested.

<!-- ### Preview
So, what's in this gloriously named package? No need to explain, let's just roll the clip.

<<< video >>> -->

### Features

⚔️ **Combat Assist**

&nbsp;&nbsp;&nbsp;&nbsp;🧠 Aimbot [Mouse Side Button - Front] – Automatically locks aim onto enemies for precise targeting  
&nbsp;&nbsp;&nbsp;&nbsp;🔫 Triggerbot [Mouse Side Button - Back] – Automatically fires when an enemy enters your crosshair  
&nbsp;&nbsp;&nbsp;&nbsp;🎯 Recoil Control [F1] – Removes weapon recoil for steady aim  


🧱 **ESP (Extra Sensory Perception) Features**

&nbsp;&nbsp;&nbsp;&nbsp;🗺️ Radar Hack [F2] – Displays enemy positions on the in-game radar  
&nbsp;&nbsp;&nbsp;&nbsp;✨ Glow Outline [F3] – Adds glowing outlines:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 🔵 Allies outlined in blue  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 🟢 Enemies outlined in green  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 🩸 Health-Based Model Color – Gradually tints entity textures red as their health drops  
&nbsp;&nbsp;&nbsp;&nbsp;👥 Show Teammates [F4] – Includes allies in all ESP visualizations  
&nbsp;&nbsp;&nbsp;&nbsp;📍 Snaplines [F5] – Draws a line from your position to each visible entity  
&nbsp;&nbsp;&nbsp;&nbsp;🟦 2D Box ESP [F6] – Draws a 2D box around each visible entity  
&nbsp;&nbsp;&nbsp;&nbsp;📊 Status Bars [F7] – Displays health and armor bars next to entities  
&nbsp;&nbsp;&nbsp;&nbsp;🧾 Status Text [F8] – Shows numeric health and armor values  
&nbsp;&nbsp;&nbsp;&nbsp;🧊 3D Box ESP [F9] – Renders a 3D bounding box around entities  
&nbsp;&nbsp;&nbsp;&nbsp;🧭 Velocity Indicator [F11] – Draws a line showing the entity's movement direction  
&nbsp;&nbsp;&nbsp;&nbsp;👁️ View Angle Indicator [Home] – Draws a line showing where the entity is looking

➕ **Visual Assist**

&nbsp;&nbsp;&nbsp;&nbsp;🎯 Recoil Crosshair [Delete] – Adds a static crosshair showing where bullets would land without recoil

---

## Installation Guide

0. Temporarily disable your antivirus (yep, not ideal...no stealth yet)
1. Download the latest release (`csgo_multihack_01.dll` and `DLLInjector_csgo.multihack.exe`) from [the repo](https://github.com/jihyeo2/CSGO-multihack)
2. Launch CSGO
3. Run the executable 


**⚠️ Just a heads-up: I just realized most browsers will flag the executable as a virus when you try to download it. So you’ll probably need to disable your browser’s antivirus as well temporarily—at least until Julie Oh (hope it's not me) figures out a clever workaround. haha...haha...ha...tears**  

Double-check you see `csgo_multihack_01.dll` in the same folder the executable `DLLInjector_csgo.multihack.exe` is saved. Also, make sure CSGO is already running before you launch the cheat. It's an internal cheat, so it runs via DLL injection. Hit run, and bam--you are invincible. Almost...if you end up still losing to your friends, you can be my buddy. It's hard to suck controls that much, but some people just do. Like me:D 

---

## For devs (or anyone curious)

Honestly, I have no idea how to explain this entire cheat in one go. So instead, I wrote separate posts for a few of the parts I found interesting to talk about. They are pretty long, so I didn't want to cram them all in this one post:

- [Aimbot - Not about calcAngle...then what? Hint: Ray](/16th/posts/aimbot)
- [ESP - I made my 3D box spin...pretty cool huh. And I can't make it stop, I gotta fix my code)](/16th/posts/esp)
- [GlowObjectManager - Took me 5 days to figure it out. If you can make it faster, I will...](/16th/posts/glowobjectmanager)

I made those titles, thinking these were my videos I'm uploading on youtube. Glad I'm not a youtuber (yet??).

(If you've got questions, just shoot me a DM--even at 4am. My discord is always muted, so nw. I might not reply right away, but I won't get woken up either.)

---

## Future Improvements/Goals

Loooots to improve like:
- Fix Triggerbot functionality — currently doesn't work/very unreliable
- Improve Aimbot with recoil compensation
- Ensure Glow effect (excluding outline) clears properly when disabled
- Resolve conflicts between multiple Combat Assists (Aimbot, Triggerbot, Recoil Control)
- Add per-weapon customization for recoil control
- Allow users to configure keybinds

Also, I've still got a few ideas like Teleport, Godmode, and Speed Hack. I talked a bit about them in [Upcoming (someday:D) Multicheat Features List](/16th/posts/improvements) post. 

Oh, and I want to learn more about manual mapping so that I don't have to use the LoadLibrary function for better stealth.

---

## Conclusion

Writing this cheat and this post took forever. It was a long grind, but totally worth it. It feels great putting everything down into a human-readable form, and even better knowing it might help someone else who's into reverse engineering or game hacking. 

---