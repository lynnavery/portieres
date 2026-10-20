{
  "patcher": {
    "fileversion": 1,
    "appversion": {
      "major": 9,
      "minor": 0,
      "revision": 0,
      "architecture": "x64",
      "modernui": 1
    },
    "classnamespace": "box",
    "rect": [
      60,
      60,
      920,
      560
    ],
    "openinpresentation": 0,
    "gridsize": [
      15,
      15
    ],
    "boxes": [
      {
        "box": {
          "id": "c0",
          "maxclass": "comment",
          "patching_rect": [
            20,
            10,
            860,
            34
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "Attenuverter visualiser. Lane A: no signal in inlet 5 -> internal random mode (orange band = base +/- |amt|*24). Lane B: pitch CV connected -> CV mode (blue band = base .. base + amt*cv). White dots = real grains from outlet 3. Needs attenuverter_viz.js next to this patch."
        }
      },
      {
        "box": {
          "id": "osc",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            60,
            70,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "cycle~ 220",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "amp",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            88,
            50,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "*~ 0.1",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "dac",
          "maxclass": "ezdac~",
          "patching_rect": [
            20,
            470,
            45,
            45
          ],
          "numinlets": 2,
          "numoutlets": 0
        }
      },
      {
        "box": {
          "id": "at",
          "maxclass": "comment",
          "patching_rect": [
            20,
            130,
            200,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "Lane A: no CV (random)"
        }
      },
      {
        "box": {
          "id": "apf",
          "maxclass": "flonum",
          "patching_rect": [
            20,
            154,
            60,
            22
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "bang"
          ],
          "minimum": -24.0,
          "maximum": 24.0
        }
      },
      {
        "box": {
          "id": "apc",
          "maxclass": "comment",
          "patching_rect": [
            84,
            154,
            40,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "pitch"
        }
      },
      {
        "box": {
          "id": "aaf",
          "maxclass": "flonum",
          "patching_rect": [
            20,
            180,
            60,
            22
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "bang"
          ],
          "minimum": -1.0,
          "maximum": 1.0
        }
      },
      {
        "box": {
          "id": "aac",
          "maxclass": "comment",
          "patching_rect": [
            84,
            180,
            80,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "pitch_amt"
        }
      },
      {
        "box": {
          "id": "app",
          "maxclass": "newobj",
          "patching_rect": [
            130,
            154,
            80,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend pitch",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "aap",
          "maxclass": "newobj",
          "patching_rect": [
            130,
            180,
            100,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend pitch_amt",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "abs",
          "maxclass": "newobj",
          "patching_rect": [
            240,
            154,
            80,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend base",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "aam",
          "maxclass": "newobj",
          "patching_rect": [
            240,
            180,
            80,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend amt",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "ab",
          "maxclass": "newobj",
          "patching_rect": [
            330,
            154,
            140,
            22
          ],
          "numinlets": 9,
          "numoutlets": 4,
          "text": "portieres~",
          "outlettype": [
            "signal",
            "signal",
            "signal",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "av",
          "maxclass": "v8ui",
          "patching_rect": [
            480,
            134,
            400,
            70
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "filename": "attenuverter_viz.js"
        }
      },
      {
        "box": {
          "id": "acm",
          "maxclass": "message",
          "patching_rect": [
            330,
            182,
            80,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "cvmode 0",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "bt",
          "maxclass": "comment",
          "patching_rect": [
            20,
            270,
            200,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "Lane B: CV connected"
        }
      },
      {
        "box": {
          "id": "bpf",
          "maxclass": "flonum",
          "patching_rect": [
            20,
            294,
            60,
            22
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "bang"
          ],
          "minimum": -24.0,
          "maximum": 24.0
        }
      },
      {
        "box": {
          "id": "bpc",
          "maxclass": "comment",
          "patching_rect": [
            84,
            294,
            40,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "pitch"
        }
      },
      {
        "box": {
          "id": "baf",
          "maxclass": "flonum",
          "patching_rect": [
            20,
            320,
            60,
            22
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "bang"
          ],
          "minimum": -1.0,
          "maximum": 1.0
        }
      },
      {
        "box": {
          "id": "bac",
          "maxclass": "comment",
          "patching_rect": [
            84,
            320,
            80,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "pitch_amt"
        }
      },
      {
        "box": {
          "id": "bpp",
          "maxclass": "newobj",
          "patching_rect": [
            130,
            294,
            80,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend pitch",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "bap",
          "maxclass": "newobj",
          "patching_rect": [
            130,
            320,
            100,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend pitch_amt",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "bbs",
          "maxclass": "newobj",
          "patching_rect": [
            240,
            294,
            80,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend base",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "bam",
          "maxclass": "newobj",
          "patching_rect": [
            240,
            320,
            80,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend amt",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "bb",
          "maxclass": "newobj",
          "patching_rect": [
            330,
            294,
            140,
            22
          ],
          "numinlets": 9,
          "numoutlets": 4,
          "text": "portieres~",
          "outlettype": [
            "signal",
            "signal",
            "signal",
            ""
          ]
        }
      },
      {
        "box": {
          "id": "bv",
          "maxclass": "v8ui",
          "patching_rect": [
            480,
            274,
            400,
            70
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "filename": "attenuverter_viz.js"
        }
      },
      {
        "box": {
          "id": "bcm",
          "maxclass": "message",
          "patching_rect": [
            330,
            322,
            80,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "cvmode 1",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "lfo",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            395,
            80,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "cycle~ 0.15",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "lfs",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            423,
            50,
            22
          ],
          "numinlets": 2,
          "numoutlets": 1,
          "text": "*~ 12",
          "outlettype": [
            "signal"
          ]
        }
      },
      {
        "box": {
          "id": "lb",
          "maxclass": "newobj",
          "patching_rect": [
            500,
            395,
            60,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "loadbang",
          "outlettype": [
            "bang"
          ]
        }
      },
      {
        "box": {
          "id": "rg",
          "maxclass": "message",
          "patching_rect": [
            500,
            423,
            160,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "range 24, cvmax 12",
          "outlettype": [
            ""
          ]
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "osc",
            0
          ],
          "destination": [
            "amp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "apf",
            0
          ],
          "destination": [
            "app",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "apf",
            0
          ],
          "destination": [
            "abs",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "aaf",
            0
          ],
          "destination": [
            "aap",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "aaf",
            0
          ],
          "destination": [
            "aam",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "app",
            0
          ],
          "destination": [
            "ab",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "aap",
            0
          ],
          "destination": [
            "ab",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "abs",
            0
          ],
          "destination": [
            "av",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "aam",
            0
          ],
          "destination": [
            "av",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "amp",
            0
          ],
          "destination": [
            "ab",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "amp",
            0
          ],
          "destination": [
            "ab",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "ab",
            3
          ],
          "destination": [
            "av",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "acm",
            0
          ],
          "destination": [
            "av",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "ab",
            0
          ],
          "destination": [
            "dac",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "ab",
            1
          ],
          "destination": [
            "dac",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bpf",
            0
          ],
          "destination": [
            "bpp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bpf",
            0
          ],
          "destination": [
            "bbs",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "baf",
            0
          ],
          "destination": [
            "bap",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "baf",
            0
          ],
          "destination": [
            "bam",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bpp",
            0
          ],
          "destination": [
            "bb",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bap",
            0
          ],
          "destination": [
            "bb",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bbs",
            0
          ],
          "destination": [
            "bv",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bam",
            0
          ],
          "destination": [
            "bv",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "amp",
            0
          ],
          "destination": [
            "bb",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "amp",
            0
          ],
          "destination": [
            "bb",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bb",
            3
          ],
          "destination": [
            "bv",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bcm",
            0
          ],
          "destination": [
            "bv",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bb",
            0
          ],
          "destination": [
            "dac",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bb",
            1
          ],
          "destination": [
            "dac",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo",
            0
          ],
          "destination": [
            "lfs",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfs",
            0
          ],
          "destination": [
            "bb",
            5
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lb",
            0
          ],
          "destination": [
            "rg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rg",
            0
          ],
          "destination": [
            "av",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rg",
            0
          ],
          "destination": [
            "bv",
            0
          ]
        }
      }
    ]
  }
}