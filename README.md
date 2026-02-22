![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Tiny Tapeout Project: HDSISO8

This is a prototype of a shift register that explores how to store data more densely than classic DFFs could, using the specific IHP CMOS PDK. SISO means Serial-In, Serial-Out, so it's not RAM since access is not random, but this non-randomness allows some clever tricks to optimise size, speed and power (static & dynamic). The elimination of a single-bit clock network, which is both slower and shorter, is a beneficial side effect.

A complex synchronous-to-asynchronous-to-synchronous interface ensures glitch-free operation, and apart from the small controller's overhead, allows arbitrary depth at ~2× density. Expect P&R mayhem though because I can't do the manual layout. Yet.

The scalability comes from modularity: one IO block controls as many 32-bit-deep tranches as you like, with an unconventional clocking system.

An extra LFSR is provided for extra testability, it can be used alone for something else but it allows frequency characterisation by using just a bench 'scope and a variable-frequency clock generator.

More info: see the /doc and reach me at https://hackaday.io/whygee
