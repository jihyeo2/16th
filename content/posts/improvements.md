+++
date = '2025-07-29T21:13:00-04:00'
draft = false
title = "Upcoming (someday:D) Multicheat Features List"
description = 'TRUST'
tags = ["re_csgo"]
categories = ["technical"]
+++

## Teleport to Enemy & God Mode

There are actually two more features I tried adding (at least as POCs) to my first CSGO cheat, *Jerry's fart stinks*--Teleport to Enemy and God Mode.

---

## First approach

I just tried overwriting the values directly at the memory addresses. Unsurprisingly, it failed because of server-side desync.

---

## Second approach

I figured, since functions like EndScene() tun every frame and keep things synced, maybe I could call a similar function every cycle after tweaking it with a trampoline hook.

After some digging, I found `CL_Move` for teleporting (ty chatgpt) and `onTakeDamage` for God Mode (ty myself).

### CL_Move

`CL_Move` forces the engine to process all user commands and sync the player state with the server. My idea was:  
1. set my position near the enemy
2. zero out velocity on the x and y directions
3. add a slight jump in z to avoid getting stuck, then 
4. call `CL_Move` (found by pattern scanning)
to sync my new location with the server.

Short story short, it didn't work. I thought maybe the update speed or frequency was off, so I tried tying it to EndScene() to send updates every frame, but that didn't help much either. Looks like I need to spend more time undrestanding `CL_Move` and the rendering pipeline, especially tickshifting and whatnot. Or maybe I'll just look for a better function if this one doesn't pan out.

### OnTakeDamage

`OnTakeDamage`, you guessed it, is called whenever an entity takes damage. For God Mode in CS:GO (which gives you infinite health--side note: in CS2, they removed God Mode and added Buddha Mode, where your health just won't drop below 1 HP), I thought looking for a damage-related function would be a good start.  

I poked around the source code (static analysis) and set some breakpoints (dynamic analysis) on functions triggered by player damage. Didn't find much useful from breakpoints, but from the source code. I found `OnTakeDamage` inside the `CBaseEntity` and `CBasePlayer` classes.

- [CBasePlayer::OnTakeDamage](https://github.com/ValveSoftware/source-sdk-2013/blob/39f6dde8fbc238727c020d13b05ecadd31bda4c0/src/game/server/player.cpp#L1079)
- [CBaseEntity::OnTakeDamage](https://github.com/ValveSoftware/source-sdk-2013/blob/39f6dde8fbc238727c020d13b05ecadd31bda4c0/src/game/server/baseentity.cpp#L1500)

As you can see, after several checks in `CBasePlayer::OnTakeDamage` such as flags for God mode, armor, etc, the actual health reduction happens in `CBaseEntity::OnTakeDamage`. I thought hooking that function after figuring out its address through pattern scanning would work, but turns out it's never called when anyone takes damage--not me, not other players. So I still need to find the *real* function that's triggered on damage. Too bad this wasn't the one.

Then I looked at the clock and thought, well, I’ll get back to this later.

## (Added) Skin Changer
Found it from [another csgo internal hack](https://github.com/CelestialPaler/CSGO-Internal-Hack) and thought it sounds interesting...(TMI: Mannnn they have such a better looking UI than mine lol and so much more toggles/options you can modify.)