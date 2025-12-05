# Mandelbrot Zoom Sprite Demo

`newproject/` packages a self-contained ARMLite assembly effect inspired by `armocean.s`. The routine `neon_ripple.s` now performs a fixed-point Mandelbrot escape-time calculation with a handmade integer multiplier so the PixelScreen perpetually dives toward the set while the palette cycles.

## Files
- `neon_ripple.s` – ARM assembly source. Paste this directly into Peter Higginson's [ARMLite simulator](https://peterhigginson.co.uk/ARMlite/) or upload it as a `.s` file.

## Running the effect
1. Open the ARMLite simulator in a browser.
2. Clear the editor and paste the contents of `neon_ripple.s` (or use *Program → Load* and select the file).
3. Assemble the program, then press **Run**. The high-resolution PixelScreen will fill with the animated Mandelbrot zoom.

## How it works
- Uses the built-in `.Resolution`, `.PixelScreen`, and `.PixelAreaSize` symbols to keep the effect portable across the ARMLite environment.
- Maps each pixel to complex-plane coordinates in Q8 fixed-point, nudging the center point over time for a smooth zoom path.
- Implements the Mandelbrot recurrence `z = z^2 + c` entirely in ARMlite integer instructions via a reusable shift-add multiplier subroutine.
- Uses the iteration count (escape time) plus instruction-count-derived offsets to colorize the scene and accentuate the zoom.

Tweak the zoom shift, iteration limit, or palette math near the top of `neon_ripple.s` to explore other fractal variants or slower/faster dives.
