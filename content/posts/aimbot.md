+++
date = '2025-05-30T12:07:00-04:00'
draft = false
title = "Aimbot was so easy to make guys"
description = "I was truly worried if I'd still lose to my friend even with an aimbot."
tags = ["re_csgo"]
categories = ["technical"]
[cover]
image = "https://dl.dropboxusercontent.com/scl/fi/pnbaw3or25g05gbxmo7k2/aimbot_demo3_compressed.gif?rlkey=bipkmzt7dl2mmq4ijlbuhmm0x&e=1&st=3e6l9mf8&dl=0"
hiddenInList = true
+++

> - **This post is more about how I used the `TraceRay` function for my aimbot, not so much about how I calculated angles.**
> - {{< collapse summary="**TLDR**" >}}

I used `TraceRay` from `IEngineTrace` to check if enemies were visible before activating my aimbot. In detail, I found the interface via `CreateInterface("EngineTraceClient004")`, set up a ray from my eye to their head, and checked the trace result.

{{</ collapse >}}

---

## Aimbot

Simple, it aims for you!

For mine, I just grab the closest enemy and snap my view angle to their head.

```cpp
void RunAimbot()
{
	Player* closestEnemy = GetClosestEnemy();

	if (closestEnemy)
		hack->localPlayer->AimAt(closestEnemy->GetBonePos(8)); // 8: head
}
```

## Trigonemtry (briefly)

Just in case you are curious--nothing fancy, just high school trig.

```cpp
Vector3 deltaVec = { target.x - myPos->x, target.y - myPos->y, target.z - myPos->z };
float deltaVecLength = sqrt(deltaVec.x * deltaVec.x + deltaVec.y * deltaVec.y + deltaVec.z * deltaVec.z);

float pitch = -asin(deltaVec.z / deltaVecLength) * (180 / PI);
float yaw = atan2(deltaVec.y, deltaVec.x) * (180 / PI);
```

I used `asin` for pitch and `atan2` for yaw based on the traingles formed between me and the enemy. Initially, my pitch was off (it was pointing the wrong way), so I reverted it after trial and error.

After calculating the view angles, I smoothed them before applying to avoid snapping.

## TraceRay

To check if there's a clear line of sight to the enemy, I used `TraceRay` to fire a ray from my eye position to the enemy's head.

If you take a peek at Valve's [IEngineTrace.h](https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/public/engine/IEngineTrace.h#L148), `TraceRay` is part of the `IEngineTrace` abstract class. 

```cpp
//-----------------------------------------------------------------------------
// Interface the engine exposes to the game DLL
//-----------------------------------------------------------------------------
#define INTERFACEVERSION_ENGINETRACE_SERVER	"EngineTraceServer003"
#define INTERFACEVERSION_ENGINETRACE_CLIENT	"EngineTraceClient003"
abstract_class IEngineTrace
{
public:
	// Returns the contents mask + entity at a particular world-space position
	virtual int		GetPointContents( const Vector &vecAbsPosition, IHandleEntity** ppEntity = NULL ) = 0;
	
	// Get the point contents, but only test the specific entity. This works
	// on static props and brush models.
	//
	// If the entity isn't a static prop or a brush model, it returns CONTENTS_EMPTY and sets
	// bFailed to true if bFailed is non-null.
	virtual int		GetPointContents_Collideable( ICollideable *pCollide, const Vector &vecAbsPosition ) = 0;

	// Traces a ray against a particular entity
	virtual void	ClipRayToEntity( const Ray_t &ray, unsigned int fMask, IHandleEntity *pEnt, trace_t *pTrace ) = 0;

	// Traces a ray against a particular entity
	virtual void	ClipRayToCollideable( const Ray_t &ray, unsigned int fMask, ICollideable *pCollide, trace_t *pTrace ) = 0;

	// A version that simply accepts a ray (can work as a traceline or tracehull)
	virtual void	TraceRay( const Ray_t &ray, unsigned int fMask, ITraceFilter *pTraceFilter, trace_t *pTrace ) = 0;
```

So no need to reimplement anything, just grab the interface and call the method! Work is already done by the game.

So how do we get this interface?

### CreateInterface

If you open engine.dll in IDA pro and check the *Exports* tab, you can easily find `CreateInterface`.

![createInterface_IDA](/16th/images/createinterface.png)

With this in mind, I define a function pointer for `CreateInterface`, grab its address, and call it with the name "EngineTraceClient004" to get the engine trace interface I need. 

```cpp
typedef void* (__cdecl* tCreateInterface)(const char* name, int* pReturnCode);
```

```cpp
tCreateInterface CreateInterface = (tCreateInterface)GetProcAddress((HMODULE)engine, "CreateInterface");
EngineTrace = (IEngineTrace*)GetInterface(CreateInterface, "EngineTraceClient004");
```

You might notice Valve's source code uses "EngineTraceClient003". I first used it, but it didn't work. Turned out that because the source code is from 2013, it shows you an outdated interface name as Valve continuously updates version name of the interface when they update the internal layout over time. So you should just use the latest one that works, "EngineTraceClient004" in my case.

## Drawing a TraceRay

To use `IEngineTrace`, we first need to define a few classes and member functions used in the arguments and return value of `TraceRay`. I pulled these directly from the source code and organized them into `Objects/Traceobjects.h`.

### Ray_t

Once the interface was set up, everything else was simple. I just searched how to draw a traceline with `IEngineTrace` and followed the steps.

```cpp
CGameTrace trace;
Ray_t ray;
CTraceFilter tracefilter;
tracefilter.pSkip = (void*)this->GetEnt();

ray.Init(eyepos, targetheadpos);
hack->EngineTrace->TraceRay(ray, MASK_SHOT | CONTENTS_GRATE, &tracefilter, &trace);
```

Then I checked whether the ray’s fraction (i.e. how far it traveled before hitting something) was close to 1 and whether the hit entity matched my target player.

```cpp
return (trace.fraction > 0.97f && (Ent*)player->GetEnt() == (Ent*)trace.hit_entity);
```

## Finishing thoughts

A couple of years ago, I remember getting stuck on the aimbot for quite a while. So, I'm honestly pretty surprised how straightforward it was this time around with all the solid guides out there now.

## Credits

Hats off to GuidedHacking! Especially their [traceline tutorial](https://guidedhacking.com/threads/csgo-how-to-find-traceray-call-traceline-tutorial.14696/), super helpful for understanding how to work with `TraceRay`!