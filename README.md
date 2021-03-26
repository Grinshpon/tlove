# tlove experiment

Written using [Teal](https://github.com/teal-language/tl) and [LÖVE](https://love2d.org/).

Also using [love2d-tl](https://github.com/MikuAuahDark/love2d-tl), Teal type definitions for LÖVE.

This isn't a complete game or a complete framework, this is an attempt to make a game while also building a framework, that I can then publish separately.
For now, you can look at the structure and use whatever you'd like for your own projects.

## Sidekick

This framework-on-top-of-a-framework that I'm making, I'm calling Sidekick.
It has input action maps, a basic scene tree, and a scene stack.
The initial scene of the game is the scene returned by the `skinit.tl` file, which will be expected to be written by the user.
