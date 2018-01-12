# DPI Calculations/Ranges

Special thanks to [David Jordan](https://github.com/djordan2) for helping determine these ranges and putting up with my constant pinging to talk through this.

These ranges approximate what criteria we use at System76 to determine ideal display sizes, resolutions, densities, and scaling factors.

These ranges also assume only integer scaling for the best experience; [half pixels are a lie](https://medium.com/elementaryos/what-is-hidpi-and-why-does-it-matter-b024eabea20d) and if you can, you should always use integer scaling for the best experience.

_NOTE: GNOME currently switches to @2x HiDPI at 192+ no matter what._

| Value         | Laptop               | Desktop              |
|---------------|----------------------|----------------------|
| Inferred size | < 18"                | 18+"                 |
| Ideal anchor  | 140 DPI              | 120 DPI              |
| Ideal range   | ±20 from anchor      | ±30 from anchor      |
| Unclear range | ±10 outside of ideal | ±20 outside of ideal |

## Laptops

| DPI     | Resulting Range                |
|---------|--------------------------------|
| < 110   | Probably too low               |
| 110–120 | Unclear (potentially too low)  |
| 120–160 | Ideal loDPI                    |
| 160–170 | Unclear (potentially too high) |
| 170–192 | Probably too high for loDPI    |
|         |                                |
| < 220   | Probably too low               |
| 220–240 | Unclear (potentially too low)  |
| 240–320 | Ideal HiDPI                    |
| 320–340 | Unclear (potentially too high) |
| > 340   | Probably too high              |


## Desktops


| DPI     | Resulting Range                |
|---------|--------------------------------|
| < 70    | Probably too low               |
| 70–90   | Unclear (potentially too low)  |
| 90–150  | Ideal loDPI                    |
| 150–170 | Unclear (potentially too high) |
| 170–192 | Probably too high for loDPI    |
|         |                                |
| < 140   | Too low for HiDPI              |
| 140–180 | Unclear (probably too low)     |
| 180–300 | Ideal HiDPI                    |
| 300–340 | Unclear (potentially too high) |
| > 340   | Probably too high              |
