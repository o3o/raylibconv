# Raylibconv

Raylibconv converts  static binding of raylib into dynamic binding


## Generate d file

```
$ cd ~/cc/raylib
$ git checkout -b v260 2.6.0
$ dstep -o ~/d/raylibconv/raylib260.d src/raylib.h
```
## Struttura



| Name                   | Import    | Note        |
| ---                    | ---       | ---         |
| camera.h               | in raylib |             |
| config.h               | NO        | solo define |
| easings.h              | NO        |             |
| gestures.h             | in raylib |             |
| gui_textbox_extended.h |           |             |
| physac.h               |           |             |
| raudio.h               |           |             |
| raygui.h               |           |             |
| raylib.h               |           |             |
| raymath.h              |           |             |
| ricons.h               |           |             |
| rlgl.h                 |           |             |
| rmem.h                 |           |             |
| rnet.h                 |           |             |
| utils.h                |           |             |
