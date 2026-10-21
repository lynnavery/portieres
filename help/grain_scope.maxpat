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
      820,
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
          "text": "Grain scope: each dot is a grain as actually played (after knob + attenuverter + randomizer). Dashed line = knob base. Move an _amt knob away from 0 and the dots spread around the base. Needs grain_scope.js next to this patch."
        }
      },
      {
        "box": {
          "id": "osc",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            60,
            80,
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
          "id": "b",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            200,
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
          "id": "dac",
          "maxclass": "ezdac~",
          "patching_rect": [
            200,
            200,
            45,
            45
          ],
          "numinlets": 2,
          "numoutlets": 0
        }
      },
      {
        "box": {
          "id": "v",
          "maxclass": "v8ui",
          "patching_rect": [
            20,
            260,
            760,
            260
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "filename": "grain_scope.js"
        }
      },
      {
        "box": {
          "id": "r0k",
          "maxclass": "flonum",
          "patching_rect": [
            20,
            100,
            60,
            22
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "bang"
          ],
          "minimum": 0.0,
          "maximum": 1.0
        }
      },
      {
        "box": {
          "id": "r0kc",
          "maxclass": "comment",
          "patching_rect": [
            84,
            100,
            60,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "time"
        }
      },
      {
        "box": {
          "id": "r0a",
          "maxclass": "flonum",
          "patching_rect": [
            150,
            100,
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
          "id": "r0ac",
          "maxclass": "comment",
          "patching_rect": [
            214,
            100,
            80,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "time_amt"
        }
      },
      {
        "box": {
          "id": "r0kp",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            126,
            110,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend time",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "r0ap",
          "maxclass": "newobj",
          "patching_rect": [
            150,
            126,
            130,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend time_amt",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "r0bp",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            152,
            130,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend base time",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "r1k",
          "maxclass": "flonum",
          "patching_rect": [
            300,
            100,
            60,
            22
          ],
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            "bang"
          ],
          "minimum": 0.0,
          "maximum": 1.0
        }
      },
      {
        "box": {
          "id": "r1kc",
          "maxclass": "comment",
          "patching_rect": [
            364,
            100,
            60,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "shape"
        }
      },
      {
        "box": {
          "id": "r1a",
          "maxclass": "flonum",
          "patching_rect": [
            430,
            100,
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
          "id": "r1ac",
          "maxclass": "comment",
          "patching_rect": [
            494,
            100,
            80,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "shape_amt"
        }
      },
      {
        "box": {
          "id": "r1kp",
          "maxclass": "newobj",
          "patching_rect": [
            300,
            126,
            110,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend shape",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "r1ap",
          "maxclass": "newobj",
          "patching_rect": [
            430,
            126,
            130,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend shape_amt",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "r1bp",
          "maxclass": "newobj",
          "patching_rect": [
            300,
            152,
            130,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend base shape",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "r2k",
          "maxclass": "flonum",
          "patching_rect": [
            580,
            100,
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
          "id": "r2kc",
          "maxclass": "comment",
          "patching_rect": [
            644,
            100,
            60,
            20
          ],
          "numinlets": 1,
          "numoutlets": 0,
          "text": "pitch"
        }
      },
      {
        "box": {
          "id": "r2a",
          "maxclass": "flonum",
          "patching_rect": [
            710,
            100,
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
          "id": "r2ac",
          "maxclass": "comment",
          "patching_rect": [
            774,
            100,
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
          "id": "r2kp",
          "maxclass": "newobj",
          "patching_rect": [
            580,
            126,
            110,
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
          "id": "r2ap",
          "maxclass": "newobj",
          "patching_rect": [
            710,
            126,
            130,
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
          "id": "r2bp",
          "maxclass": "newobj",
          "patching_rect": [
            580,
            152,
            130,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "prepend base pitch",
          "outlettype": [
            ""
          ]
        }
      },
      {
        "box": {
          "id": "clr",
          "maxclass": "message",
          "patching_rect": [
            700,
            100,
            50,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1,
          "text": "clear",
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
            "amp",
            0
          ],
          "destination": [
            "b",
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
            "b",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "b",
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
            "b",
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
            "b",
            3
          ],
          "destination": [
            "v",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r0k",
            0
          ],
          "destination": [
            "r0kp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r0a",
            0
          ],
          "destination": [
            "r0ap",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r0k",
            0
          ],
          "destination": [
            "r0bp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r0kp",
            0
          ],
          "destination": [
            "b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r0ap",
            0
          ],
          "destination": [
            "b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r0bp",
            0
          ],
          "destination": [
            "v",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r1k",
            0
          ],
          "destination": [
            "r1kp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r1a",
            0
          ],
          "destination": [
            "r1ap",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r1k",
            0
          ],
          "destination": [
            "r1bp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r1kp",
            0
          ],
          "destination": [
            "b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r1ap",
            0
          ],
          "destination": [
            "b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r1bp",
            0
          ],
          "destination": [
            "v",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r2k",
            0
          ],
          "destination": [
            "r2kp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r2a",
            0
          ],
          "destination": [
            "r2ap",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r2k",
            0
          ],
          "destination": [
            "r2bp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r2kp",
            0
          ],
          "destination": [
            "b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r2ap",
            0
          ],
          "destination": [
            "b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "r2bp",
            0
          ],
          "destination": [
            "v",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "clr",
            0
          ],
          "destination": [
            "v",
            0
          ]
        }
      }
    ]
  }
}