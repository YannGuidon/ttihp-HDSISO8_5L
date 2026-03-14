![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

- [Read the documentation for this project](docs/info.md)
- [This project is submitted to the Tiny Tapeout iHP26a run in March 2026](https://app.tinytapeout.com/projects/3747).

# Tiny Tapeout Project: HDSISO8

This is a prototype of a shift register that explores how to store data more densely than classic DFFs could, using the specific IHP CMOS PDK. This baseline version uses sg13g2_dlhq_1, another project https://github.com/ygdes/ttihp-HDSISO8RS implements the exact same logic using a 30% smaller pair of sg13g2_a21oi_1/sg13g2_o21ai_1 for comparison.

Relevant stats: this one tile holds 672× DLHQ latches, offering a delay of 502 cycles at 87% surface fill with working speed expected to exceed 100MHz.

SISO means Serial-In, Serial-Out, so it's not RAM since access is not random, but this non-randomness allows some clever tricks that optimise size, speed and power (static & dynamic) by eliminating the single general clock network. This implementation expects half the clock frequency and 1/4th clock load per cycle, for an effective 8× power reduction.

A complex synchronous-to-asynchronous-to-synchronous interface is needed to operate glitch-free, and apart from the small controller's overhead, this allows almost arbitrary depth at ~1.5 to 2× the density of DFF. Expect P&R mayhem though because I can't do the manual layout. Yet. Actually it's messy.

The scalability comes from modularity: one IO block controls as many tranches as you like, which can be chained. Tranches come in sizes of 16, 64, 256 cells, each holding 12, 48 and 192 effective data bits. Here, 502 bits of depth are made with 672 latches, 32 latches in the controller add 20 cycles and the rest is 2×(256+64) in chainable tranches.

An extra LFSR is provided for extra testability, it can be used alone for something else but it allows frequency characterisation by using just a bench 'scope and a variable-frequency clock generator.

More info: see the /doc and reach me at https://hackaday.io/whygee
