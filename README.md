# Mandelbrot Zoom Sprite Demo

`newproject/` packages a self-contained ARMLite assembly effect inspired by `armocean.s`. The routine `neon_ripple.s` now performs a fixed-point Mandelbrot escape-time calculation with a handmade integer multiplier so the PixelScreen perpetually dives toward the set while the palette cycles.

## Files
- `fractal.s` – ARM assembly source. Paste this directly into Peter Higginson's [ARMLite simulator](https://peterhigginson.co.uk/ARMlite/) or upload it as a `.s` file.

## Running the effect
1. Open the ARMLite simulator in a browser.
2. Clear the editor and paste the contents of `neon_ripple.s` (or use *Program → Load* and select the file).
3. Assemble the program, then press **Run**. The high-resolution PixelScreen will fill with the animated Mandelbrot zoom.