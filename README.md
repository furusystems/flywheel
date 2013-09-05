flywheel
========
Haxe3/OpenFL input, time, state machine, audio. Game dev boilerplate native extension.
Note: Developed on Haxe3 nightlies and OpenFL github repos. 

Immediate goals:
- Stabilize audio through formalization 
- Minimal init
- Macro preprocessing of assets to validate per platform
- No rendering stuff. Too implementation specific.
- Enter/update/render/exit state pattern. Should cover most bases.
- Keyboard, mouse, touch input management including some gestures
- Stable cross plat local storage

Future goals:
- Cross plat video playback and video texture support through OpenGLView
- General purpose utilities such as OpenGL setup assistance, typical collision tests (AABB/OBB/Ray)
