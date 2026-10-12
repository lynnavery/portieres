{
    "patcher": {
        "fileversion": 1,
        "appversion": {
            "major": 9,
            "minor": 2,
            "revision": 0,
            "architecture": "x64",
            "modernui": 1
        },
        "classnamespace": "box",
        "rect": [ 141.0, 93.0, 900.0, 773.0 ],
        "boxes": [
            {
                "box": {
                    "id": "obj-172",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 339.0, 448.0, 62.0, 22.0 ],
                    "text": "phasor~ 1"
                }
            },
            {
                "box": {
                    "id": "obj-150",
                    "maxclass": "live.dial",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 540.0, 94.0, 110.0, 48.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_initial": [ 5 ],
                            "parameter_initial_enable": 1,
                            "parameter_longname": "live.dial[8]",
                            "parameter_mmax": 20.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "gain",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "varname": "live.dial[8]"
                }
            },
            {
                "box": {
                    "floatoutput": 1,
                    "id": "obj-149",
                    "maxclass": "dial",
                    "min": -1.0,
                    "mode": 6,
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 347.0, 352.0, 30.0, 30.0 ],
                    "size": 2.0
                }
            },
            {
                "box": {
                    "floatoutput": 1,
                    "id": "obj-148",
                    "maxclass": "dial",
                    "min": -1.0,
                    "mode": 6,
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 279.0, 352.0, 30.0, 30.0 ],
                    "size": 2.0
                }
            },
            {
                "box": {
                    "floatoutput": 1,
                    "id": "obj-147",
                    "maxclass": "dial",
                    "min": -1.0,
                    "mode": 6,
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 222.0, 352.0, 30.0, 30.0 ],
                    "size": 2.0
                }
            },
            {
                "box": {
                    "floatoutput": 1,
                    "id": "obj-146",
                    "maxclass": "dial",
                    "min": -1.0,
                    "mode": 6,
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 159.0, 352.0, 30.0, 30.0 ],
                    "size": 2.0
                }
            },
            {
                "box": {
                    "id": "obj-145",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 569.0, 514.0, 86.0, 20.0 ],
                    "text": "freeze (gate)"
                }
            },
            {
                "box": {
                    "id": "obj-143",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 494.0, 514.0, 73.0, 20.0 ],
                    "text": "seed (gate)"
                }
            },
            {
                "box": {
                    "id": "obj-141",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 436.0, 514.0, 48.0, 20.0 ],
                    "text": "density"
                }
            },
            {
                "box": {
                    "id": "obj-138",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 339.0, 514.0, 95.0, 20.0 ],
                    "text": "pitch (semitone)"
                }
            },
            {
                "box": {
                    "id": "obj-136",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 292.0, 514.0, 41.0, 20.0 ],
                    "text": "shape"
                }
            },
            {
                "box": {
                    "id": "obj-134",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 224.5, 514.0, 32.0, 20.0 ],
                    "text": "size"
                }
            },
            {
                "box": {
                    "id": "obj-132",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 153.0, 514.0, 33.0, 20.0 ],
                    "text": "time"
                }
            },
            {
                "box": {
                    "fontsize": 10.0,
                    "id": "obj-122",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 808.0, 130.0, 177.0, 18.0 ],
                    "text": "sets the right outlet  to output cv gate"
                }
            },
            {
                "box": {
                    "attr": "gateout",
                    "id": "obj-118",
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 650.0, 128.0, 150.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-116",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 222.0, 326.0, 114.0, 20.0 ],
                    "text": "Attenurandomizers"
                }
            },
            {
                "box": {
                    "id": "obj-114",
                    "maxclass": "live.dial",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 300.0, 19.0, 67.0, 48.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.dial[7]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "dry/wet",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "varname": "live.dial[7]"
                }
            },
            {
                "box": {
                    "id": "obj-113",
                    "maxclass": "live.dial",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 541.0, 19.0, 99.0, 48.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.dial[6]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "shape",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "varname": "live.dial[6]"
                }
            },
            {
                "box": {
                    "id": "obj-112",
                    "maxclass": "live.dial",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 421.0, 173.0, 114.0, 48.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_initial": [ 0.0 ],
                            "parameter_initial_enable": 1,
                            "parameter_longname": "live.dial[5]",
                            "parameter_mmax": 24.0,
                            "parameter_mmin": -24.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "pitch (semitones)",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "varname": "live.dial[5]"
                }
            },
            {
                "box": {
                    "id": "obj-111",
                    "maxclass": "live.dial",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 421.0, 95.0, 110.0, 48.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.dial[4]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "feedback",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "varname": "live.dial[4]"
                }
            },
            {
                "box": {
                    "id": "obj-110",
                    "maxclass": "live.dial",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 300.0, 171.0, 115.0, 48.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.dial[3]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "density",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "varname": "live.dial[3]"
                }
            },
            {
                "box": {
                    "id": "obj-109",
                    "maxclass": "live.dial",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 535.0, 172.0, 110.0, 48.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.dial[2]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "reverb",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "varname": "live.dial[2]"
                }
            },
            {
                "box": {
                    "id": "obj-108",
                    "maxclass": "live.dial",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 412.0, 19.0, 110.0, 48.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.dial[1]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "size",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "varname": "live.dial[1]"
                }
            },
            {
                "box": {
                    "id": "obj-107",
                    "maxclass": "live.dial",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 303.0, 92.0, 110.0, 48.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "position/delay time",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "position/delay time",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "varname": "live.dial"
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "fontsize": 16.0,
                    "id": "obj-100",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 18.072289156626507, 69.03614457831326, 271.0, 42.0 ],
                    "text": "Original code by Émilie Gillet. Code is under MIT License"
                }
            },
            {
                "box": {
                    "id": "obj-95",
                    "maxclass": "textbutton",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "", "", "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 15.355421686746979, 107.0, 197.0, 24.0 ],
                    "text": "View Beads Manual in Browser"
                }
            },
            {
                "box": {
                    "id": "obj-85",
                    "leftarrow": 0,
                    "maxclass": "live.arrows",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 587.0, 492.0, 17.5, 15.0 ],
                    "rightarrow": 0,
                    "uparrow": 0
                }
            },
            {
                "box": {
                    "id": "obj-84",
                    "leftarrow": 0,
                    "maxclass": "live.arrows",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 515.0, 492.0, 17.5, 15.0 ],
                    "rightarrow": 0,
                    "uparrow": 0
                }
            },
            {
                "box": {
                    "id": "obj-83",
                    "leftarrow": 0,
                    "maxclass": "live.arrows",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 444.0, 492.0, 17.5, 15.0 ],
                    "rightarrow": 0,
                    "uparrow": 0
                }
            },
            {
                "box": {
                    "id": "obj-82",
                    "leftarrow": 0,
                    "maxclass": "live.arrows",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 372.0, 492.0, 17.5, 15.0 ],
                    "rightarrow": 0,
                    "uparrow": 0
                }
            },
            {
                "box": {
                    "id": "obj-81",
                    "leftarrow": 0,
                    "maxclass": "live.arrows",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 304.0, 492.0, 17.5, 15.0 ],
                    "rightarrow": 0,
                    "uparrow": 0
                }
            },
            {
                "box": {
                    "id": "obj-80",
                    "leftarrow": 0,
                    "maxclass": "live.arrows",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 228.0, 492.0, 17.5, 15.0 ],
                    "rightarrow": 0,
                    "uparrow": 0
                }
            },
            {
                "box": {
                    "id": "obj-79",
                    "leftarrow": 0,
                    "maxclass": "live.arrows",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 157.0, 492.0, 17.5, 15.0 ],
                    "rightarrow": 0,
                    "uparrow": 0
                }
            },
            {
                "box": {
                    "attr": "seed",
                    "id": "obj-78",
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 650.0, 43.0, 150.0, 22.0 ]
                }
            },
            {
                "box": {
                    "attr": "media",
                    "id": "obj-74",
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 650.0, 18.0, 200.0, 22.0 ]
                }
            },
            {
                "box": {
                    "attr": "freeze",
                    "id": "obj-72",
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 650.0, 100.0, 150.0, 22.0 ]
                }
            },
            {
                "box": {
                    "attr": "mono",
                    "id": "obj-70",
                    "maxclass": "attrui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 650.0, 72.0, 150.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-69",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 13.0, 210.36746987951807, 41.0, 22.0 ],
                    "text": "sig~ 1"
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "fontname": "Arial",
                    "fontsize": 16.0,
                    "id": "obj-1",
                    "linecount": 3,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 16.867469879518072, 10.0, 288.0, 60.0 ],
                    "text": "portieres~ \nport of Mutable Instruments Beads \n(granular processor / delay / reverb)"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-2",
                    "linecount": 4,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 171.0, 573.0, 248.0, 60.0 ],
                    "text": "Code is ported as an audio-rate wrapper around the original DSP. Runs internally at the media's codec rate (24/32/48 kHz) and resamples to the host rate."
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.988235294117647, 0.568627450980392, 0.0, 1.0 ],
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-3",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 13.0, 157.36746987951807, 193.97590361445785, 20.0 ],
                    "text": "Source (turn audio on)"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-4",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 13.0, 181.36746987951807, 200.0, 22.0 ],
                    "text": "buffer~ drumloop drumloop.aif"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-6",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [ "signal", "signal", "signal" ],
                    "patching_rect": [ 13.0, 245.36746987951807, 164.0, 22.0 ],
                    "text": "groove~ drumloop 2 @loop 1"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-7",
                    "maxclass": "newobj",
                    "numinlets": 9,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "signal" ],
                    "patching_rect": [ 20.5, 536.0, 584.0, 22.0 ],
                    "text": "portieres~"
                }
            },
            {
                "box": {
                    "id": "obj-8",
                    "maxclass": "ezdac~",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 15.0, 681.0, 45.0, 45.0 ]
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 10.0,
                    "id": "obj-9",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 808.0, 73.0, 252.0, 18.0 ],
                    "text": "force mono; right inlet unpatched = mono delay buffer."
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 10.0,
                    "id": "obj-13",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 864.0, 20.0, 338.0, 18.0 ],
                    "text": "0 dirty tape (24k, mu-law)  1 clean tape  2 vintage digital (32k)  3 digital"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 10.0,
                    "id": "obj-16",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 808.0, 45.0, 209.0, 18.0 ],
                    "text": "0/1/2 - off / on (trigger) / locked (free-run)"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-28",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 303.0, 145.0, 112.5, 22.0 ],
                    "text": "prepend time"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 8.0,
                    "id": "obj-30",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 159.0, 383.0, 61.0, 26.0 ],
                    "text": "prepend time_amt"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 8.0,
                    "id": "obj-31",
                    "linecount": 3,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 364.0, 27.0, 43.5, 33.0 ],
                    "text": ">0.99 =\n delay mode"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-33",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 418.0, 67.0, 110.0, 22.0 ],
                    "text": "prepend size"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 8.0,
                    "id": "obj-35",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 222.0, 383.0, 55.0, 26.0 ],
                    "text": "prepend size_amt"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-38",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 535.0, 67.0, 110.0, 22.0 ],
                    "text": "prepend shape"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 8.0,
                    "id": "obj-40",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 279.0, 383.0, 60.0, 26.0 ],
                    "text": "prepend shape_amt"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 8.0,
                    "id": "obj-41",
                    "linecount": 3,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 300.0, 194.0, 45.0, 33.0 ],
                    "text": "(0.48-0.52 = no grains)"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-43",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 300.0, 223.0, 110.0, 22.0 ],
                    "text": "prepend density"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-46",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 421.0, 223.0, 110.0, 22.0 ],
                    "text": "prepend pitch"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 8.0,
                    "id": "obj-48",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 347.0, 383.0, 53.0, 26.0 ],
                    "text": "prepend pitch_amt"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-51",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 421.0, 147.0, 110.0, 22.0 ],
                    "text": "prepend feedback"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-54",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 300.0, 67.0, 110.0, 22.0 ],
                    "text": "prepend drywet"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-57",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 535.0, 223.0, 110.0, 22.0 ],
                    "text": "prepend reverb"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-60",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 540.0, 147.0, 105.0, 22.0 ],
                    "text": "prepend gain"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-62",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 444.0, 317.0, 235.5, 20.0 ],
                    "text": "You can send patch settings as messages"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-63",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 444.0, 344.0, 365.0, 22.0 ],
                    "text": "size 0.9, density 0.6, shape 0.5, drywet 1., feedback 0.9, reverb 0.5"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-64",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 459.0, 372.0, 326.0, 22.0 ],
                    "text": "size 1, time 0.1, pitch 12, feedback 0.9, drywet 0.6, reverb 0"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-65",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 479.0, 399.0, 341.0, 22.0 ],
                    "text": "size 0.15, density 0.9, pitch 7, drywet 1., feedback 0., reverb 0."
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-66",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 137.0, 207.0, 140.0, 33.0 ],
                    "text": "clears buffers and re-syncs the resamplers"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-67",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 85.0, 210.36746987951807, 50.0, 22.0 ],
                    "text": "reset"
                }
            },
            {
                "box": {
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-68",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 228.5, 449.0, 106.0, 20.0 ],
                    "text": "CV inlets (signal): "
                }
            },
            {
                "box": {
                    "fontsize": 8.0,
                    "hidden": 1,
                    "id": "obj-89",
                    "linecount": 4,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 10.5, 18.0, 169.0, 44.0 ],
                    "text": ";\rmax launchbrowser https://pichenettes.github.io/mutable-instruments-documentation/modules/beads/manual/"
                }
            },
            {
                "box": {
                    "alpha": 0.2,
                    "autofit": 1,
                    "data": [ 41723, "png", "IBkSG0fBZn....PCIgDQRA..CvO..Pf3HX....vAZitm....DLmPIQEBHf.B7g.YHB..f.PRDEDU3wI6cmrqbarsnnMWFuVm++u0a20qg.2hhIKyjEyhw.Pv1RxRLXTNYT8y+2+2+2uuF4+2+u+euhne+82E+094metwmjyyZooO0O+7y+7maje2r2zejSCc1QJ+JODdF6odp5m40R4uCiEnJ4sm43klNNo490ingm4n97Q8c1wsnr784+um9AXupXghgzzYVA5J9HB.P9r29CpTfgcyZ4axSm2b0Kp1GHANahuH2dKfeM3cuNiJPi+vAiy6hbkyi7roLI.v5x3rVywHeD3S7eO8C.miwczmgk80Qd1hb5..3os0GQOxS.vdb0iCHCSrPze9ntxd6GrvR5OK6A7JXq8R1m9mI.vdnOC5N0Af6WF9PaY0zXKSyd3u59l.+yvL5+opXZBHtNZ6vZiJVF2eXWFLoYeC.Vi.9ChOoC6rOPlqX0M.vmvGbM2ll+M7e2kf96fybLCKc1GA7NqF47yd3O.94meNbA+pTQYozwm7NAfOwYLPFe7R35cFiKXbvKFmAbeTe64r3L7a1WueG4Z5q5cVU8zGPLnet7aqSmdyhasr2wmNWdt56v8Zt5gZO9dLtsRyve.sUEggY+tBUXz4ads2xeUnbJrG+96u+ueDA6otm5m4WGyCWKMu13iF94636rHKJsYx51S7G6IFFtdiaq6me9Y9Y3WChOu4lUhg+6pLaEZfO+FWdrJkKoOtx1fhR8A0MMVlpR9Zc3LUH9lKdjo+6y86kXvL7GXSqbM2OODAiOfrhzLbBKoSkQ0mQuxugLYtCbS0Wisw8on+kb3sY3WFWLIegHRmxvxhzrUs09buChT9AfwP.2EWKe.eDcT2GBVL2TWs9GDwak9TOkHZoxsUo7p5jDEB3G3iMcO7S+jwaTCkU+WcYluqdZr5oOpqJ1l7VootztKwvaA7Os.ZjJL5KkQlrT40JUVc7d2mZRdKQ2ZevQCpFhqomOUiGSQlq2t29Myd5j3ZZYvzbn8smuTVUU4zVG4.ogJRY5448xyxfog3a5GsS8V3bUpkzuuTFYhxq.bNzVJU1d9vgYrNv3.8y3yOjEoYF9A.f8vJohtIqk2EnOb8bs7A.P5MW.OQ9bIBNaV4f7DTtK194meLC+YUEl8hp23P0SezCGobb1aSh5SYTxFkYICTNMV94me9e+30qhsG9IeFGLg8wUs3K91OxuAf0r2qxW8mjCiyGcvKFWB3OopREosVBlUIcNmJm1fHaOC17L+6J5xvyHPdMs818z9aWFKXUYRehEA7m.pvjeU7jncHcnQcXdpWDOxSpo0BfTd9y5L93pUa7SCpV5YpplukQB3mGyd+BuYtghwO6YNcrlplt3ur7KyM4M+U16Sg2YuCGWmcdSVp+pOShFA7C.syctr9AdNYIHwpo6su1kxba0WZWdODcuEveTuBaVq.UTdFAnhp5.2txf90uTLIeomxbP+GocprlFOhLsLwMK+7TlV1KUyvuJF0hYXC3ocEsCoup3JyA9AYgw14cvqW5KLRRU.+.PLk4.oNyf9y56.xu4JCW8xicInJ6I72k49bpF4Cw2aA7aVWAft4nCXIpa+Ml2vXapZ9zRiaKSK+YVm7PfO0ryvuFU3N3CKAjU5mLd1JOop4Yc3Fug7vX6fX4me9wR5mmiUSB...v4Y5G3U.+DZlQB.3Hbi9zG6chCj2C2CqlnX5+d5G.XIZv..1qe+8WqZLnQTeG1GA7SXYva.vYvGPtuj2WWxag8Q.+DdB5G.9F9.x00O+7y+6Gy8qAbu5XasQOM+1d32UMD2knW4..fbXtwT3ZID3NDs1Xl1dnY3G.VUz5HCfw1ZBDLACb25Z+lyktU+644T5G3i4zQt2j2lONAkAtRtxk+qt0VqaHkX5me9Q.+vUaqN9pdCgBvH+VpLrkKa7s1xbdf7ubaOAXU47XAW1SYrLc0GOjO1SbIfe3BsmF9xZG.ZTuGjOSUjw1Y2qJm1NKYsu1LRfe+0z2Ci+uqZ4wpltNh4J+emuWFWG72e+88.9GdXTQE.frPPFPOjk.J6X6QYIu4JrmyRj6Nn+AKdn8szUbB..DQiG2xR+6U0vUOnqfPhfNTmaMpCRj3T5O3Vauypwj5PdI.miwSXQWl7hkNqFz2BOoqntWGpOS9r21Zep1jEveBrz9.QidjEFzIYjYKkLP4ShryZrpF2K74bn8kXY+.nw9srOxb4T5IsMkStAB5m8NVBkEdNe64CVFy65zXb67sDRVHf+DoqCjoKoSHh5zfVlpyo8LZsqfP8i.OuNUOrx2RSioOxb3s.96ZPkQ2zqwipTAaHsnbFjWUrNb0ROUWzNcj4ds03hj2GO9XbTIQK1roOKlg+jHZEjNaKk1zQPbU8xjzaBPjJnSkg6TZM6lKX+g1bqRau6YLRUHcRN3P6KIF2nwv+dGB1J6ow81XdkazuxoMbPJQdj89S9DcLMStT4xnK0+n9M4tYF9Ct49BgU5KfV4F52irmGt1WvN6oMlm7UHOTekHqKSfk5g750ytxXMC+IUmZ7nhcDzgutqqyr5X5xtrC4siSyYtt5Roig1fxbZi+Xo7P4s0b7CUxzxnc4C.zMxO+imbxZeaF9mNvNddcsS6u8ZbIBV5YuJGVMYNug8aqxwudk+xxKoRoq41ZXudUqzXWIOb8ASWkUEYULLSmFCQOzk5dQLcNTWyL7SXk8fh26UxB..WC8yFaYcLdeJenCtCiWAe+7yOquG96VkPhIeYd34XfI4l7u9X7ob9TcnOzNjFqnpzF03wpt1Ub9zU2fxsbGJwg1m.BA3YocXhtJU97nA0q9IYRVKqtms+1XYMcNlqn4bHUA7qCKpHkqyi05TSdX8T4AoUMcIOYs1f1ZP2UdFE0OJOoOMf2JWmbPkSaKIhsGkp.9oex5WMLqO2rr8LX5n0.OeltE3jxt4f9UVlxu403kAeFyG+l5kiWd+YLsOHyO6mog7woWe5QH+8s.9Waem.msptTfpZ5h0EgF049Tk76JjF.xkos6jw1gLNOFL2UJ4SdScM8u6xLC+UYfWcj7MfnniCfS+mwWGKW9IVprrx2wUm25TSCNrCo4pYoySko+7iCx+IlTvRDvuJHjYJ+B7jzFTrIX+OmUaWbk8sI2UTtpZaWrJ6SNOUF2dzcmG+e25ea.sw36.TxK4g0m.h5kJmea18oBpbczra7Up3m7+6Y7mymXw.90.I7c5PcnstFn.huNzVEPbr2wGXbDDIW4p53rMse82VR+i+MDsAADsmGXKKsbBqPY48zHkCAz7aq74omFs..Pkbke7oqZLTi+yzR5GtXUaos+MM5c2KgI9LC4SG4i5HuMl1psmJ01D.YyPavS+mzG2QddINz9fnqBABM8NE8r9yhX4Lxae8xfVhD4ELk1fgm2RA6qtY+b0sImh.92SfFpbPTUkf8uh+LUuMVNy74rF3uS0ahDkEg5Jq8Sx2aZd9UWFHrA7OtSt8L.rptOoolxTvtSOUQO6+ryx6g8HyokqJvBCnA.pFeb3dYu42QsbwaA7GgCYqy3EkAWRDDwJ8QS0B5m9P4V.NtnFTzcSeH0w3xzS+2eBSqeE1Y3epwuvNxAIkJSP7kgf9i9y223NF3UFxiGr0sqQlRKyI6O+ch.inyhd6TmQ8SsGmGSymVKuOZ4ogKf+4d4MsxvQpfohD74LPy+0dth5nFVKuLa4yK0u5XYKMAP1L24Ql1dyuwG1hCwcFs3OCU.+qMX5u8p.60KUp.tVQqA9nw6m60Q52z4fCvcpJsur2aun69PZi6wR4iQK+MTA7CDGlc+dP9bMcF4q9.M0jsI.b9VZ4dOWanZWsFxT93+szuvO+7yslPtq8PJ.PU86u+dIWuh7bN6wh4C4.Wu6NNJddQs+xe94m2C3WAT.9LZ6jJJpChYpr7b9INq1VzFE.WiHEC8vyxvyyhyvOv2aokxUTZP.nNtx.dyTvz64PJrClNfO.nmDvObwFOnqLMvqL8rFAdewSx1hq91SaLy86YXI7O9jjF.5CGZe.yxf6emAJCwWDuRjNK64DAuhoaHiTOknnryv+zYUUEKH1x7GXHyO6rrrjudmOmQ+cxYenEFUyM1lw+6tmugm0VsC0g1o5pg71o+ymzayv+zGpr1QwZWGF.a6tu5lxPc0oyZ3z2OYrcm6LeNSuWd8JeOu7Gc6Zma7r9aY6C4QUWIRc1RA6e2iObZefkeI8WkN82JcnACxrnW9cb8u4pKNcV1zIN7L5Vv9K8QGGSaQ0gkHNvmnrKo+4j0FC2yfW5z.b39j05Lmkir7fGBxOi0E6d9L0yzxzJiS1smkHdF6+o6jmwcnUA7CvdLdfS6IPg41mV5D+eIfq5Hpkssb1mWTyutRcLMCvRBS.+WYGzNz9.9Tey.GyzfNuh1H0tKOsgOdWlpKd1x5JOB.NGyFvu.jAFb0ABFs1ZVZfwQ64LCld+eC2gkBxuqA92wyTjpkd6X4VfO2zwd81g12SNP7q7qP2wN7fyx2T2b58FcVOT6V6vvZs2MY5j6+raCNCoYNtHmut2y7lHmF36IONGp7gPXGWYMNfwimg24gYI8OXOEFNRAlrum95ViEDWGsNz3fgyxfuNZ8s8NigYpi+yXF4Mq97DxRcLtdZ+I9bO0C2mPds7s0fi26ogcEZvOSAJ7o5P9XUL8NneoxmKMK9Y+Cv8oxxG7XrkVYFa86m6WG5mf4s279L1Fz2nZoW0wqiJUtbrs1NjJ+9rBY.+udsuf9W52aUqLUQFnRdsUv6xypg81Ys5o8f7Xx.kSIBVqbXG6yrio4nHrA7+506yl3RxzdjkOiFIHyT1kqlY.Df3Q7Klc+AOY97aA7OMSIJEBWK3+n7LBclOJyx5Rm5.7z57VOp5oupx3mpinjONscvPOC+SsTi3VN+jEUuQ8pm9NpwKGduW3pc0yxezKC20U4v3yLkN2VS02hfcs7MjMQ75cNUA72UaU.Iycf0AycWPOU1y+FmllNa1cq74bC9tSoedVWUPAJCGac8.QsaV6fxk3wGn4cUeLgQMOObWKebbUthC40beDfn6LpKMjVyRZl54r6SPeLTIUrs4gqH1Jl1xriz1o7NtRB3GtP6sA7p1PeW26568.GEtJKsxRNRcQqNEHVzeBYWk6SIx0OSyR5OxuDAXNUtiMxgoWqhQbuEBbdp9RllbQ7aOmwsC7V.+QsQBGVI8VTKWx9joAfr26c90jozK0W0OLyFqBoAXNcaLvpKWOxSuOSeWaF94QsmOjiFHhswAJTk5o6McL2R2uqkW6Z5F.NN8Y7ux96ir+7WcoIfeyvecoQhZnhA9uGiCzuxoa0SyoJWlD.hmo86X7CO+6fzDvO0kY3O2155fJi4e6M38o2DAYLsB.v0naqj04RqFezy+N3s.98UY3NU8YeZuANVs5YUK8rWCMn+zMrCcvdWUQpSBDUUpco0ZGt6sAe2o8o4EkXF96bAnNnpMRTkzzVCzNq9jknemBrnSebiNjFyj8bdYLt9q7OfmT02xersmtenzDv+Ve0nA5TmnoxkI2pCrreP1czyjfmtA86VUG.yzYNtKeXirXH+XuiK.FS8Xta6osJkKyuH+gcRS.+.7Tl6z3etestHpcnw6h7.P9DeZZwfpquok0qVdc0pK2Exy5kn1ti.9A3KzsO.vzY7tKClo54qPELcqbL2ud00gzHjAQ5CMWt.9srKg6QWBzarNllGaZ5uCuOzeRsXLB01d1lYYN+OyO6rtrW1j+ZtwJ8T4sCeDz+aqeS.7s5PfgCpbZc59ZuCpP94dxqxP94YkWTg7z0Lb9FL8GUWGRi.wVTZG5me94et1reKf+stSsAfdZbGYQoSsqv3kEbU5Kbozw3AEPt4fLDHp5d+LOc6uyNC+cOSA.5sJ0O3ZAB1kY+cpNll4Oj2C2qJ0eZVUt8vO.bezQdMzosoQE4pCE3ooskk8zuaVcO7CQvSWIg4Ieoellm2gx.lMv3nCk2.f54oGKwayve1uhox1ya2M205k7v5QdZczk7x0NuBxz6fmdPFmoyLsjo7P.xf0ZitCs4Fo9am9rjlkz+dtum6PgoJR9Vd0o6gcfm2m1lSGugIfHaO0i6Tc0pmV6Pauq0+zSm1S0R5esWVO8KRnqFeydrzOphJkVXY6Yfn9PW2uOs923f8AxitTmsBisP+lq6oS6uMC+YcF65vWNBhpkFPcGqS1wzb0XEkEWGY7Ic7Lmny163WUNf6zbiOpCkAyZ7jmgHtck2bO7GIQ9YC5r0txud5F4NaSSOU69Zms6qop44Yn953mu0V5jca7BcLMSd0oxpykV6Pv+cJOdrwq50H0m5rKo+n7vADeaE7S0Zze3dKe58WdWuOy6jwkw0O4yaosLzZG3hTaKUurhawLpAsQUWQp8l2B3e59wMKrG8fmUGp6YOpwqWwpS7sbjm0LktFL2Lnz0OLydRqc58wfNllIFLd.dJSOKsRyoz+dVhkZTmnqpKE34XIlRVMsr6v+sxywy3IoXte9toqo6Wu50VKCH1laLDOY6Po5T5eOpZi5SWFwysjhI9pZ4yAUO8sWpWVOJaC.vdM2Y9zSM9vxDvemmMwtltyppG3vvxGR4RpfoKO7LV+0R8lpS+M.QSjZWJMKo+8npCXIREX33d5kwycpSoUpspUNtZoGnyxdeslT.prwae24VZ+Og2lg+ntbw2pgsH8r9D5d5OKhV8pyvz8P6zyofLOnDf7v1dipqakmM9g7vJI6cOY80o8CVpY3uy5VknLoKGlTtJr.hnosGU01fo9T1kHaoYztqkaiT5tL6g+WuDjAwTGJWt1ceL..mig.nV6VIHCldMfO2OHWlV1a3+NKkIuBQ414pTA7+zuLgkDkJ7Woocd2YcO8C.Wm0BfJS8+jom0OQ0SeismqO8NJJkAR0R5e7dDt6KSDxiNc3zL8DMuZ5Td4bpxfLod5b8R5m4ZuMiiIdo5sYKc.iEwxuuEvezGP6zkGh8l2ejwF5Ga5d9oZpXZpq5ZdYj6W.fNYtw7ks9l5ReJaEWU1x29TcIctk658vzIFe1kzeTWRt6owgtz.RWH+DddpGBvySaw4jy4HkceBiKes5d3OREDUPol15ZSJRkAAlm5o7zTFr2VK+WYCdRqMNWWcnbWR0d3uq1y1rHqcnsTZK6aQA..tOcXLCN+p.9Dk5T5uih51uf24K4B.v2nxi4qxos0Xrgb0daF9cH3EOq0PPUNr6F+UqGmlpvWxVC4.vcqCWGrTKFuDbNlVWxR5mG0RAzW0AnLc43UgOnA.QvzOX7z1V6P6sKsE4Fq5uCpt8DTr73XvGvfnP.+7nlK.3pSGw.bM57g2VG5+DHmpd6uQWZ1C+JnTacYl9GFPlAlAv0SasPLUsw2AQVZlgecZWecX4VNXHc1kzK0Vmp6RdnbIjCt8AxO4cwlY3mGWGC90GvhLYsUeiaJDhB2DJPtLt+iJ1ORESSjKCkAeaF9U3jmP2J24qYS1zgsbC4lxiP90wwF0szKWuwko94mexyR5+0q2OAdW52CDMKU1sicrQNs2YNU4Y.XOVpeEiMBNWoJf+Wu96fImqQBMNjWK0neEt95V54NqoG.x.swB4UlG22XiWQmhcgmR5B3esYYpJMNzMc3NkcZYypVVUmY..rkNcdaT4yo.xgzEv+VpZfTcTkxGmlVpTZ60qs+PbudUqz7Zo2JkNgLy3AfbScX3b7V.+SGHqJZ4PEymzPeNzouR+qWamdUtEhA0C6kizWjxF.Wsmb7fSaOrbyvO..zM64fMth9jzbEW4Y.OuosGEks5p.9CrizIVV67ZOyV5frk1nuLK+.Osp2FzY7wMx5XmVSkRK.mCA7GPeSmXYqyqtNiD..WonLyRWgydbCU4izVgz.v4S.+AyY0IV1B7Gx.ebJH915ZdsypPfsctc38tpHyddLv45+l6m7me94+8CtOWQmXYuiQkCIqxdcuo1S8P0U4I86u+tqaLDxqqLOT4Cfp5s.9Mfs5IqchorXsj0xg7WKUmzGlCfqUG6CU+J0PGK6tl638w3Iu+me9wR5OJ5bkA6iexhiTVsZCTYOybZkRycMet5pvRZeIUuez6H8UkxGYHcXre0x3wALW9ZkOSQNJmR+bYhdi+a0veje16t81os7v7ZuCJK5syrWFDJPlkk1gyxyIuao9IO5MLlx.2CA7G.Fb4enRO..OIAg.q6LiaQ8s6Q5B3etYSTAk7yr6maKMK+cHuabZTGWdG.QVVqaZhQNFsCyU4JOfwUl857V.+QOX501WHQ6Yk8QG442VKsqJU2bszRkRm.PNouHtBW8308gpNOSyqR0L7um6eTETVl2ObE1SG.J6A.PWszXkL1n+UUGu3SmlRU.+...zMNU6yqstkad5fA2Ck81mnlWJfeBurzXH...74x939i3p43+dr+luH9BTPLotI.OmLO.Z1O4ywhw9PDXF9aDcB..TSUtO96b4rG42itop3ILtL2cUWLqyxeD+.O+7yO4YF9i3KPtOx+gbHicPOUERCczdx2j2RlszMU03e.vPecC+yzLC+U9vJoxoMf7abPRS+p6S+x+UQkRKcvd6CMqyZD.Qf3U9LOQ+Ni+6LMA7y2I6CvI6O+PkrTG9C+7puFSaMPM4aDY2wjiD45.9nVPd8z0KWcI8mwFLx3y7qW4849t3KJBvmaOsgpc1ZwR7F.d8Zi.90QA2A66xdPdX9cjYXBhptT9rhs4dkooJ99BxJ0G+NSOaOR0R5u5608qJ8kgJMY3YDfLpx8aR+bEiUxXPfX4oWB7WgmLMkp.9e85uMzO9eVImcGYY38i8UZtsmxrxCA39U01dOywJU02QDCaUVMCk+dhIbMCuWlyZuqB6d3OhFdIN9eVsqijyp.QVqrP97yO+rZ4spT2D.hgyXLNFmD2g4FizViapyp56kmbrvoZF926gNTEJnLjFNZgiJj1mpJ4oUl.5AHdpd+mUNsQcL2Xjp5UZKy6oyimMf+puW4yjmt.BeuHtzd.f5S+LP7kgOLmXC2uHlW91R5e3gLhOrP1rViiUaqnrkpjNWJeqJoO.HdLt7bxsaywTkx4QaL9qtj9qxKcfmWEaOY7AH5v+8qW0LsdDcO8GMlYF.3a8o8kr2sobUF6vdmPn67ZFMcGZe.wRm950qsO7pRGUPFcj5epqRVsVYWqP27KCiS5nku16u+pTtMp4go5P6ibrOef4T8xsSms+JxUvXsk87tndcHAmookkmtByfq1mLVmo+90l78R.+IybMzqRC7rpdf9ioMnbZokTY0x6VptnUhCUwV80nMYtCi6SYb6tKU1SYxm0aA7W8ACjYcc.KcH8pC5bqS4eiaGZtYVpKuGxlkBRnR4cc4itAqYns4rWelbvVIIll1en8vehr2C8hpIyoWM.VOKkml4xoGQWaGpC5PdZGRiTW6o7qx3.SIf+jZ3pdn5AT9yO+T9zX10o7m4VtvcJ8uGFrI.vwY7DbUR0d3uS6S18nJMLTkzA8vVA8q7L.v2qCSrEbGdKf+nGT83J9ctgfpktWqLW0RqTGcrr4b6gepiN2uJTEQuN731Y1aeJY8brRekDAyNC+QeOZN94paKu1Jl9p9IN6VyHb1SeudUyxkqoao24D09G36nrMjeQdbEKcMBtmCVzw+2QM8skr9bSts5R5OhEJqdvg6UWRmU037upjO10UoQGqKZFK.xjJcaTjQWQ+EYsu2tMQk7LlNNsTcn808AXNbP8M9qi1k2IYNct1WsNyoqw1yGhqZlqtXkxSWSVGnEPOr1JAk5nB4sUHMveszXildHjeGigZ3uye94mbEvemsm80DwiqPmZpiefi8xGB.3oT8.82a6qQpc3qNeH54yFGX+L2ML13ID5IpeVx.9UwgrQYVxjHMXR3HT1s95d+oQpLd2yKnm1Z0d9DqFzTcs7sWQpwNn5zgdurV6qZ6M2j+Q0Lr8ipT+TpmBbTuEvuCSB3bToAX.yQ+C4wVA8Tg7xwowJjd36M9vwc7YthxGWOiAhN5Hk6ux1hl9bTxY3GhfpMqB.41RW4tUJ3mJkV1qk5moiuK1KA8WKQN+riiEr5eb4LR.+IyRCXKy5XigciF3qmHO.Kl2dtmqyddpfe+K0Q+WFqA77rJrdFB3G3qXPT8xPPDcny58TtNKuG5dcTA+xXJK.Wit2WST81ozuFAiowyrekWNl.4w38DaW04zdzHu..3ck7Z4qplFXeWlksWup+G0n5outop4miCve7LlV0zaUHPX5hsZKRaU.Qwc1dzrKo+n1fXGNkg2RUW9zqktxb9pxr0LMV05g6UEySgrZZ6Qpe9GK8dv6GfN4me9Ie6geMTWu2AaE3T126kY9Yeu5PZbp4N.M6v6gwowrW2j2IOMmjm8WdWDCc+CieDJyxYaZYpzEv+qW+c.ISGnsApTWUHusCyzeGRiSU0z0dz4zN.vdL8CkO8mi5Xuenq6N+OkA7OXbP9UHfPpqpuJFd8ZeowWuzIW1Ugxp.PcD89jla7Qca0A1IyEz+SmG+1g12vgwzbmF7QiJK4WzKicFjFoJltMFjuC.7czWZ8c24wSimOsmR+imkIC9rGpd9a0SeTGNc9g3QeHDM2QeD5GJepdd1RsE+jSldZC3eNUu.D.OMsylOcIOqKoSHStx5kpyGOc+pwLpe30ztG9maFlr2RAf6T16yY5JkK6omkT0z0XcHM1YysmfmK3hHVN3JNw9iX5j+PdS7j1.9oFbssjex+nSxZaVcYVWbmzS0r1xCdu+7UqdfzSr0gxfYypA7G0LGWuEPbj0.f3yrzIOaEWgUKkdpV5rZ5Z9SEqC1cUpu04VMQKspElVNt5eDupT2csxqUIMlUyFv+PEtrj43.jpGj+BOqstZg7AX4osTvDt9dIaNyf8iTY+wOGy8Ls2etJo5oOteS6C7s.9yVvyY44DfJyJ8fm1be7ow+2Ue7BUO8A.GyP+Bk5T5mbZO6sTCjAhq0V9kPTnbIYwUTV8IuRvn9T1JdFO1LAbkTCnw...H.jDQAQ0S3MzIU0aLwG0frp50MoNTVkNy3LhotztTWRmQj.94wU8F.5PGr6MM1g2Ecl7W.9NW4Xhp93shn89N2DawU5s8v+Rm.yQRFdFgw5PYzw6g6oGPVcX+y1YNPzHSpTY0uI.gp7N.hnOstoC+VNCSK+kpY3uCe8q8nyuC5bZO5l6.ypp0YGuMSl9iJaoAfLN+dsee.mmus8lp2dEyS9906LdGms7I86+G648vSj2N60xW1TouV+Rl6DGdpp+N30qdjFyn8z3UUpmtUZsx2Wv6Ie1r8ySasaLhJbaRT0qqMH6N61VpV8ypkdlyQ1BGic0uWR0L7ujpW3Yux9fX.xsrcstRMsUegYt74Uc5sCDSUp9Yla6cKQeUdll.965LZ+5UsprOGG3aPNoNIQxdthWqd+oeJuWfuiCaw0aCtxiW3r1BGWY9bZWR+V1nyy6Dfqxbssn8Fhl4N.QG+qkUW8f9M9g5xAn605NBHOK4cY3Y7LkkswwpA7G4Lsr70tXYGMOzsy..rl41VIUnuBi4gukxPbWVqrVEZOdPjqSM9i7850LA7G0Lhwyn+3+YV9hW7WmUED48v8YtYI0GgKW5xfv3yoe05Y5GASd74JxA88D1yAarxeq6LeGM7mSZWR+iU8BOUZeGlkk9BveLWc1kpGW0yZk0Nw2yBCBC5koA36ZSM+pR6zUHcjssXUJC32IA8x536jJzvADQm0AQSlqet16frm1lpJompsxSpxG7m6y3UCazGybkuUM5FsUEWo4T5+0KU52iHWYyIXJjGm8c8cFqitmm4LltpL4GzcY5PsVarjQYrL4aA7OLvrrN.stKpMveWmfo7LhZ4N9LWUcI0Q4IX7LjIea+oCk0idY9n+7AOsuoNxz34S0L7y5DzEQvRWcaUo74dSGUI8ReTwxrUpsG5iynLqx8.CR4d3euxxRZZO15f6Kxoy67q3Vo77roZWCVqYo5iUHcmsChFXMlEQprJcnNCbcBe.+iGb3z+889++qW0Xf3UHM.UVkZug9wGiAhi8NQOiqypOHf4D5kz+38gzz8jzQaLyW.E3rrmq3L.fuwvVRYuaMEagEf4D1.925dO1.pAdBUtsm6JsU42gYVUCTH6ianp4KbbGI3e3tobYbEx.9cBQCjcZuAhECFcadGAGycVmoJ0OqR5Hxl9wAeaO7+zYB6cPxNnRXI1GpPro9YLUg1Nq7ApILtrc1KSab7GSVxuGxWyxyajcVuC+4meh4L7uGZj..tR6cOyFUiuCdux+ehlHmm7opXZhiYZcx4Nmq3Yn94+p5uOxX5K7mR+y4aZXyWcBfmUlZGNKOmScFA.jo7oox5y8Sx6r7Yb87LN6+Y447o48Deq2lg+wec+69KFdj+9T3mknrAPmcl8cWgYNrBogWut191zuI7ctp5PpaFSWc9x29m+z34S4R5Wge.Ne2UaqYpM74VFsQdYueEOSQLctl4xihZ90QcE0cxT8Q1mJTVOiN65Rpa1SWQ9dJC3WCY4hFr.FKKsgOrj1qRvheirj9254LKoi0bl8op+47PdUNbVWahxuiuLkGkx8vOrjLU4iZSYwkkk2M64TjNR6y8JDLK6yPYtilmGkxpbbpemKS6+Xq9ST2LmN6aahqpbvayveFJv4p7HexP4JXOx9I2N62RmJ1a86qppR5rJoiWuN1rIpcobS9W9L9tPuCq9nt5rVQGWYc7zsj9UgfknyPhhL2NUzOHZhlnjdxbYN9d6obnslReDk1k3XT+Lu9z.1u5.8G71R5+IKrcGybuFAeNVYFjcG89L+0Ks4LVEeWDokz+cnaoWHpTODhmw0KWZLiOQc2ztG96bviY7tVcvUkuks2CjOeZ41LFfzUTOMauC.xqsZ+JqsGk0manaVqMn6XBgFFG2veGuEvezaL4Se9hd5ZK6Yuilkz3YFLQVRyjWmQY0LNa+c9ipdTY7i5.Uk1s.xfqdrCi+yNbyv+QFj4d+81kAhkoAcdFASjkzJ40YOvwLUG80qicRfOMckwOF4TY4idjgmQHRxVawSYru.GQ3B3+nlqAsr2P9TUcvb6Yetr1+OPFkw1m9zChltnSo0nKKejFtFcHuuCoQfy0lGZeOw.YlFH3z8gvQ9+uaxXvDPDckCpJ60SiP+DOAASB.recc7BOsou2C+0xmBF.DCKcsd0gq6qg9hl1mj9nxk65JPBdZUuMYhukFu.2uvGv+.cPCbWtiNjpXmdULMMW.hC+b5WJlVK+ohkQApgJ0mxdNk549j98vO.DGYe6JLm0FbRDRq1pAyasa2lHjuc1TN..li.9AfSUkBnZq.npTZcOxRZUfurlrTNlZp5k+z9a7Hfe.F4N6npaAKBbszdBDOSGWQ2OH65V5MBRyd3uyNRECUh..niLFHhl8LIBcaFw6P5MZsE81L7GsGPfbXOMfq8E3ZbG6ea0eICN5U4bU08ze1nLa+bk42S+y1R5OI1yf4zPQrMj+Uw7o8FngNznhhR45qLn+Hj9f8pxkWc3LRzoL5eDo1gDvehDoBNbLia3qxA9uGQI3nknipks22MQN+EfpSavwfwRPTXO7SHrmNmxZGXqc0PQeL8tA283NWgqnLUFKmt0yr1eIyVp7s9UHJVqbnxn2u2B3+2e+8e9ADAUswA0w5oLWddqm8Lm1phyLOnp4mUMcQuYr6wR2amYtze2embWlFOukzOgf655byxfediKyVoxvqke28srRTL79eb9j7j+v6AxNiYhrP4vXP.+jF5.iLqRkc260LTkRyYk7f+k2G.b8VabBZG99YO7yiyLCmeUKO7r5LpZuWfLY74lg81LcSl6+IyO6ruUfRW8TocA7COHC.Mt917lpl214NpWRUyqA3Js04Fl9apqtk29za2QKoe3hY+smWeZd23ShexM4g.bOFuUvpx3l510YaUx2NaOc9aZC3etBTO8KS3HpT40iDXb1R2GoyZczA.WopzOSmtxhWZ7AYa7P74t6y0no+c8V.+Ynv2dajHCoE5AAClaqk+MtcFs4Pl3fUDxmtMdhJ2NkaQk93oyeS6L7uGUtQBxmpWVb5UP2R+ZYkq4LxL8GBjUYu8K2rMuqSo0HnzA7Cbu5vcydERCeitM6RPlrUcyt29EDYcJn+NkVif2B3uhyLG7z5vA1hf.g3Zt1WxdaN7uLKhjIc4iG2gzHwyzxck9Z4SmZ4f7o9n5c7U8zGPLosGlxXqfXX50O4SzdcoC3mZIqcdYfX..bV1Z7PYc7RKoZomJSd0esVv82cf+B3mPXsFH94meZQCH9v.jEC0G2pdK.bMVpMVs8BOu8Nl96Zr+Nz9HDVq.ekNv2fJXnNo5l.7Lp9gja1e96r8b9LH+8dIfedbG4qfoABxfJWVct5qUY.lUmAfA0PUNfFGGX3bW8sjWQurWWLjOHfefaUFFDx2ppousFHVGxayp8FfvqW0s7KPbMsMpw+2ZSJWVq+F4kOi21C+YHiXXOcu1d6NCoCnipdcSyNA.v1h19b9JT8w7bTYNuLSlFi7hyvelteLUYBHJzdD..GUEF+vd15XVMf2uYOk92yIvL7DxxGgh9pykQG5HuZuCl6NzshoyAUMcUYtwLf3ZOWihcodp9WdFtV9fK1daDO6M1m8m+yRmeOzwNx6XZl7X7D3zofJfnYoISUcRtCusj9mN3EEDgqWkpmUozxQ04zNvyR6OPbM85rc5O+qWpCy4YZ4LmR+vMnKMhu1Y+Q0dGLW5rZoQLC9..mM6i++3tdGHfeRkL23vdBbHyouWuVNMN2csalsT5zWpG.Xa9XpTYQ6vu2d3mGm.i9qH03vYZb5ppoQnJzlLDaUnNZERCvZFWFe5UJ+celpXF9A3Bz0kqVGSycMuFhp09vxcotZWRmPTs0jcIfeZmoK46mthAelnsDltBUO8slo0AEn6e3c.DGa0FcUZ2pBoA5Kkeu21hrj9IbVa+Q24fsx.4O8xPGUcOeOCo+tb8fB6QFpyBYzbW6fO4RY+or21Xtp1hl9Nd1Y32f33torFjKtZg9qrjd6vJvYrpLStrecq78frVNeqUzo5v4j7rXXn90O+7y6A7O8.F.hFc..OqtrjY6npj2szcd83A.Q8zsOpUErVcQ0SyqtbEMGcCuusj9ANMZHmpYqxzYpL+SuDCifk9P.PlLW4WkoIJTVLdDvO.vGHSA6C.b0DreL81R5etk+VD4JWgroCK0vpm9d8pG4i7uzmBPjoOo7S+Lbll1lPJuV9r+QgXZ79i0UqHUwV84nbcrrmfejmAbmzlyeHFsmQ5B32WwDhsgFx0fNUvd5yw.X..HpRW.+.7zrBF.hHqFk8w6A3Ynt2+5tdeHfeH.pRCfcZozNWP+Y4LPgymY4OOjOUaqcNqTk794RiUIsUY5mnO157d5tKGHfe3FsTC.i+4xZmAG4J+JqowwrTugXZnNmUgy65RaRcHM950+dt4.DKOY8xowaTx.9qbCeCYdUKMdjS97Lm1EjXM3rDAhOsiRk47xAxgmZl9G+m8aA7WgFNpZ.SiKvXlKxGAI9WUsNZW3pIjrPek8jyx.hHk69ipN4kyIJ2rbkbF9qnNLyvcXe2Q+j85kKYbZppowpYuenlpjWtTZsSC1DfHoSiWHRa00+6R+SGNf0pX76u+1pYTrSoUxutz4MPMnOVdBcnbmwCDSuMC+Q+T+riKkzijdq9WNq5oOHCTOLuju8WJGCbm5R6MSO3T6R5NRlF6nkzO.bXBVJm5x.v51DC75UOSyeppW9GdZqctio928KsA76pHAHCpdaTZGFhg8rBHUWE3pEkCpN9qztG9GJLMr2tm9CHypdCgYO8k8meNeYqLg9IAhhoicW6S0m736U5lgeEPHqeYvNd9SPcM2c.cVqatFqlLpBkgIhlFn+O+7ixpvIKcA72QGIPQMRB2Ce.m2U41ebkglKcs94boakQISFW9UYW3bHfeRmJ2APlSaiGn4by5aEmkz4ROULc1YUKnwtDHbGRiyYtzcWNnFAf48V.+5PHlbX7jWG8ZU70qblWt19ua7YtQFSaKoqAU75U8xK+TY68PmKyNUlx2NCYt+kipCowJYow3ls1WQeLeh6nLdZOz93cNvBimOM+PdY7sV9S0y6rGKyoNs+X6PZbpp2tC8SGqGmcxy9qm7cwPe8C+vR5OANZm3c5q3GYe6fupZ9WW9h8cIcRtHnv+PcSHNFOtU8cRGb2kwEvef8sCLqhMZlkzyYLnZe3FfqRGZWoCoQH6ltb9Gp2VwwvRur0JA8NKe+V.+NcWigyZVXxTClU4zE9rmAsLkGBDWZGA.35smXAtxw2O8ueyve.00.FqvA1xQu9D26u+r8d..fqSkNHmm6YMSO+7WtFwiIGZeAyUs+Ji991bqk8Rze9uCdG.2OCJIeF2mg1Moh16rGB2kiNV8ge+Fi+8X1.9i7.b1yyVje94yjg7z0ZvZ5y+3F35xolMP7TwAZczUPUmnuFhnoA+IPv73rxm5Zd8ckteaI8mgSHyH+rwws2kkVzKWtly5JbKyuCfJJq0G6vgB5R2s2cl9P5kLjeqNZd00sfbFs5L7mkJg9Rf6Sle+j4mcfZJqCLYZ6oUq8UKme.tVccKHmUqdn8E0AyrmYKMpO6qQg7kMLSM95e4m7OxlJWlcbvwUIcNcl8qTZ6a48.PzoM6yWYOk9UXYdY78hODBPDLWaQYq8zox1J56H51R5e7Vxbt60bfm0dZOJC0W6T6pY0z91S2ozuBYPL0sCTywG1hi+mi+A0wR88Tg9jpPZXMcpt3bejipm+xx5TYepktzt0UWGcX7noKf+inKEVxttEnXmUs5jS2qvNcgqoJmWl4sA2ZpV5YOVqcmJWFF39nsj8IZ8AU5.9oNp5fRqj81IPm5rnSoUxqJ2tZkSa.Pdcm8OU18vO4x3kg3bU.x3YOvUv6f33HefC4a.WIebQlR+Nvy5IqCNsOAA7SXrVECcbAv4Saq8gO9XczsCjR5or2l0V0QuyzlkzOjDQtQOC7.xiwskntKjSSGSfCM1XSas8xdxuuyxDoaF9OxW0LaM308uXaj9RXehuM+as++idZGHWpbaJq0NbkS2zKacaLjkx5aM1orOKuPDjt.9WhFC1mn9dZueIrn97eF57G6g7QPUDQa0NZ06GYMcMcWQcZLSUHM75kI0i4cW0SSY.+UoxO0y2zf9P4ZcHPzInJCdCfyR06ufOixEmG6g+f4JKbqhy83SeOO8NT1dwChgkt4PV5WKCF2ViObQ9smxgxmqgijOlo77gw.M2O.9NobF9ouxxLG9oyV+vrFlgz3XlsSptrUmbMCswnNKTaYocKqZL3bMMNjRLC+UaPKWQiZZnLGFJKWsxz.ww3OrnsRTuHetWpT9ckRKvcYne9RLC+ULX1yb1Wp36mrX5694lYs4xqkmAOuJOqRlg+5opkUgtHC0guq9Nxv6hLoDA7CYwPCXyc+4RtHfoZa7Gma5rfO2VuIaeb.ejQ.tOc5lU3a0o2AWUZcZ4sTuj9q9fs+1CrMG3abm1a4sJUlbtzxzCawJkdOhL297b2u0akd5Z9L.zKNfwymTGveWJTLN.hsRyY8jcOaOu74xbff6w3fCUtNe1yoW+zeOU3jjN6O+.DUU7lUv3aVWzl.rTGveVpTbmpv.OWSlafox4KC5PZbr4RuYtLZmM20h4RV5Wq5s+VApe1SU4CycTYo7dVdN4ec14aUqbvRommXhYSc.+UqfwdzsNqpjNVdE0Yyf412jex9sLSm38Us8nO4C0PcMWP9Yn94ZTNlH4LJOlwUl7dMWZ6I93iNz9HLx5cPOLU0KCumCrvr8NXszyzz6d92it4dVqR6uUHMv2KS0GOppWF2ghat7oer6pWN90q0embm84JfeBkNT4m5auKMbdd6cl7qjkROJqRWTkOtUUY6xkSxihKA7S3L20EU06bt5outX5rRT0xttdg1VjO3FmdcBN8mCxtp8Q55f4ZCp68ijUY+ZqshDvOgxZKyTMXPjLtb43etopVY1idZCWsze0H+AHJVZLfudosprXH+R91yZ56cA7SXDk84xSnxospxdLj8Hpscs0YV..Woi1+osJWNMcRQj28LR8ozO0RGaDP.i42P41kVNhPzrU4RkaAtReaaLYqMpNN91oxVdV071L7O29mNx70hpiN1Xfxt40zksVGVN+7YhT+T6sc1H8LCmMkseFm437pZaTULM850eWUjVp+2io00R6R5et8MqBO+g2Cv0a54JwbGVevfpN3T.1iqnOwL0t53wEjkm4yzbm6QbeRa.+yISU7+Te5ccYFT8FB1SZq5keqlw4WSy6jWxXJOvcqyW+hqMdhNj96jLN1+JW1bs5dUdL9QWJC3eO6+vJToYIU+vVZ5WAs54mik8zZ0+nMvTyUleZcX0I3t04CA2AcHMlEWcafUoLcURGyopoqr3sCsurmgT4JKK4me94+8ipoJ4mFvecKmNdOoQ97IkGm6dres+7pVYdhs8zdT0ayZ7YqR0SqPzoOv4cmuWVbF9y5L0U8BUqcGkNHyuCV6DOm3aqYUZPExemlVqT8P9Wqs2KkOSzj0wuc1l6rdZf5s2GkE6mwa+3tWWKJsGO60xmfthoHTfAX8Sj+JtJFFqhossx6bHwRlz8wJXENzSxSiG8S9GiWgqO0pcMk6g+n70R.XJAD9WY6cvvrQL8vQcszQ1lAC8eBv8qas6tU5MS8aVAoLf+4nfyeksAfNU2uOyyZ92Q5LKqow0zoNy2SPiYK+ctCZusRCYKMB.OCer0+UEGGXjL8caYB3+0KyrV10o8+M42ZmN6CGTTUtr5VCdI6o+87rm0zXE+fMbbYs7K+g5vDU9vFwSZC32IgbOIOlnXsCPyN7k7269jsx0YybZKyO6P2U89W.NWuEvuSxThrpG.wqWpykYcHPefZPeM.OoNLl9mxzwhlxY3+HCnVAoZIq4mBDrexZY08PYY..HGl8Z4qRLvzbXu4SxOIJFGP+zS0ckS6A4yDQU9iMBUl5tbUR4L7y5xXCFSCXpqxXd2firJFxb5burT0pm0N2Fd8pGkqoFTVkpI6koy9yOwl.9IUxbChY9Ym+0ZWgac+iVUUNjBIS5b4P2BEwhsz36T9S4h6l.9SjsZfH6C1b34uxW0W6owsLm91J+Kyos4LjdqV55L48Cb+5d.uZatWxP9735jKU+LCoiyh5m2KA7WHUnhiYQqtpZd1zzUUSm.4P2C1eLAVEClM28oJiuU9c7rX.+Un.2qW0IczAZfH+1Z0YLnp0K6PZ7n7d.HRL6+OiqZLdYHezXa+WYHOK6F+N92e+88.9yPlvdazHCoE1VUxG0fe8rmOvQUJ+NlONGPjU81mxZavm8ycE6esJeLpomqQUHMkU+7yO0YI8qfUMHeC.fqT0mk+pltFqCowraqysfNjGFky0p2B3e5CVVxLDnesDkJHmor9E446T0AU5jvFf60dGCQjGK+zkZ7m9+KwlyjqseGbko+o+cmxY3uqKi1NPCD0O8Q8o7KQfOHEqIa4+eyDFD0wFumqy1n8LC6wQ93b2QY7+6x+a3gXlTIqz4FY2u+9aKaCVc2boikQ4uxR9+Y1dZDSy6YVPotj+dORW.+JXTWGIuU4.3YoNXtMDDw3eTIUK8v4KCeftqnbbFqajwm4OUFJWx45NJemt.9gpqScrQsUoxxCCBa5fw94me9e+HKVJeoRA9um7iLkmw4pJky+TcO8Cci.9gfwfPg3Z5.kyVPxY5Y8azkz4bV5iPksOL0UYnrQzKib0OeQO8WI6sdm5mbUR4g12VbZn2CY7vsKaOu.+wSdZ6B6wQ2KzUt7Z1uEQLF1Zq5WKjDOKNC+YtPnFJAhhL2V5YP6wv06SpmU85li2FNy8CpeYfHYb4to2O8xG3ps5L7m4FDy7yN6SFyiy7LN.PkTgYX6aCTHpWWamkLltD7W8r14lx3+8LVdk48zq17wkk982eeOf+rWX6oeA+jxdiEcNuqJx9xn7n1J8VozJPrbl8WVw.+6TeQeirO1wH6n0QG+6uK4IcIctlq9cvO+7St2C+KszXpdgm0Z.ohcZStzsxdcK8xx5P+ODCW0GGuJkgM4A0RFKSZ02vZt6702B3O5GpKycPWDsmQ9b6cV9yXddWF.RGmUkwcLWkALeF516gtkdirtsZi33zVMWEq9ld2F7dx+u51el9Lj1Y3upAEtk81HRl6HKqO2DiF4taUK8rWysBqF+yO7q0w2MDCyMfyJTd7Ntt1pv6I3IzkI2YO5V6HexV3Xb+TW46qzDv+2bBz1sBbYVW+PNjWycWW2Iqkd616BhGkA+LB5m6xzOLWlK2ckA6mwXZl6CtlwzwV9l78oaK8Wutl2MoHfe6ClZ6SOTSxV9oCkv5ZoxjFzL7rlNCJudku9NFSeHTQYtNIyao1bq1XguhzxUDmS3C3+r2GLZTIVNquJl70XXuMjWo5hc6PCkbqSkOW6pvpSuGfnqB21M2UPrYq8q4dVyzy+S5Lyq+uS4OkKxU9US34cEGpIYWURGchNt5gsxmUNHtztJ.2u4V0ii+Q1cGogy5uivNC+Unf.KS9KUwzxxY6quy9Tw70JllFr1dGc3Wupoc3Hd55AaMdvLTW0XZmmUh6yYZedyNC+UOSQEym0Ud+ACOMWYn00zYmHiyTwbefprkF9DU7z5mZRYy+k2G42Pdn7x60O+7y+6c9aA7ONS4oxXp9.O9F6MOIpUptiqSnHao5UC+7QMeauh96+6l2G0vdOWJ.xir2e6Yv6.tRUt7Ul5y+me9I16g+qTlxnpBuy+qwA3W4FDWRWRycIcRMT01nUOreltRql6GQVze9f8Z7RKOq2xVOsynu4vtG9YYpnrtLreupp8bJ8Ws7F6MXxrpcEIMmwCxr5oU9qwsCOW9d2amNJoe0KOlnjusGSGOzv+t7662aA7+z6ys6rPPUGXdUSWjCcrr2VCrDhD8QPGj8CCtqJ3nnklqPel20GsHZ4ceppjNhrokGa6R5uxTQhmRGN7u1h5eDcJiB4Q0quV8zGDAVR+.mhtFne21BCLurkOW8k37by3VE1+nV9ymqnOK+C9178nmFWJ8E8m66PVeG3FKJVDvOvWoyC9ryocH5laIQafm6i2SwyZacrJDv73zPldtuBcO8y+5LJOHfefO1RA7pSaHllVmrC0UqVZyr7ybGVryIa0uyxy4bNyUgQVV4Iaoxq.x6nc3y7uC6geJkLbc6TUy8d2fRgXJSWQYbuTd.9LKU2Ys5TiaCNaefl0rmw+YLhq6Le+XF9A9H6cYxVoNv.xiruDmWiY4GhooaMgiTOsJsOw43LKOL6L7+jE3ty+tUw5dckuuMKUOGu2WmAkC2usVhyUvUz1q1ygu23wjNDz+bqnJ02xs8j+8o4weaYio+++1L7Ot.Jb1Ni83jYL94s1oe8d2KgCc.V8CTqJllfLqJ6O1WuNuY5uJuOfHZbP+C+2TCa0F7mz97YU9X7eNscI8qx1yYtSN4O8OChmiz3WklsMpqkNn6l6WCtaeaepJCCWioA4WoO13ZNRaQc4cxdbkuGdKf+4tpOta1aZ8vQFjxzYEl35ap6J+kHqJmD1TSy8goTlDdNSq+o936pv6jyHt0y98vzmmvNC+WYP+UnvUkrVdsFKisoe4ZenN.dNKscqlpC8k1wqfRHB53D2dzUZ0cuEkCa.+udcMEXzPeL008leDVQMeCyfDcQGND3fJSeUDAU9tomiE65c9gQl8T5ORTvuONi81eFLLS3ykNyPZeuyfzY8mO..+q8N9XiiNNb2z2CSuQFldyL7D0ICe.+udcNMV4ZaKGpd9jurasrV9U0KK2QakeZfZ4f5kTIqcMuordNoujZYqUH3cjeG5kz+XasrGznl8mFb2151HPcwZwGrKO53dH8Hz9T9MWvBFGHQQGt1kOpwuCla0xdqmR+QlBK+wb666oM36cE2oybf0Qur6QutYd8J9oI1m8bkSJuNNlK+R9CgD4m4G...B.IQTPTUvV8CouGhftW96p2BrGQpB3m4szdAOqUzL.sb6alYsnmW+ooqJO3q4dmTwz4qWlg+LRdB.zcqFvuNJ4ts2CxtpV1LCenl8LKmUzzkl12jNyP97drmSt9JjNAHJpZerPmc1iUZ5eduEveVFbVUFvLelpm+W8z2XCAOG4z6Ysrrhd5Dph8TGUcQ.nCR8R52fmWl2K4Vzy+N6CDqnmdOSSOnk5TZO6V5.2QdXrXFP2lxr8PlFmrsLEbcdKf+Ls+oGeusO84LSMxcE5d5m3IqkGO6fGb5gmSttqHCVq8EkYAnGl1Ov+8POGes0B1e7uNv0X5c+6v+8R08982eEn6qXcpsBcVUq6Mzd7ze.YVUquB2gzFv+qWaeGXCbsFFH4zkm9byFpAcBb0z2++Zt6ncfmwdGCjwJUCQJeL06g+oFOa+Q5k7Sn6o+nZqkycVy2x5y8VL.YntpZ6ViMckXQuHOO1j+vqW2S4fTGv+zfmTwgLX71QY5OWkj8zzcFruybCf6h1afmwd1RepaVKQI+L0A7+5UbdQdmb.Elay0.elNrL6BGtdPs0g9NGmFG92qdZt5z2Ts0g1k5pmLuM06ge9iN1vPVSy6sSZclCv0Jq8i7o5XfhCGVrU6PicsxtNybfXY74b0S0NzaA7qQhbnichcjeO.OO0UgXoS0Iq9A67RA1WswEBY1ScvoN87aYwkzeF5TXOu3xP53LL8TROypPZ.5fs9Z0VZhPbTowIrktztzd9nFUIsl8zgOBSe8TkcG+2qkzeBU8uZMzIYdUUsm1azlD2orVWh6SU1ZCUHMrGYtORHJkcS+g1GuqRe85NS9HQVWFrITE5O4uFGze0eujkwRjgmQNlsFmP0yyiTcu2B32oEN.WmomX1.mq4t5SWi5h8Tlmo+r9bulkRSpaVWZ685Ls9jkzeRoBBb8Ny5YSWVhpCCmqidX1N92WECf50q+sclplF+FZGNF1ZqpVgxtcqrlakp+0SmNEveR8zEb350sNGhpuIeX3+W4kDQUoejyJffp79XIZG5eUk.I6B4UjMQZRdDvO.mrkNjgLfEhhpTV7r2inU48Ba6oG.NP8EkUQlCsO3Fk48LXm8M4aQ5K7x2opG.QY8vK6ptkHpv9Jcszc1Sa6wbsY2gzM4mxo0zSO9eyveBsV.Dt9RfmmkJZ8T0qfvL9Ly51JOsKsOsmwBY7RbmVp71vX2UdrdlFy1SkGaF9StNzoc0nA8bZsS960N48qvrE1cZmMdt57D0aqA4gjAiaOqakY6V58o71L7moCYpL7LdUF+0.8kAIZldZYWsYTZZ8s0VRzpW1KYnbdFdFi.umHpNR+JUpOnrWmrpqTLNtqNedb77+7yOyOC+UpwAf60VWuNudk61Xrm7Olt8NpJo2HOC2FP7xNx6lHmGeV59YY.vyZOiI90qqo8nw+Yt5R5O5MFt1RqE39cj6cU0Uysm9.ngu2Z4gpeR1smyxfLWNeqm8rm9lS0ROKoB4cFiPr93zuEveVNUSW5kXG1GL6o.TUS6.wj1b9irMPswm+DY6Y+N3cBYkxs4UUx6V67Mh+0Y+NZZrho7T5+HyhXW04zNv0aZaLU9LanZV5rlv.x.hpN09T05+rS4cQUJC3uyN59yKix5yM80bA5pbr2AQlAfA4WU9.qa0dT2ZupaoWtdo6Z4K6Mpw5lKXIM7QjM9fHrKA6W8zW0sU9m1bgXqhKQ5pkd9FUL+kmU4mgeCLMmzPGYv31WzVCUgxx+U15KpqWWaci7Nfin7A7Sdr2qtB.hJCDG3NXkPVWxO4rIfeBiwMvMW.9B5G3IXvWP9rm5sYcbEKcnoBvqWu29W4C32.0xko4WC+2iuZOHt5V8skRuNwyqmsxqkmee7ddc648SGdG1owKn8GH2t55uuEvuAtvSZsNnmdeQCQvzOJE00zf6kmmeULObO8OpOz+nJ4+xOyAeLNtSiGqxpyveDKzEwmo6TGOPd5xIedUzwYBcbP+UKsweM20u33eMtO2Q8L0kysNj+0gzX0HOqO1ad8cTlHcWKezSSGLsFLiM4OTMacnhpLeNsT9ZVyOOxGdpikaqR5c3ZfcbdXGyOqH4i0RTxKeKf+JEXUle1WyV6m8pktGe+lCQ0PYzpU+ChJ8MvVlNdo4Juj01rmV9OqoCdmf94aMsstTNC+Sa.eZkhtTQohow8L.tJltIu5Xf96MPqp+NYnulpmN6F4m0Q0+fPJqlOUuLIwTJC3ev3kzzTUeP3Udv1y8bOjWm0zD8S0KuNcYjZPL7DN6xdUtNKyq5sUCPpuV9bRz1K5Plnqq2fDKkl636Btei6a3S6mvJ0ndz9C.+QZmgeMjCDMSC7n5ybzd+nqU9cPFs01hKi15rs4r9+A.11daWsB8+jAoMf+iv.NA34zg1fyXZLaOu6wboIq.E.nyZQ.+.b2pdvDUO8M0b6U7yXoj+Dbvn9tL9Aa9VWQ5siuG47rVaSJWA62z5KKtG9UwBfOm1PgmWG+vTc9uexqspq1o5xcpdTmxWeBCueeKf+wGbMcp.G.mIchUaYs+QkKqu8T1LqkeAf8ansdKo+ByRqCtGSqmotWMIOkLR41048CP0k5qku8Ri4P88Tyb4RsuXlTIKzGYsLssmgqKzo+n5rZUIiTdkqvayv+ZGJQ.DUOcaUimU+m9YIZp36iJck10gf+nmzlLYgxnbll1utkzegowi3pCK468DDQkdGTozxdL2oVOjUcq9Kv8as9LqzGQl3IsA728AatV5WiEw037L4ePd089f.fyWGlPntIBW2joMf+8pxUZpbZqhDbv6zwVsU871Ll951GpnaoWfXR6PyKi8idD685l7peOTt.9qdAGHCzwVOn815oi4ocLMCvUxGa8Xt5I.qbA76PGD.XYC8KV88L5VC1rpoa5g8FLkx47TVJnekIueyFveFxH7UipqtOHMKycHthvdw6rjsm2iXOiQn5evC.dRK0Nr1duGi+fKkaF9eRBT6dT82yUNsAY1d1Kdp+BvwMtsSsk1CxmuNSuRReKfeu3+bd28816J2nxMRT4zFPLT4qMyitB.0lKUVFKemsmWdmwyGK+2S+..7u5TCecJsRtUosQ1QFHF.2ke+82+2O.NOuMC+Nz6.9VNcVoqh9rUndIudYrcDaJeRE7j82N8uayvO..TD+7yOyFvzvOufoHSpxGobu06T+rNhTdoCsO..nPlKHoqZEbF8U0B4PUBrGhHyvODLUeOrM8jCE.xKskyUpRkuFuBaVZE2T0w9w5t5x4B3GtXeSv6YMv+0dlyX5ApzfNIdztHcW2lLf0lbmJzdPWxGyhzFvuBRjAmUi1Unw+Jao7G4av86niOHBimHBOCPDLseyp0OZ0ROeiNblhLN8MdUcL8GWs21C+i+KUgxXaH+oRUVpzo69YmNp19jrhomk94qT5j0IuFteGY7PUYrS6c7RUHc1QcXrCcIMN2+9f6J8O6g1WVx.1pwtLjF1isZPuCM3yejk5lcRU9.UYWUFDOmi8DLTTJqb1squ21jpX+IG4fIbH8Ww2CUK8P9bj1gFzwxs20XWlMf+rrOZ1SfvQOMrkydIgmg2GU3C4bkAAVgx0TGQInJ0I1mJsJp1RVBlK5OeQ2zw2LcF0V5863w5l0fNVp9blFy2XiyCy1yN+w2z+R0x2ex9ZmVWp7WKeWUgm6nP4UTPIKUlxvy3R5xfoitHMfmrTu6n1SY8Jk1qR5XupP5cs.HpTYyw5xR8dvbA5O1z74g2Oimg+098GYUchux3yLmy3eizX2pfg2ikOf+qRFC1e7e1pHkaxC21zyijq58Umlwzn6pqWj8UdzfLsb2+Vys+ImalcqR5sy9j7vk1SsYnO1Nu0MHdbtUEauEv+Q1+SjWpHQmnr94KhejimLeVfiwydtdP8A6xqqbEbxyYo2+ZaMttp5LhU4yMMOwL7GP5rIuj2wURmeOmJU2taaEi0To70NZsfCmaBrjeGWUc6ITcpSkC+2S+.vyQkzbS9W+XvNOmm5cu54vws1AY227mAOqtjmzg6m98pK44WsMC32K56k22zEO0dsFxjHrMEpNCrNetxxlJOb+5RaMudsuf4GNTIitL7LxerqkzukQCvYXqSS4y9uG.5HsA94DDCWMkwNFwg98rj9aNM5vUXoFlG+UqU1CfqWVlsP.3Zr6.90YA.elJ9koqXZhdo5kgGeWyO9+1G..fq2d6i4N5KxL7C7Xp9fNcv6.7DF2153qfPsIUGxG4IU8wucVVpd5U2d7z+b2c.+Ysgkr9bCjGasEFzwX9IOrl55ghX1GaT1e9A5i4Zu5tVwUCeTgccn8M7fEsFXGempFsmM3poLetDw1P+VKcWW2UcNsGQqU9LB4U2wyvRGTpUr8nyxP4lL79Ytx3i+0.dd6If9qnMmw+4k9kzukmFQxcVVzLNxZtixGKcWWWwU1vV0s0OTLMdYSJO5OpT8xuQEJOrVdo7YfAoOf+p4t6.5a+6SGJOmJLXEtNWc4i8V2uRsQLM3wrFHYjNHg3ec10WpT8uoNywuL8OKk8uWdemOxy1mizF7Y1d8zIeYWKoeYprjmLnhnVtbskXGPcjkk86QUszTlxmt5CvoL8t3NkwsG5SsLguJ6YrSYIs.QylA7qx0wkoFXipr2Q1UGzeTS2GUURGciOnU9sVaTYL3m0TkzAWiwkOh73J9DYKsjsmWHKrj9u.YoAqr7bx+pR4aBbDdFp60SKcH9kUeR+gi2FNUeo7WsyREhk6p9R0pW9DdKf+LteDql67j6kqyU7NtZ4a2U5w.dfiS8lq2U+Nds6.5p3at4ETFmnpR0Q+FdObNVbI86E7ypy6C7id.WD4xpm4roD4zYz4cWscWsCrzsRvfrTNqq8sDQW8d1uKlFz+Vmd8cZxs5R5rJxV90UFuR1dWDYVR+AlABrsrjV9zmyrdJfO0bO+WYZR.M8RTpenbGDCKcKZTg9SOhNO4QQ0V4GY7ZssS0otRW46wccJ8ScTsJkQeF9Ga5yYlZL+ac2o0rTlf7nS0WoNbpm+GcIcNmNm1IupR41m5itMc0NYF9+R2w9u6Ltumq5W0thoowxZPF68VVnSpdYUf84tZ6S6v.2kyLNipMdosROWYLZC+YaF9+RQqPYzddftXouhq5j.ioMgq2z1hG29bUd+a45SD8MkKqRcyi5NVsxuEv+3FDyzxkl+nB4Y5DK2pzgt3QL2.LqpiTGsxuG.xgwsWUs.+mppoKxi8tEV6RY0mHllo+c9V.+U6NZsipTPTPFTkSu8iHhoIs8sO9npLVGq2Tkz6zwrWkzE0IubqaLiAUI8FUKNC+YgkPKPz0wATCPTUs1jqTZo57AWemxuWuTuG9WpBSmVZsU0Z4Y9R1vw0g5Ma0tQkS6vmpq0KpPaBtEFxo0VM0xy3J71ozuBZDcU8FG.tRcudSmS6yYOuO7N67EwY1KhOSbNj2FWqMokC+.NKyds708AFB.zYW4X.57.Yi3Xqh3yDmmNWeCxhqtd5rA7OPm..Gk1MhCCz67Tsx0aU13Jmgop8tD3bM8VUPeYTc290xGPbT8AFW8z2Sy62yk2mbkpvdJOJ1yAil20Oqok2G9uGx2V5WuB7AL3pMsMPA7Cb6pRm1PFcjAaVoAYGcdOec7tMl1Jn+WudOvkNb.zR+bE80N9OOA7mP64KWaPZwWkyepbZCFncVhrtOK2UNsUMiCzeb.8iaicZ9Yla+0UyWuDg7aA7WTYsQPpkm7JmYuCFHyCZfmmxODYJaRDM2L1Oc7BS+4mNq+i+4TNmr612C+tC6yA4KDcqckybGke26eGpKwm3o+Z8.jQmQamZ+kL5NGu4z5Hlg+DasF7DDCOon0Y7U+QFlNaCS+4odltbSAHhhTaT6Ybqqs+8W5mKasEGswHcklaqXL2OeG7jawpxGveEKPsmFJxVievU5tpKnNG.vxVZ+Lumet05i03dyA4QOi+6oe.9FaUn4JKT8T2Knc5qBB.u6a6Gv.txE86ymJJ00maO6+o+4n9.U0UV19sY3OBmjfGwZOuW4xFIJMhtFesSf6PWOIvepk0eUeex7jeyRxTYiLEawUq62fFb+R+R5WCH.7L1a6u93i4k7M.NeSC5WasbklMf+pUnyfMAfqPk6aoxoM.dRKcMD95k1d47k9Y3m+nZeov8LygYOMBjC6YoWlsanA2rD.UQ1Z2Zq9TLQkbVFFeRpOz9XYYdqNj4mc9i05nRmXjE68.hZum3zQyRO2i+A.Qyv3H94meR2XJNxVgC9Tiqa7yO+Hf+pXtuFX0arn5ouratNgyVGyzWmQ6KQNnYC5DHyLdBX+rj9SlibKJnwPdZJCRFc1A4Z4YxbTt.NF0WfOyayvukyW9oAQ3eosL1qqprhxfLk9poKFWVW4dXdmYciowyaF9Snwyx+zBGi2uFvSKJG9hpOvdb0AkGkYz0Ge.3tM8fB8HqX0w++mYZ6suVq79cT19s.9OZEPdFUngO30q3DDD.UwbiiaX7cZukmzR2PHK86qRDiEOEyvO..TDKEPg.MHRpX.8vRVq82kV01moY2C+UiFUf6WTaKIpOWYTkZa8tJWDgxeUJeiOSDJGBPGDg1aS+0x2SOvkHjIBreOcaFcSFumjgrZOiIw3V.tKZuIFRe.+a4pGnoAxd97NENeWUmtaUeUm8..+wdGia0FK7zwBXrA2qE2C+Yof1VEXb.0TWxWg86IqubG6OsLIS8KkkmS.xjoGfeUtsVA2+7lMf+rTnauEfxzfqXaWYdoxJvwni7bZOmVzUrsPe7If61bs0djY7V6UbTSKy3T5mv4IW0FZT8735mgo7A09in7NnS0Q2Zv0QIO4tzszaULW410tBFG924YbVsul07xtz+RFL6d3+2e+8+8CHhT1DTOfuS2K+jsAOuGakl16cfNwyZyR7z78w+dMd9mwU7NuR4iUr82HYbr7+96u0+P6ib4HMlUoF95LM5+47tKexTdl1XqI2bF4ydV4i64OC0o4Nocl3P.+..MiA9W22AyMHaA4mWeR4z0xqqZ49H4JeGm87ur+7mU1C+.WFCvjrnS6mcpOs8VCeZaRtAqHBV57kna1Z7E2w6DA7C.bw53fbNBAfbduCNRPhCCDsxu6y5UelO.YNcG4aYoN6bA5lkm8pI0A7aFY.fnyfa11UecqlAe66fOIcNL36JNH78bUnUsz7QTw7bhqgxZcqLWT5+wd3G.tEQui9q34K5oYxuu8vXa3+2nLvz6TGSyS4cPNko7sN1O3QZW9NNPMWcF9qRFzcjNdhuT5SuePdZcHMBbuNqUNl1m3Nb1CRriy5aDSy2UvbYJnQ9WQqL6Rxxy4Y5aN6MNy2Wi+yZ1.9yRlSjZnJRA6mY1lFPtrTc1rzOxbNZ6PqcGXS7k4xpWgHF.7UpSoU3IUswJLmi1++Raopusc3o++9V.+Y3E+QeY1w8r0PZtCoUfmw3NjVpypNzVzzNlqbZMiFxOp1fMu5q9qL+t4H5TZkq0c9wdyR41NciQ7o4+K0G0Y9tIUGZemUEoJU3ZIYL88MeHmLldgrZbcu41+uUH32wO2y8QicxCmOUJ+wpHAH5NxdXuRsOeDSmTjq58vaA7G0YC29T6XxT56LxayT5Exr8TecsOBPFmw+4956Y54eN6YaKj8zHeG8qBv4Ys9cuh3bG6sSo+H139U8kr8ExedmYdvcbJWBc0QqeM2R7etUFPl7yO+Dx9HoWxXcGNl6nclg1yzlF78th1kOy+LS0R5+JT0ufcFRSFzBjCe586cEUs8A9XUIcv2yAnacod90Q8FFrzV+aKWUbouMC+QiJNetH+t6pOrgH9Flw2o+f9Ha42Y64cMykVTW7bk42giGzYlSG6QkC.d54oRkSqci7x33JWN9m0e1Kds7U8F3qttm+U0UtQzcVmGCudoyrnn6skrGYqLq7z6QVJOrjg9Qyd5XNYHMcViEOCoUnZldl+7M0kOiXZB8R5OKCJ4IFrmOJCQiCVSnVTGjLqRkcOxX9pT5Fpfuc7wmQc5EWR+ZvX+hxW.e5AvRDdlliOTQ83f0jOk7XtKJqcLQcLDeirscUNxRxOJiEs6tqCbQpsytcpUmgeEnhssZ3m3ZOUjyRdXlF7DwjYRF3prz4UwqW4ne1oOic4rUHyrJb4aLt7y21F0v++g+P66Nj4JkNfkVVTemr2mqn97e27d.3Ljgf6h.yTbN3Z0qmxT9cldVinu482z1FDvehM208fO..2o6pblxy.TK2Q65a82QU5aQfUwyUjmT074rmtN6m+qXUOF5CsONlwKyqrW4g9wxTDfscEKW3mXLCW8em5Kgm1YMtlLOl9wO6CwmHNkkcUuWlMf+oWk..L0ULXJCPiHy9xjn3LKK18IKnqoatOSC5coeOUM9q4tW4m9dH6o2o669webi89++YZ5euuEvuAy.7D1yRuL6cHv7xzW7OCOiaYOCBoBoypaOAQ7o+4Q9Ts.npp4Z+8LOj134LW9XT5u0R5+UN16Ey82A.UPVB1evZs+lkzQVdNYaaUdbtec4+42dOeBjWGKqcqQL9eW9VMrzL8e24ug9P6KqE1y5yM+gOlBvR5xg.F4xbmX6imgok98..mmktFMG216SzFbnC3mkoC6qi2sv15X8DAymWiu8Zl9umcyM.ykFzI0g7THedp5sB3uXx1Ri8JE02CQ84BNhyLPI0I3JszRjsBA6yx1a6JYs8GkeA1q1GveVaneN2Yi+eyeWU5c9Ux6IhjqZo.Wwx4FHdLszdnT9UcsU6KYt8mL+rCbuV7P6KJMj3ZPZYO4g.QTJerjL778zGfGvm3JtNv.3pz81YrxOyopjuIFtmwzwpMa.+Un.VW3p7Hm15TZUdIQwb2Q2e5LiloqeuuQ0SeY1zSC6JOoB6IcorJvUpxswFciae+skzeDa7+pdlhXZ8SjwSc2q74M5uK1SCeZb7cQNecZPDUL+at2+Kkmr1u2HmOdVpX9elM2IW+ftmW08zO.cvayveTWlweyWH5NW9zcX1qNK9peqK5kkj+M+cm6R+2udEm1SOSKsJipXZcu5bZOx5T9R2aaFhJichwtpw5OsL1h6g+H5SWFo2YfS24.Jpvx0y9Al8Hh4seR41pt8apV54aE8OVWmMcqSIuR4UHhpTcxsFqekRqQUpB3ev3BFaMn6tWHJCcj+oA8G8zUGbGeo5HlO6qyuLmEEDQi2RICkQyP+iv2RY73YsIvrp4WUMckEoLf+inpynV0rzGwQ9V70skm12lVqbYZs29GcO8mExmH6Vp+WksiqsFCg9Qqo49.y24XmKe.+UUkCvRibLPYg3qS23D64iaUozaUIOhJYt1k7Q.xOq.oZYoa7n6JdNA7mTcaVUi.M9trO870XO+YFIpycbUqdSkRK.4m9kpI80TSWw3k2CA7mTZf+9ow2scFeHJumI5b3CAjMU6iulQGY7Qxu5g6JOV.+bIrGj5qibnZN2+OPjsm8eoxy7zNxGeU4U3dX04xf6tc2EC3WgR9TB1+bTg2eSaGYtzTVZmIKOm77DzOQvm7wWuZpabthR9J6i7KtKSam8+l62v3CS.Xu982e0X1Iop08FJiL9ZwZ7+rCV5PtqSuCxpo4QUsdJ0wVssb2kgUm4Yoelm0QJ+qtBmoVrj9Uo4d3879zoqQm0FbgAdP1oLLQlxm.DOOQL.uEvuYvnVtx7u8LXBke1updUlw5LnbfmhkXO.2i8LIXmU6wS+65skzOWuyX.9OYGzV9wem87ty6W.3SoOjd3niEzG2AdF6sM4qps6Vrj9ilypA2oGHOS+y8rKzX.D2Ky7ReHeN2bH2B.6Qm1VmDGoOf+0NEZ6Tkmqb.mFHKbcpT6TUJsLmkZmUajv77gqg2oNA2szGv+XcsBzV6IjO88RTFD6ROGcM+l7qRCBtJoCfym1Gtd6cBejW.4vULFwREveGs28C9QJ3D8.8m9qqSLtCV11LXnrfklIPTrT6NU5CLSt04Uh8SS.+MwdZvOqAynyLxFkWyso2nFtgM.dBia6YoO9n1j3ok03KpDA7iJhbYFFnwZGpjYZvHmwr7mozKuat7O4o.QTF6mkZ4p11wU1Y9NYXbqyFvuW94vQB7Xt7TA5ycoJAIIXed8Z4YRKapR5..xIA8eMF+N8me9wL72Y64i.bjq5OUXo5FuhE9j++ntx1x5eoxvYKc..v51Lf+nOKvY7vn6Ir2k0029quzeuWspl2V0zU2T87w8ztP0eGLVURqYJcrVYvwGvhi+m6UldO7Ipd560KsQkgzVmpS18xiS0oz5dbFuOlVF6+95+DCHEblmYqA.5jgwCL9edz9B02I.jYkbI8qyYxh0tFcfrydyi6vVWGYmQ4PWKm.PVUx.9mS26n1ftiq0tOuIWrL89WZ2gmvPapCk+1yx8eO+YRdsU9r7WtS9X3b2ZS.+cgFPxk41aoC7Q.xG4Wv85aCleu8Yp837S9GPWk9.92SG5cnQdA5mWS2ioudYvk.rGSGCvz8p+V+y89mu1iANSZSg6TIOz95jwKaQpCcDPkn7LWko8+McY7u0+bu+4qeV.HqdaF9yXmZcbvjYLe5Szk8b2RKmeyrDYvVyVpxwbUVZaQsm8rcW5GEfnx3CtGoeI82MQa.JW4fl1ydurJMRLMcL2x7Ghpn0tD8wbyb+bKy+kVI.PETgIGwGgq1j29rrj9Shntz8e5mom9u+qV0SezGJKyUXqOV5YFDgxvDQm0ASYVjkOfA+U2JiFQB3O3hZf9WMo4+nxcr0w73JR9HOo41NTy8OOCUt8XxoidVTDcaUGScv5JKkQyJKo+.Sg+9XosmPU11Bc6iY.bOrb8oyp3xf2XCpkpU9LqDve.oxQuzg7acfCbE5P6mvRT9GXOrj9Cjit78EDUMHeDfOi1OA.VmY3O.9zuPqur6ej8k89Z60zLmt...fmk.9ePea.6Ubua8IxbPwU3pzAfpS6w.vYY53+u59XDv+CvUDDCLHx5wGwAtW9ISjcUA..f.PRDEDU32rWKUNQay.Ws05mZ3W6pZKR.+2HCHY+L.Nxn8bWyVsAVptJQvUVNrZ0Y6L4k.OgmdbRB3+F7zYx.WO0yA..hFA7egti..1yWqNqAhrmYrwWqmroqyxe0RyDOWwr7qbKQlUXEQmxna6NdGIf+KvZm15JzeLFrEjepGyc4rF3jxrTIJOSzoL50R.+mn8bXLTE9hcveotfNqyrgUcx3xwYN+b7GXetz0V+7PlX7XDcaUFU6tWOA7eRdhFaexJH5bA9KC3hLanujpMnqkRWa8yCYixtDcJittqdbj+2k8mbS7yO+3ZdA...fC612C+lop8YOui7dDf5ZsyqE.3yXhzfy0aA7KH0048C.75kAeBvYaqyCKs6BGmkz+Ns1R2Gf8xfU..dmwYSUs1X+tix8B3eCBzG..fmmwjCGm.9Wf.8ANh8Ly8lcefmvv3Yl9OAf5S.+SHPedBFLVM76u+tXP8B1G3oL8pHT6Q.bu1p82qrc42Nz95p6J.qy7VPvgWRcXvX0h7O..fwdpw4O6L72oAqd2yn+Y820Zyj3b+dA..f3wJ6jqzayv+YNCzQVlSieR.7C++j4zM...UiImiqT61C+W0L5eGUTOxr5ek+Y..jcNyT.fN3s.9qbGem4xoes+ruhfpe5+77QB.nO5vAXqyLE.nCbn88A1ZPPYYPRGY6ajkzD.78DDL.PMztkzeFckC7xf5...x.iaENNA7GbZXC..n51ZLuFSL7Yrj9AtbKskPz4M..uds+sLqwN.GiY3OvtqFzzvIWo05.2YCA...WmTGv+QCVPfsv8ZO0QEzO.OCs+RFobKbLoLf+wWWPOck9p7QDpR5H6FJaO9G..eqwiaxRilnw3cfqSp1C+QrwfH9LQN7IWIhFbF.7IF5+P+H.zKoXF9OqY5Tv4DE+7yOezftpPYXC1D..f6Qnmg+JDbymRPQ0z3xzeZ46O8iEDEctdM..7505iGJyiyi3Ijyv+QmQ+k98ZuPSUk4xy5DC.fNauWAgvYHbyvemJf+6u+1pzamIe9u7t.3tsU6N9Pj.2EiC5Ox9JVMSBS.+WQg+oEhtyJX6IX9stexuyJAZ745rmAZtT9cjJi.PFo+M.hGig8971R5+2e+8e9wU6LVt8684T.zmCUP2u8dOzO9CDcjqbxJWNCf6h1RgmkwVBWmGaO7Gw8U+U1XSkZHKZ4aY03xDiC52V8.f6Uk5iFpN0Wgi41C3OhA5OHZOWQ64YOzH7eczszwQlY+i72ySZOkGTlA..iY3eE4w2Qtba6g+tWnMxo+y7YKxoy6lYp+O7dfpZox0cZ.o.bW5Raqqc1NAehKOf+iLPeAF7tqtBu22WGua+KcZQEobM.mKsq9uq3SuO3LbYKo+OYo6K.o4cUuW79NGzXO..zKF+GmkSOf+HuG8eJmwMdvY+NUdTdHuB...9Dm1R5WPIK6rd2bVKsG4U....02WOC+lQ+6027t9pyqrzi....hiuZF9En+yX5684tO2m622c+bA...+0dNjxMIZbltrCsu6TmCzbZCBi+uOiyN..fJS+j.PkUh.9e8Z8f9Ge8V.2k6ZPjFrJQwv1FZte.Oks932JeBbm1SaNZWhyziEv+UDjxRUN5d.QcO8Cb81ZvIF7BOsk5KbOKuV.fr51C3+J2e4aEXq.eA34HnJdRiOiaF+OOqa.G.fH5ztV91qqZ.eWYm0e5W+2rFvUWFvfTIBzNGQ2zf8GuU+FGzuf+IqbHvArjuJf+L13wm9Le2++c1hxyQGcUA8KOEf8YtC3149H.cncUebidJq42JuBeuaeF9gN5rC5WmdvyxYFS9s1sbSkMcaMPejgflmqsUqhL36TlSoeH5NqNYidm0P0smaEF.tKUocGG9qv0P.+vM5aCVWv9vyx.NA34nMX33rj9ga13f12SGWBxGhOGRq.74z9IbcVLf+LrOefraof+U2K+zFZuXvp4jCDr5ant4ReTN464i5qvwLa.+SutZ.tdpqUKxOqooAML8Jci7P9VOLts3t2tb2S+PWM6d32I3J.rWcpuhoAGJXwbS9IvcaO8Y1o9U4581L7OdV8MC+.vYoB8mXF8yqsFSiw7.bWzVC2o2B32fX.fiZq9Np1faLyv4S2JiB.750ByvO.vYpZyd5R6k+LZozQkxuFTwzDzMpGCGiqkO.3qsmfcqTP+UZF9mlmTk7H..V3P6C...hue+82M+PcQ+C4E8mOHyLC+...jbyEzblW8Qi4CB.eNA7C.ekpLfx8Zs8quAkBDIYpMoL8rBYh.9A.NHCLE.fLP.+vCxUDE...bUbn8AAU2Vlz...v4R.+vCQ.800b4s+7yOxyA..tUVR+.bA5Tv8qcH1A..7bDveAr0.ssWvyqe94G4eIyV0G6bdZWS2..vSwR5uH982e+e+X3+l7S9HYgxp..P7XF9KfoCzdbP+VlswzdyW57rAmQcu9lxp..PrTx.9mNn6NOHzNm1ir89wXj+kK9HaPrsT8Ss0B.UUIC3WG2TElgefq1Zejppz9iyVC.nqdKfeyPE.POHP3+pSoUpIqfEf4TxY3G..fNYt.6MId.Nk9g.yWkG.fOkwQ.Hf+hyW1kH5me94+8itX7ft5T5FhLACA.Um.9KfkBdPPEDIiKO96u+9+9QGL8rQoKoaH5zOI.Tc1C+ImCYn7ZqCHypkuVszyQLMeV8V3YMz9qCp3doS84Bv.A7mbyMygF7RMHnv5R9Jb+F2+3z+I0majBfmzd5u4pZCxR5uXL3kZQ9Y9X.iPLYa0..Og8Nd9qZb+B3u.LvkbRv70j7UH9TOE.5h2B3Wmf4ydVlZ.OC2KxP73CkC.cgY3GBLCJEfu2z1Rm6ito8V.nhdKf+NcUYA.zYa0eeWFOPWRm.P+r3ozuS6c.f5qCA65DZm8HqkCFeESlwmefqkkzO..P6k0fkGdty5yOv0R.+.7.rBpf6wSecHQdnL.PEIfefayvfoF+O65.rLSL.DKZWFnhDvOvsY5xNrCGRnK8AM55G5.fnR6x.Uj.9gGR0Czk+Xo8Vo7e.tO6oMWsKCTQB3GdPqM3BC7nFltMF...5iiLl9qX7hKds7Yvov8Pf80hqzT.hGsKCb29z1cN6qXyYmgeMJBvmaqUtgOxC..TWea7zm4Aa8ayvuf8ymslQQAW.2O06..f9IZwSu3R5m7HZEp..hBayF.dda0NbElnjqnulg+L+l2OkIf+4dAWgBNaYOErN68AxcYtB3iSuSGDWFSiPEMzlSVa6A.fySkiWICJS.+JfTGSqvu26wbA+CwvRWEgvSYOyxuxq.vm5pWIYeyGDw0xWSjkky3YcElkkzK.QwvADz3eTIacfYVszK.YSVaG9tdt+z+dJyL72QYsRwbtp87hYrAf8oCsWtzJAqR8mBPjn80mmY3OwlN3rNLXsiRiLwVEmEQf3Z71MY7JJS+m.PUIf+++au6skbTbkE.n1mX9++k84gdyzLXtHvBgxTqUDUT6plt6sAcKSIgHv16YXORJ4y8u7LAG06KQ2xsE77uuLQeI9CzBqcfRtL4eFWJ+ANqHzugD9CrLrB+k71UXdvYWYkXh38knaq2lBG0oXD5zDHlVNNxZqvuwKFaJ+ANqHzugD9SjLjrzZI0u1JDO+O+Qxv8kH4W24IVsef6vxUzeYR9QHnMtNku.2gHDypD9GDQXft01dkK+8See9os7Z+LOiHzoGvXaqcJlIaL+1ZRdN5M3.v0k81VQ35SB+7X1Jvp01N3qsMLWyVSB.2uZGnrfuAtCaMtfwKFC1YG.0TDhUUB+AWICTEsAy15rInjAmWa6jGsq+H5rG7hlLFfmxVOlXFu.fmUD6CNBel+mm9C.+tHTQ6Hm48g7dAk8qGvebdkNylKCp9L+8TNBTCGcVvn+FfmvTeRYs+myD2G0mU3mtvVmh6GcJ9u0J5e1jJ49r1Nz3JGje.7qVamho+Efm1HryGO55K6W+OII7S23nmo+s19kq8yduJ2O16sr..szVuJ9zuD.2KuZleNqlvuYXgdydI8u02EL28y8UfHY4J6u7vAU7OjMqUOGZsrW+qUicb0++4qmgeIIQV3fXBfxLR8St0qjuQ45m7Zs2xQK+uqdNLd18P6SmBjEFjqcLYgP7L58ON5W+jCa8VNJhbvZNlhb46cG+6ubewozOCgn14QDIYe..9E681Xh7J5ku2UR++58EGZe7XhdiZ...nNrnQeqF4KIgeROSr....b2p4qXwZ8uiD94QIYb...HS90bbpYNRdF94wcmGxElPA...n0VdfSd1+N0xtqvumiBhrHlr+7Wkf...P7MsU+mxOY92W9eq1rk9oKT6J3QLY+Wud8Um.8tV84LJ2O...9uJMNtQIduVGu+laoeqvX7rUYVTZ7Tqs1eTtdoLJOA..3Z9Jg+Lmn+62uSYxCyKyVKo4Hccu7y4S97tPYtyyfA..f36n3EEK+8IMGZekjvQFqHsLY9oed4j.DU6MA.SWmQ95i8orE.35lGWnwT4ooN3yHEOC+kt5hYbUHW1vYsj8yz087C0h0lbCdF5.G.n+DsyFHf5KEI7y+0VmBjYS1u9hlZd5hdmmTovcyjP1271PA.FIR3OwDLCOgeMQcI5SzoNbeyjEC.ijz7L7WpQ5YXZTtNo+r7bk3r+c...fe2vkvOPasVh7izDuA..vSwV5Gn4jrO...2OI7mTue+1ASD...PmpE4oIg+fasJIS+t4GLQR5G.fQ2VwCINIfVY4qP861v8L7mssR7dWOF7JV1p7Ja0YA.dRqMdqwZAZkV2eyvkveFMeE8kzXboLhro0yfM.a4nEAwgIKPVkhD9G8sr9z0e1S1O6WeP1r70y3H0VcztdA.nOkhD9e8prj9ybvWY9ZaxHbMBYUla+Z6AC.TN6.v1JMI7+5kszN.zdFeA.nbF2rsRUB+udoBD....75UBS3G.feyxcKmISG.HljvO..+GRvG.HGjvO...zMF4Chan19+d5O.....udcbx9k9mA3OjvO....jPR3G...dbV4dn9jvO...DJlb.nLR3G5PSChYvL.fe2mOe18fdyg.GPqsLd+6JtemR+PGZJvCAfPT483NPOReQ.8hkw6eW8OIge.n5DTM..77jvOgiUND...3XR3mvQB9...DK68LpK996iD9A..HIjTE8niNP5d+9s5m2DI7C.v+ZdPYB9BhmH2t8ymOEeRkG4qSVmj9uGR3G.f+kfs.5c5mBJ2+2S+A....30qiSlWx9wyc89kmxXE9A..ftgj5yky7nZP8YE9A...3VHY+mkD9A...3VXGa7rrk9A...fFXqc7vcMwHR3G....ZfVuiGrk9A...fDxJ7C.UyQGLOdN9..f1QB+ISqelP.XhSgW.fe262uGxX2Gwq4VXH1R+iRPn6ccNJ2C.dFk1Gi9h..1WFS78nqoLdM2KFhU3eTp.84ymulQvoeVP1...vSYTxIq2LDI7OZlmj+ZSB...P9r2B7HVPXLMDao+QyTG5y+tU3G..xqih0SrfvXRB+IzTG5y6X2r5B.vbR.LOTVBrEI7mDqkb+xmke..XhECX7HdPX7Hg+jXsj7W6+N....iAI7C..PR74ymUWnGK9CLljvO.7yDHI.OikaS+2ueu5V2214G5Oqc1qUaR3OY1pxhN4A5AlX..tWd7Ng91zjxMOY+6r8oD9SjVLCQbelW9s7KHBDLIPDkswYmm7fCvYne0p1m+ys8uLM0ZamKhiilrl6dl+fZQ8TfnI58a84ymMeULKdPn+LuMZK5+wJ7mDi3ozuAw..f+q81cfYLdPf8YE9Sj4I8OBqHb1u9...HK1aw5DW+8QB+IkFM..+0ZAZZrRxhkaqen2bT8yQXwJeJ1R+..7kLk7vdmOJY55jw1QIKIYJ5c5O9dXE9A.3KiTxAixJKMcctLn5Q3ZeTnrDXIqvO..okmYz+Xs2FLe97YntG.vHRB+..LjFgsO5dO1Biv0OPrneo5SB+..L7F0fLG0qaf1Q+LOKI7C.PZYKqCvyR+vOKI7C.PZ4Y3G.FYR3G.fzZuj5Wd.1kMktMZscaAnMdhWSrds7AcfLFnI.8h0dUzs72mwWMeaccu1eNpiLVOBndl2+v7WUp2Y+FVge..RsQ8Tp2J72dR1GnTS8Wb28aXE9A.HsluBJiFqvOPuP+LOmTtB+KGb6NelH..neMxI8ZE9AfzsB+yeV715+VFGTG.ZusRTx3LzCF4I6..9ihR32APB.v2x5Xii1DjOJWmLVx9agBfxbXB+Q9zqcTel8..9EQa79ijsqGnDp2C750IeF9k7L..DGGkzmjBoWMcFbMewGkKBbdm9Y3OhqzOeqUu2GA.3YYbdhj8NGtl9eqNMTtKcJ8a10huV8deD..fZRtHP4t7qkOMz5aaU9r2aw....dJhOEpuKmvOOu8Rpe9J2u7TZ0VgB...H+jvePM+Yve5m252u1OC...Pt8SI7aa27bluR86k7+xuKYe..fnSdHjAKeaTbGrB+A17Cdu8Rl2AzG...Pe4ymO+6W2kS+Z4KRFoY96nj5krO...vXIcqv+QI1JwW....FAoJg+694e..Xo0d96LVD.m2YVXNKhGTlTuk9A.taqEzo.QiioImQYF.jQR3G.fgkD8g3Q6VnboIg+R29jd0zAOmsZmpMI..ud82XBVFyfXEfqIMI7Cz+LXM..kPLCPc7SGZeZHB....8oTcJ8C....7GR3G....RnKmvusyO....zutTB+8Xx983mI....XKue+9e+5NLbmR+lX.....5A2c9omZE9+74iDlo6bWyFF...bOlhg+tWg6QWwqveDRz+ymO6VQIBWCbdJWA..HVlhgWr72qCWg+nsp9y+7pRD....ipz9L7Koe..VyZ6FPwI..YTZS3G..Vij6AfQwkds7A....z2jvO....jPR3G....RHI7mbdeVB...Ll95P66n2k8DKNXhhqo1gJCIR1a7C0kA.f1xozOzALIajApGCz615Ux362uMoj.ojszO7vNJIIIQQVntLvSZq9fl985iBHi1bE9s09AfRY7B..J0V61lQxzNKZ98h63dvlI7K3M.n1rsYA5Y5iBZCsy968f69dwWI7KQe5YlMP...fx3P6iPQx8.QfUID.th4ayaiiPM3P6C.nxDjF.bEsZady3PB+....PB8UB+e97wLJA....AmU3G.9YlnX..n+Hge.nYLw...P63T5Og15Uqn.sAtSSmpv.DUhUBHajvexHXafmzxj9E7L..7brk9SjiR12jAzmN5fxTBSDMS0oU2EnmbTeR5yBHirB+Izdaq12uea.sNkxE.fmiXj.xHqveRLOAeqjO..SDWveTx8A2q.xlUS3WmcwlYmlnReO.TehKv3K.iqu1R+YoCwQdaYkkxvRMxk0YfC3M.nmHtBdBS06VKNd0G4Wj1mg+QtgQle0XMuyvox3QtrNpLXF..7Whqk6xWI7OuRVVSZj3Rmg4fxO...te6dn8Inb....Hl1bK864WJtryL...xfRhqUNKv11cE9k3XLoSO..fnqzbQjyBrsMS3+ymORbLPJ8rWPYJ..iFw+.Lp1cE9IVNZvLC1A..6S7R.YRZes7MpLHE..PzYa5C0gU3G5XFrC.nNJYQQrvI.YylI7KQCnsd+98WeM86A.32MkP+VeGfrY2szuWMeP674yGs4..tYR5OFlhKB3270J7OekEAZq0daKn8H..iFw+.0gmgenSkoUbX4jWbz2A.Xrkg3efdfSoefawxj2uZR+FvG.f8HVAXaGtB+VwMfypl8anOH3YoMHvSQh7vuyV5G5bQKX663yaztG.Q0x2RHudIfafm0d8A84yG8QAGPB+PmKRCjclDyiz0ELJlBdV6SfdyZmsQVP.3XdF9AphyNn6U9yKID.fwiWghv0YE9AdDFrF..f6UQI7GgsKSD9LB6YqS09H3JeVa0eG...FUEsk9sRbwwVIDoLruMsc0mus0W9LpoLD...NihR3OBIaz6e9ZE2Ghooj8e8xpXC...0QZVg+HLoDvdluB+dkXA.bONZh0MtKPljlSoecNSFjkSe1oO+i9tUviXC.8kRFWxhHAjINk9Aph4SVwcjneDC9Z96y74ueyG8IBAfdVDGuAfsbXB+5zC3HqcFDT6jZiZRxVoHHNhZ+LTWpG.jIVgefe1VucAX86GtGkKymjqoun+sV4j1l.8DimPMHgefel2x.ey8iwwZO1Fz+TNAz6zOE0fD9A9Y115ea9acA..9clDc37jvOPUXP3+q0dEKB.v0YRzgySB+.bCrB+...OMI7C7yZURsQJ4YqvO.8mHMNB.0fD9AnxlmrufKA..dJ+yS+Af54nURThGbmrZ1eaqj9MQ....sfU3OI79DlrKZ0m258wtIEAf9VzFuAf8XE9SrkIVXUE6W6kDXjJytqU4OR2CJMIesGA5EiV+Q1QZ.8tZ1urU3G5bQKnjZGzXjBB8LkUB3DnWDo9Yqgi56Uey.s1zNCc5qZ1urU3mtWoC7F0.VxXfEyKKNyoUeDOn6tZ42zeuouGoqY.hpLNlKP7cmwAlxD9yx1ilyIZIJdFQ9Za5ycoe9iz0YMCbTh+4gxR..5Ealvej2toBxB3tcW8OF4I2YDclcvB.WgwEFCKek9NebEk+7K95Y3+ymOmdE4..FUakruIA.hqdp8q3wGCKy+R9XTKNz9.3jN64JwYGrtmBzjeixRHljjE8.0CoFjvOcsrGrb1u9Fc1t24lxUHuz9tun7fQvcUOWB+z0x9Lal8quL5rcF+qmh+.P6Y749hxCFA2U8bI7COHI0A4m14..7TjveRTxLBY1Q6OJS...f6hD9SDIOBsm1c...8JI7mHGssQi51JszDpj3EOE08FOQs+TXMiT8Y8WCzid+98+9UsIg+ASTGT+nAny9.3Y+5KRVqrXs1U+ZYlx79lxGhp4AUN80nUedzio.n+74ym+8qZ6ep9+h7HhZh7mQVG.9nWaaY85NpVVVsUY2u1lbDCBG39oek+v8AfQgD9gNvTfGyeusKXjX3nIrAzVF.3urPWsUpS3WxSDMS0SUeMNjrOz+tR6T8CCP8UxYNl9eqquR3eYgPjugK4I.3tTxt6v3OOuqNoby+6obD.hpuR32fZ..kwizQeqVkMS+6HFIf6hs49eYU9qqTuk9An1ZUBdFnKFx3VSLhelWiIhA9qrztNyFgxG8K+L7Z4C.3BxZfKYHny6prIqk4jeYncMwm5gOCI7CPmw.hv0clsE6UNqejzO.DIR3OIjf.zNZuwYHAw9wxxhoeVYD.jUR3evHQEnNtq1RZiB0m2ZO.vnRB+IxdAx74yGA5.UVsaSoMJ7aVak5mePaV6Sse.fdmSo+jQBCPaUqSsescge2T6w4eG.nGsU7i0drKI7CvOZpi4qj3uDRf5wyjO.DA6MN0z+sZEinD9gNjUnJlTVAOqkqv+xe+U+6e1+c..1RqGGIsOC+ue+9+LS+y+YnGsrdpj8A3b1axR25f6a9OezNDPbD.7aJI1Vw+VWatB+0dqDzZy+bG0qAFKpmB4j11sydOC+K+8WYk7sB+.7aNpOTiYVealvua1..aKqI+s7ZJRwCrbGRs7ZY4ueu+b68uO.bdkzGpc3Z8k1szO.vSKhAsL8ZbM5uNW2JnwRStGfVyAOJ2AI7C.PJInYfHYqyZjQi9tqKI7C.bSDzRaM5AIC.rjD9A...31XBveNR3G.3BD7x3xNI.fyQ+lOGI7C.PZHnR.f+RB+..PgLgB.vun0iiHge..REIkC.QUses39OU6eI..nS74ympeNKXhDxu2ueqbF310x9YjvOzoDzA.+lZlzu9iymspaL+2qbGpmR6SV6t5RB+PGYYmfR5Gfeyx9PO6D.nO3bxaYC3YbTR+5ys99Jg+kE.Q9l9TxRRZhnP8TfdvxwOyz3n6ccjoqS11YR1WcBntNp8m1b02gGZeQdFPmprnRC.7Dh53OKG+LpWGm0nbcB.iihNk9ibR+..2AIGB.TtRyoTtm0kWKe..WzdI8aBA..3o4P6C.3GHwd..5UR3G...5dY5vEGZEI7C...cOI3CmWQOC+ZbA..jAhqEXj3T5G..fUXxA.hNmR+....PBIge..fgRIqbuU2GHCjvO..LHldLMm+8ouFM6kPuj8gmi1e0kSoeflYu.J04N.2q0R1e4+8Qqu3Q65EdRe97YHmbwmVZS3WhEPe4nN3Gw.MAn2nuXf6zT+KaEWn9epuCS3Oh2zkXA.P8Xby3yppAzSLlR67UB+t4CTakFnojJf9j1k.b+lhCZdbSS+r9g4pR6V5G...HJlRpeYx8R1megSoe.fJxVmF.fdgD9A.pHqDCQmIsBf7vV5G..3eYRqnWs1jQo9JrOI7C...cOI2CmmszO..jbRTBfwjD9AtcBzD..f1SB+.cCSL..2mR5iU+v.jKR3GnIDDIPu5862+6WYm9hAXrLjGZeFridUIAaF45ue97YyqwHecADaiT+OGMNy62uGp6G.jcoLgeIULVhZvIWckjl+2KhW2Q7yL.ijnNtJ.7sTlv+qWRpXjDwx5ZssQETFPqn+F.f3wyvOzX09YDcTdtSAdVR1O9LVA.iGI7CMjfs...fVQB+Pib2I6axD...f4R6yvOiAOSo.OsilrM8QA.vSQB+IxHFzYTtlZ0puaBPf1pj11ZWB.vSQB+Ih.JA.XK68ZKF.xIOC+vC3WmbFStCDKRxB.fmfD9g.xVDF...NhD9gGvUWsu4I4u0+FVIwXP4DvSnjIK1DJCPa7986u9p17L7CM1u7LTNsx9682WfZwfxo3yj1PTs23H5aBf1oE84Jge3lsLnpeMIgi96a69CsgC.sXaDey1LW1u9.f+X31R+BNiVSPU.zWJ80oH.Og6b6cy3I0qv+Tij4IbI4K5AVYP..f0HeEpoTmvuFKzqtyj8UuG5OZW1OLYq.vnwssxT...H.jDQAQEY31R+..LtL4K.vHQB+..WjjGA.nmIg+Afsu3yqUIEH4CnsJs+UG.SwjxK.H5jv+.PRf.TeWMYPIQFGF+D.hNI7CMh.GgbnFqTuj9iAkS.PzIgeHILgBv8qlI.JYx9m9UoVzdG3oj5WKePu4ymO2xf9BJEte2Qa22ueq8KzXyaKu03xZWBzBSwArrenZ1GzlI7O8+o5vCpqZmzu1nv8qz1rSsuOS6bI82d20juRLrr8l1e.OokSBYs8UB+F.DteSMl+k1aBPIllmLnxv7YpMswRiOsOAf6VKFq4vszufRg6y7D+WthSiX6tQn+loqureclIWI48ytBxiPceXjo8MvSonmgeAh.2KIA9Gi90O4gU3u+o+F.XD3T5G....RHI7C.rgVtR81U...TaR3G....RnhdF9A..f3YscOjyvBXbXE9A..Ho974yWeEMKekmtbRL7HQAayJ7mXd6J...DUySjujj9E2K7shR3WimXR4F..TtojHEC0y5pqX+7+dJCg+vJ7C.2p4APaEX1l6KP6XKf2upUYiwaf+vyvO.bql+LiFsfuh1mWfiURBklPfmQsuuqbDJXE9ErC..ifQcEAG0qa5K2Ux4peSOau580pd6gqvuYFCZu2ue+ueM8y.4kfQediT+sKuFmdbaFgqc5SWot2Y52Tca5QGUurV0a8L7CcnkChIY.34LkLD4yH+9Ieq5zVMTZsZb.8U5ed0soWzx3JJJgeMPnWzhs8B.KcmI8quqmyHdu2jWAvXwg1GogfX.hlQLgS..JSMxuQB+jJR5G3tT6jykrO..2MI7SXTZx7R5G3tL+UL3u9uSjr7fDEFApuCjANz9..Noq9L8GsD8mD0O2vuHi06m2uUOb8s0AmoWQeP8XE9A.tfytZ+BxDhkLtB+S8a0K8Gs1miLdeGdRR3ePXqXB..kqWRJNyDaJb+rk9Sp8d+595kAw.nFDrJDO24VFmyo0kEh+kQTQqvuFGwy7sr0xsukA5.nNNy3i52E5GG01Urusg9Eg8Ui9hrk9GLyS5G.9MacfSs1OqeWnebThlRD85Ny8N8Kxnpk08OLgeMDA.VmUIDhok67w09NWi6ePY1qsRMObMO7Y32quB.ttiVoC8uFaVEPxnQJ1uoGywkO1iix0+HQYJ8nVTurnszu.ZHRzgN8hR56T+qwl9ahuo1fYus3Ye+qO818I62Wd856y1Hm0Qsk9Qg6kmgeBiRFPvfFwkfqHhTuM9x713d4jYb0I2HqI9O+9wVm8FzF288akmLx7Z4iPQG14kxVhnRVIvLlnDwfUpde6MYO1V+.YgU3OwLHO7bz9abMurOp0CVaEgy5p7lU2Q40HUGPx9s2ccOWYIiNI7mXaMi0.2OAXvbQq9v7UF9rO62DOJW+l3kdF0ttn51fD9SosdF8FkClHnGnc13HaATt2p3NRqvajckmQ+67Oeuyja0Wp0qiLkgve3Y3OgV6UJS1FbF5cd1YGKYIvxRqy54aNWtR+UQuNvxWEeSee52G8quL3pwwpbC9ujveRs2f25HD.fIi9jSZQR5akTdH1VXaR3OYLHE.v3Rb.kaJQeIK12T9.+FI7C..IlGwnuMcOw8Efryg1G..mlDkFWYXEWOp9aFtFA30qBS3Wmd4hfzf1nj9N0+JQk5t8oVTtD83HJ4yezuFAXxgI7a.8XZ9yjlxPnOosIPsclWsba87qu1oW+Z+2Af92WOC+5DOWV9plg3Yzdu.msWERY5ZAn+Me794uh4VyxWMcK+yu16m9094rJaiGALl7L7mPqM3TVFb9nqiLbcNcHBs1gITFt9d856qwkWuY45DfVasWwb6sR8qkbelWQeiu.LZF5So+rNysaMXcFFjqjsmX1kg5sQ+yO.8p0FueqU5ese+V+4.fXZnWg+QJoCCVC.GozwEGowOil0Fue910e5mm+meueF.hsgNg+QgAuAfRYmTEa68X8U5yjelWj.0eAFMC8V5Oy15f240KC1A.6y3D..4fD9SrLOC8.zS1q+VIOSFodM8.6hU3X1R+IiN8.nuXxWo0t6XAFkXMFkqyHSYDbLI7OfD7I.sk9co0jHz1buYro+XFMR3Og974y+90zOO+6udoyN.tSY98XNwwcTuaTpKOJWmiHksLZjveBs16S28dk7..00HcpmSeqli2moXGN5ZQaVfrPB+IyZmN+68y.vuYq264q8c3I7q0+luqAyBwAALJ95T5eYGfYqC9raqUxeqU5G3dsUPkZClGqMIpaMYqz+xZYUFultaYst.vX4vU32LfFKqEj4jkI8Se5nfKD7QbrWvhZClGasB+dLphIkULm9pAhth1R+5rKNNJHSqveLLu7asCfQhAaq6w0dS9JvyR6QfQRQI7KH03XqUv2yve73T9N91ZG1L+mImrB+..zCrB+Iydqr+z2sB+PabzNrQ6vbyj5..vSyoz+.RPnvyQ6uwQzJme+98+90zOu76q8eG.f9kD9GPBRCdVVY+7KJ8ytLI94+9keed8VI8C.DCR3O41ZkZ.f5HpSfyYGOXq+7qMgAPOKpsY4a56ANlD9SnsVol4LXGzVkztjbpG6u8Np+oNMYTO19k+R4Cbr+4o+.P8s0yH7zuSmiv8ZsCFy4GXeN3LymHUddmIlqtM.PewJ7mT6EvkUgAtWkz9aD2Fzi30LPepjIlxjWAjAEkvuN7hm0d0e48+MzF199ay3IOqVTWT88XX9A13xuFE60ej9p.xBao+jZsj6O5TWFnNVt88e8RRPudI.5QhwW5aG0eznT9s28gQ4d.8o4OFtpKlKkFOXMKyObE9UAK11qSBksv8PR9ziZY8QiuzuJsdP16+ZJ9noud856cDI7TVqdYlMRwM8Dkm6tB+iPErr6nmkXkwPcb0Aol+2S6QtSs7w4Jpiun833XsCV009Nv8S6t60WI7aqijWd18ig8JiztrOUq1U56k6j9+Ol1e.P1r5V52.d4TlRlXzNXglLhWy8tZWlnLl6RV5+G.Hpdh377Z4afjof8l+rMkMYbaEl0jXuqqqrd+hmk5Uv1z9.nEdh35kv+fv14ONV6zce9DbDwxwLLoEKc2kCQrbl9VFaGB0RlaerbWQZ7E34XE941LRm9kQ2xyQisNXg34b01Qmcmon8J0zZOVW5OgQ2HzO6xwdhb69Qn7hbyJ7CCrkqn+Vm4BFrKtF0ydh4F8q+m1x6+JOXzE4jeGQJufySB+I07jG2JfNcZ1WVak8WamYnbKGF0xwLecur8ZjlfmLWt.6IJsQA3pjveRczyruf65Oa8r6ubk9EbRrc1yhAk2wwZG3l8Tes68YQ8LVpmp6dWVNt67e+7uCPjIg+DaJXy09h9yVqvelelaWaEQm+8r5LkgYp7lwg5sDE6MNj5w.2gV22x+zz+eCXSKWQ+8Vg+rDDxVuBB64qu0lLh67sfQlJuAddkrKiFk9bV12sGeNfVok8w7UB+KG.PGdPar0J6mkSV2rXY.hqUtURx+m4OGTKdEs9G6MQZq0NNisCy30zU39.P1c3J7a0kf1Z41JT6u9yZm0BS+9RU5jCnOXhldt9ZouKx25Y5tmu1.HJNJ1G80VWE8L7a0.f1Xs1ZkFfJs0ZmGFmo7wJ7yS4NqS0y0WqQ+mQ5Mu..8r8dbN0Oac4P6C5H6sESsRu8i0B5+rG3fNk94IMZ8kT61QZWBv0s1qdZ8qdeJNgeEBv8qjs2M8ie4zbtz+7iVhYzN0rtUO+Ff4NOPMAfqIRGXyQmU3GfJ3rA+aE9oGTi.r54fzz9Af9UMNSj3Xds7APGyfdb2txyMo5k+gG0J.9Mm8sbDmmU3G5DVw2wfC8K5Yqs07muhKRtEhmowc7rRSuZ4J6qNZcYE9gNgY1LNTVQ1sbEWlmneTR5uUsQsJ+z61ZR7hFuJ2xKqv+8xJ7CcBcxwRBdgmjmkRfdgXjxskStrwcpKqvO.WvcOSzYZvtstOMBWiSxz0JvuyNCo9bOMNVVVsbE9UVVWR3GfKx1Oaek9ZlL5CpWRc.Au.Lm9CJmwYyokO1XyKmGw1GqUOuV2GJdK8Oh23gmzH1lKhCpW6xIGLZ.zVyOT6bv1Asyn2daY+Nq8euF7L7CcpQryunlnas9bG0q+0Lh0eOh6IP+Ys1kidRHzWxX8v8h2ISwB0KJJge23g9g1i8ooUl+rkOW8uGP4z9h0T5iiC7jxX+W60tRat56qD9mG3ofPg1QaMHdDXRLnbBf9f9iauMWgeIe.v0oOzxE4A+UNC.Ttku58VaAlibbA8HOC+PG4njGjbQbXvJ3Y0p9K0uL.ka4qdu67zom+vqkOnynStbXqW0LPDrUcV8OAzqz+TLrL9n89N0gD9A3FTZx9FTSPZ8HkI.vcPx9smszO.2fkCZs0fWYcPsrdcQrb20CUOmnIh63rRZmosXbrUR9K+uS8Hge.pr0R12ynF.7zh53N68lCKpWSip0VA+4+rU3u9jvO.2fRF7xLXmi.0J8ZHCWqQzcceW4IzdSI9O+KhkshG5nEIgqSB+.bCleJzN+6iDu0I9qQ5ZsGU66+JOA3ZV6T5e56SeoO1+pFwO5P6CfafYp9OFkAsmtNmJqcvC0epUaQko.7aJ4Y3eD5qsjwkpw8AqvO.2fRVY+QXvrQy7sXpx29yurEfs8gyGGFbvyYq2lQiRx9S16ZsV2GrB+.bCNZVaGoAyfdyds+F0UZZTsb24r1+Mn016r+I50KmGezHuCHmaYYZsKmkvO.Of4a8af9wdmdzjWJmomj82HAqsM94up88iuR3OCybD.OMyZM..rN4a1NqtB+1VSDA1tzjAljU..f6RwGZeVsJ5IGUeLa0Wy10S1o7B..nG3Y3G5H6knnm463XzeU7A..zG7Z4CfJSx9DYq8JRZ5K..hEI7CchRClVP28O6BChr0Nk58NnG.HljvO.UlIkA..nGHge.pLqDJ..POPB+DdRtB.tpocjiclC.jQR3mvSPZPbn8J8n4I86.JD.xDI7S3YE9oGUZ8xQq96nc8R+5nD6kz+3xD+.zRK2oY0t+GI7ysnkCTt0++XfZdZGkbqjeg9lwQFGakjuD+AtaSwCN+60LFw+oZ+KA+O8x.iRlhdvmOed898a0GAnSURbK5G+d39JysVaQ0O9cEmvua1bjVln+TRTiHsEiGkYPeYTG+.5IR1GS1Vab3V5u1ao.xmmZ6tsW8xHVmMhelAH6L4.4lx2mi3df13qU3WiOJUOLHY1puNx6bA.fdlUZDpGw61NNz93zb.1buNJXB26AdB56A.dBF+423P6afc1YpVis1vyyDvSS+8..4fD9StiBZqjDGE3W63dMvSaD5GxiOEihspmaQCfwgD9YSBFBfwRMljXf9vdsmiVa48tVhz0A7D7L7OPJsCQOi9..+gjIXRI0E5k3mJ8wCr2URLohaE12Plv+TGCiPmCyGbRGl4hxJ.tNIxyqW0udf5U0i3bf5XHS3+ymO+6Wifoqys9tD8An9zuZ+6n3.Fk3D.n0z+51pc7CdF9GDSGPQyOnhDLJ.2GAyDCJmnjCwQ0Sf55L4gj41eaceX52Wiq8hWgeIGFayObVxbiF..3rlu6OW6KfqaYdjW8UCd1xGsUm0FesB+GchdNQmewx7suO8Kupn..fyQdI8skkOWId24I8OZk2+507keF9kTRr34zOeFsN6..XbHNm7oVGb5xo4b9oCsO2r6eRzG...dR0NejnmeSK+7+ymR+Q+lcVIQ+3pjYz1rdC.P1Ilnb3tNf9hbtNsrdaUNk9GwmkhdUjq3y5z1B.fQky2nX6pOq9m4OeDiUtk0oq1qkundyNKzQXtnsDvS3n.q02DvSPeO42ZuBwyrVdcVsD94YLBMH.f1Qf0P7UxamIs04tcl7Tx5qdudfD9CpRaLr0rG40zG..jaRpmnqjUB2NMee+7g1Gs0UNL9lZ.r76....0VsVTQKN4uSB+Awubp6ubKxngCvSX96e2QneH84B.ipsVfQK7X6U0szusSQ88qAJN82e9AgA.svnuE7rqp.fQ0VORwlD7y6WiinnU3uzfVDTScUiFDe97Y2xEkY..+kfQA39H2i+pU2KJJg+R2VhFjrNZ41cUYFvcnz9VzGD8FAiBv8XTdj9NiVLliSo+NRKZ.rbKz5z5GZuruU1A.XrY66WtkwDtLNweMtQGZecfVNaWSM9bXRAOGI6C.PIh5phGwOy8hkwI1jmgetGOQC3oYHZ4rFA.8I8QCv35nyiqdUD+L2q903.rk9e.sL3soD7meZ8+DeN.fqQPS.itku0oVR+jjY+5aaMI72POUB1y++WI4C..DQR1mQkmg+NWTe1a..lXrLHehPaZukv3Hlzm8U0U32M6+qdnCnRJS5gOm.PeyX7PbM+Q7bqG0Sn1bR82Grk9uApXC..zKlRre42AxOao+Jx1cDf+nzfIGofNM9.zuz9rOob4b5w6W2837iTbDWU0R3ezuY2iMv.3Icz3BYXbio992aLf4SFrwJf9TF5OJiTtbN858q65yUud81apxV5ejuYK3M.1VlGeXYR7kNdvu7p0A.Hhp8yyuwQK2Omv+ndyVh9.TOQJI3Zz++7+Mhx0clsV8OGpYncJTW0Jo+r2db48ne858RI7m8ax6Qh9.TeQYbk6XLf4IaJIymi2u2rjxe5AKGiXd8xku8EhfqlzeTt99E2UdlEmv+HbSdORzGn1jbWrzhwATW3Y39NPOa93OyicHZI6OYuOuQbRLpkRtubEGdn8MUYZT4j2G3tL58ulQWs7z3L7zTGjHKy0emhUXqwWxVbDd0Qtte49QUNz9xnL2wA.bNm4.4aRsOfhf6jfqIxFk5uix0I00pI7OxUlDbVrMha+Gf9zYGOQ+W..Taekv+HGrwHlre1tlG45u.2ir0OI.Qx7cKk37fyyV5++IqAzk0qK.dR1t9.zNRzGtNI7++jwf21pyw4m9k.v4n+S..hhCOk9GAi1IwuS+R.9M5+DHR1JN2QJ9WXTMTqvuN0.fe0cNVhCtOf6vn7JcC3aesB+YNo34uGK0A2e4dA.k6N6yT+w..TSqtk9yxVb+nqAI96YQEnslFeIx86b2qvOPaocGPls6V5e9q.i4cF16II6U2Q4LHGPKoe4849S+wiYQdMOFnkw4pbGZu4Gr3ZGVOE8L7uLovd8lujWOOqvOzVK6+rW6OEFQFOjWu9a8.8OCs0xCV7Qo82VKx9b+x8hTbn8Y.ZHdJ4QtIiVdck0qyVRP4TC60mTl14fVAs+Pri.8ho9huq9kB8qkun+bfBipRZ2psM8hQLYnQyH0eyntBZKMpW2.8m6Nt3PtB+iz.y.v9D3NvYIVRfQQnR3WmymSIaSuHeOcsO6B7GHpz+0y3LiCNpa+8LxYXDPOnE8CEhD90g70sUvIY3dpft.Zk6N4.8mA.vcnqS3OCIk9zVdZfC.8EI6C.vcoKS3uVIlNxa8t0ttW96LA.z6F41vzelpKVy9NU+F.f6T2cJ825jPG4jdEnI8N0QoGUq5kpeCzBdqVAistYE9uqNhzAGDWVge5U+5p8qdM8N8+lGJGgw1imveqRHeqCttLdJspicxB0ko2c1wPTmt+blxvLT9c12JAudkiqa.FUWZK8WiN9a41KZqOuS+9QdfrQ9ZGnMl5qe42yjOe970WK+8vSYJlqq11KisYe853XfztEnW7K8Gc5D9+0N+Z8yQjNqA3YsbxUyV+x6MoxymjirccS+qlwbk0j9WJq8SALtZ1g1WuefgnicncJo8VFaStbU1x7JdyeH4gXHi8IcG8qz6wxcEasybHl90cyBzZsn+la+Y3OBM3rxKP6M+POaTZ+s75Tvkw2HU+E.f34zqveoIv26yt17OaYKXsqbf7.Okr09iwh5u4xdO9IQZ7xH8YEpMmaJDM2cc1puB+QYPFcD..vj0R1OquMe9U1YKzqTujH6tp+Vsmg+deE84aJu..1WzFqrUedi18E.FU+7J7qC+9zVu6bUdA.Tt4qzO.Pz7SI7K4w92VkQ1hh.vVNZ7gQI4WuZEiKkW.7GWJgeIJFCGMPmj9A3dD4jMJYbgHe8UBO69wWlqeBvYTsmg+d0ZCVW5uaDX.Q.pqkIKNpiuDY6cZ8C.DIU+T5uGclD7Mi9.vUsVx9RVLdh5j1z5OmpeCP+KkI7+qC9L82OJCvC.8AqHb7MOY+nsH.s9yq54.z+R2V5ulC9XfL.tGQJIpQxnVtr0J4O+mESv2F05K.7qZ4NH6Tqv+HNX2HbMOBWizGVaky1q9Wo+4HdTd1mNyJDmo1kKutkHaYxP4+V0iyT8af9SK2QfmJgec9A7qVNilGEXsmEZncNShtiT6wQ5ZczrUYqxb5IS8Mm05kdUvduR4yvOPeoVqVVFFvyfZzyh1yrdMLZWu.wynGafE842jtmgef9xcDLcTCPOpetgrZJHxoud8Rf0PTYL1XR419d+98+90Uc5D9Un.Tp6r+B8EA7qVlb+xj9iXx+s5ybDu2PtoNYNM5kqKmT5qvJ7CDVR5G3tLhOdC.zaZ4oYeVIgeH.FgN6F8YvE5EkzVbDZuF4mYz69ycTuu.zWJItV8276jv+.Xdxh+5y.BOiHt8ROa8rqVuT8Yn91qulH0OzuH5qv+cUNMJk+.8gH2Obuvoz+.HhIKB.OqQeLioU3OxAaV6O+idcBf1K58C2CrB+..vq+6JIMEjYzSxsVe9i98Af9SI8qHY+emD9AptV24rAC.Nq052X9JIkgU3exU2oe03zgFfs3Y3uMrk9AptVGjrACnmrrtu5m8o0VA+0R1OKkeqkzeFuNAxkLLoqOMqvOvsXq2u028++.Os4qJp5m8u8dKnj8xOmwO.Ooy7VgQ+TW2oS32MafRrL346ZFZizL+p+SnOsV+Hdq1LNTNC8KsO+cmNge2zAtByP6wbuAZKs430K0CfmzYVketlK8L76Y8B3r1aaytkrbfYM2TemY65Bhp0dl1Af13n3gzm7uqnD9MXHvSHyIEqeTn+ncIDKi3YuwnQtm+th1R+KWYtLGDN..kQ7..Oks5+Q+Rv+Uwqv+7FOlkEfdg9ifmi1e.OE8+.konD9W6z1ViL3dYapAiso9.ztG.fqpnszeqdeZC7Wq8d7NRaSM8SvYEo52..PDbpmg+s9Y5aSuKgcFLDWqk7eDb2edi18C1mxy+qH1lmbPbB.jGWZE9IVVlrnxSZo6p9l5wwijHf9yVGLyZuBzCx3qn4Zoz9qKdE9EbMvUU69OzeTLobC5OKWLfntix.xI4g9skmwOGc+o3U32Lq.7KpUm05zG..FCibbeyy+d9im8YcoSoe.thoNsuReJibG9..vHZTWg+s1t9W49QQI7uzHdSGndV1GxxNu75HC.ZoowgVFbswg.Zs05OZ5muReREsk9mSGe.01Zu5OyVeMktUrrip.n8V6LLHaiCQ7IFg7adx9y6WZqIkrDqtB+5fCf5Yqsi0VcZubFcAtea0dTaPhjQc6OOJxXY6QIwlwq48rL490R9+rtzV5G.JyZI6u1ueu+9i1fcvSP6Lx.0iIh15LdZTqOOeRPpQbfekv+ndiEfZpla6NI8C.7WqMFqwIiOkg+UMuWb5mgen2c1UPEpoe40lxQ+6B.rkQZbh0NmEFoqe3Lrk9Ic9kmwE3Wb2AaXk9AfsLpiOLpW2PorB+.TImIni4qLgfU...tCVg+AfSdXnMNyJ7O+OqsgH..vcXnR3+nfpyZBvY85BFQ1V+.0l9U.HuFlszuUPC..9lj8AHuFlD9AhESRG...+FI7CzkxxJNcGWGlLD..fR7UB+BjDfyaq9NW62mkIy...nus5g12dI8KPU.J2mOe9pOUSrJDGNP6FKSk2S8SqrGdN5+sNN8V5Wfp.TN8YB8u8lTNAaNVlJu+74ixd5BS8Gs76Ywd6PxQrM37x4ZUVOTuV9HmF0W2hzWVak7AhgkiSXbChlQM4nQv7IgZ92yh0tdF45y2Q4rD9IzJIAqQtSCZmVlru5yzKz+JzGFk1gdriGCJKqKI7CPEXE9IiVVmdpddVWoIf9l9bfySB+DVRtBf60ZAWKfa.f3PB+PGx4RPL0hU4WYO.bVdEwBiKI7CcFmKA..TShY.FWm90xWTcTGc5HDnFty9RzOE..vYLTqvufkAZg6Xq8q+K..fyZXVge.ZoZlftj8A..tBI7CAk2RA8uZjntj8AfyP7A.yMTaoexkQ+8dtDAig0JmlNzEcpIC.0lwQ.l6zI7qSD.9MS8ip+T..Vyx2HSyWrfLD+PoKZWFtVeZGtk9+74ifSIzTuE.f8Lk7wxuGUQ+yO+2cx57j7Gs3ZGw5x09Z9qU3eqJQiVkKhgR1V+YYlPA.3drLYpnG2Pz+7uk4w7McMN86x30bVpOx4T6xaOC+...PnLhq7aVnrqsbJ8CcFyhK..7eIIQ3ZjvOgWIIHmsAILo..Ps7986u9B5IkTmT8VXc1R+DdkzAezRPd4yk1xeO.PsXrk7auXkT9C4lD9I7x7A2WD+LCPlE0wSXroNKLtrk9I7x3J7C.8m4uGrAfqQb4skD9I7Fwmge.nsF42C1.PbIgeBOIyC.2MI4C.QjmgeFBBTC3t4wKB.ntLt4uayU32qkE...3oIou7QYZ67UB+KSz26jU5c5v.HJLVJ.vebTL7hwuNN0V5eJPE27A..xhslLNw7B2qo1XyeKnLxuMTV659W6G5ROC+dGzRuQ8Q..th8Rrvhc0ONJIPkQw1x2BJiZ44cbc6P6C.3GMpqDALJrXW8AkAv440xG..vPxj0AjcR3G..FXSI8N+6NzlAHGjvO.vOx1LknZsj825OCw0VSpCP9Ige.fej.mA5YqcfnYhJ4IYby14xI7qPB.3OD3L.P4LtY6b4D9yPgjsyD.zRYXrSxCw.AP9MzaoeamI.nVNZ7Di2PjYxA.HlF5D9A.pISjL..8j+4J+kDLC.v1LNYrbzpWq7D.hJqvO..CKaU8xj0I8nzqqrd8COsoyTM8EqvKwBA..HfcIQTPTceNcB+5vidjNI.f6RVGiQLc+gyeC34Lu8kj+uGmNgeE.ziLXL.bVhogI6EGg5Iv8Z57uYpcn35qqK8L7C..LFFkfuGkqSnmocX84Y3G..FTBtFfbSB+..vAx515NqWW.veXK8OvlOHuY3uesWvXJ2..3Hue+9qXFV62AzFsr8WQI7+4yGy.bPUR4lN66WGU9YvZ.3pDaW9MuLdsx6oemXIf1pks4JdK8qif3ozAxMfe+S6O.dVib+vhS.f3p3D9yRm8iz61wQN3jrYTpyBPKYbR.H6JZK8mojMFoA2yT4F....miSo+DajlbC.5ESS157uaBXiMimR1oOJHuNcB+FzCf5Qxf4xZI6u7+F8kOe9rarMh6YroOZfna2szuA4nDdsw0FdaYjSZijGkz9zaVi9kxEVi5EP8Yrv1Z0D9U.vDIX1OTV..vcPr+wwTxxQNo4n94Np9JgeE.4RoqJrjIA.XMhMD5CyebwztjRUzozOwhj2AnszuKQjGULHVjjOWgD9CFCLCP+4LINEkUlojqmHbcv9NptqxX.hMI72QjLO..s1xj5mhGQx9wWISFoxYH2jveizCIyOuSeaiuXvfv.PqYrmbYuX9TVC4mD9qfHk3rD8A3YI.afVS+Nv3RB+GPxw....DQCcB+Rl+Orp+zSlWWzJR...v0k1D9KIogoe+HjrqDmHJTWE..f5HjI7elDzk7vebzqAJqxO.+lQ7zvNJuhAA.FUcWB+R5rsDnF777JvJONJo+rkfbVtV1qMX1Jy3+R4KP10zD9kL+yYqAylFnSYC7bDrYdr7wIK68slgjklWFk8xK91uT+MC0+Axu+e.zElBF1RK5pN.....IUjSD4pPfIH" ],
                    "embed": 1,
                    "id": "obj-106",
                    "maxclass": "fpic",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "jit_matrix" ],
                    "patching_rect": [ 6.024096385542169, 10.0, 283.9759036144578, 296.0 ],
                    "pic": "Macintosh HD:/Users/lynn/Desktop/portieres.png"
                }
            },
            {
                "box": {
                    "id": "obj-152",
                    "maxclass": "panel",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 153.0, 321.0, 257.0, 165.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 411.0, 335.0, 128.0, 128.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-153",
                    "maxclass": "panel",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 292.0, 10.0, 353.5, 250.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 426.0, 350.0, 128.0, 128.0 ]
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "destination": [ "obj-28", 0 ],
                    "midpoints": [ 312.5, 141.0, 312.5, 141.0 ],
                    "source": [ "obj-107", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-33", 0 ],
                    "midpoints": [ 421.5, 69.0, 427.5, 69.0 ],
                    "source": [ "obj-108", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-57", 0 ],
                    "midpoints": [ 544.5, 222.0, 544.5, 222.0 ],
                    "source": [ "obj-109", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-43", 0 ],
                    "midpoints": [ 309.5, 222.0, 309.5, 222.0 ],
                    "source": [ "obj-110", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-51", 0 ],
                    "midpoints": [ 430.5, 144.0, 430.5, 144.0 ],
                    "source": [ "obj-111", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-46", 0 ],
                    "midpoints": [ 430.5, 222.0, 430.5, 222.0 ],
                    "source": [ "obj-112", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-38", 0 ],
                    "midpoints": [ 550.5, 69.0, 544.5, 69.0 ],
                    "source": [ "obj-113", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-54", 0 ],
                    "midpoints": [ 309.5, 69.0, 309.5, 69.0 ],
                    "source": [ "obj-114", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 659.5, 300.0, 30.0, 300.0 ],
                    "source": [ "obj-118", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-30", 0 ],
                    "source": [ "obj-146", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-35", 0 ],
                    "source": [ "obj-147", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-40", 0 ],
                    "source": [ "obj-148", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-48", 0 ],
                    "source": [ "obj-149", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-60", 0 ],
                    "midpoints": [ 549.5, 144.0, 549.5, 144.0 ],
                    "source": [ "obj-150", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 5 ],
                    "source": [ "obj-172", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 312.5, 192.0, 297.0, 192.0, 297.0, 306.0, 30.0, 306.0 ],
                    "source": [ "obj-28", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 168.5, 477.0, 30.0, 477.0 ],
                    "source": [ "obj-30", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 427.5, 90.0, 417.0, 90.0, 417.0, 306.0, 138.0, 306.0, 138.0, 522.0, 30.0, 522.0 ],
                    "source": [ "obj-33", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 231.5, 477.0, 30.0, 477.0 ],
                    "source": [ "obj-35", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 544.5, 90.0, 417.0, 90.0, 417.0, 306.0, 138.0, 306.0, 138.0, 522.0, 30.0, 522.0 ],
                    "source": [ "obj-38", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 288.5, 477.0, 30.0, 477.0 ],
                    "source": [ "obj-40", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 309.5, 306.0, 30.0, 306.0 ],
                    "source": [ "obj-43", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 430.5, 441.0, 30.0, 441.0 ],
                    "source": [ "obj-46", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 356.5, 411.0, 342.0, 411.0, 342.0, 441.0, 30.0, 441.0 ],
                    "source": [ "obj-48", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 430.5, 171.0, 417.0, 171.0, 417.0, 306.0, 138.0, 306.0, 138.0, 522.0, 30.0, 522.0 ],
                    "source": [ "obj-51", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 309.5, 114.0, 297.0, 114.0, 297.0, 306.0, 30.0, 306.0 ],
                    "source": [ "obj-54", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 544.5, 303.0, 429.0, 303.0, 429.0, 441.0, 30.0, 441.0 ],
                    "source": [ "obj-57", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 1 ],
                    "midpoints": [ 95.0, 310.0, 100.625, 310.0 ],
                    "source": [ "obj-6", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 22.5, 310.0, 30.0, 310.0 ],
                    "source": [ "obj-6", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 549.5, 171.0, 537.0, 171.0, 537.0, 144.0, 417.0, 144.0, 417.0, 306.0, 138.0, 306.0, 138.0, 522.0, 30.0, 522.0 ],
                    "source": [ "obj-60", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 453.5, 369.0, 429.0, 369.0, 429.0, 441.0, 30.0, 441.0 ],
                    "source": [ "obj-63", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 468.5, 405.0, 429.0, 405.0, 429.0, 441.0, 30.0, 441.0 ],
                    "source": [ "obj-64", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 488.5, 441.0, 30.0, 441.0 ],
                    "source": [ "obj-65", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "source": [ "obj-67", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6", 0 ],
                    "source": [ "obj-69", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-8", 1 ],
                    "midpoints": [ 595.0, 651.0, 50.5, 651.0 ],
                    "source": [ "obj-7", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-8", 0 ],
                    "midpoints": [ 30.0, 666.0, 24.5, 666.0 ],
                    "source": [ "obj-7", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 659.5, 231.0, 657.0, 231.0, 657.0, 300.0, 30.0, 300.0 ],
                    "source": [ "obj-70", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 659.5, 258.0, 657.0, 258.0, 657.0, 300.0, 30.0, 300.0 ],
                    "source": [ "obj-72", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 659.5, 174.0, 660.0, 174.0, 660.0, 300.0, 30.0, 300.0 ],
                    "source": [ "obj-74", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 659.5, 201.0, 657.0, 201.0, 657.0, 300.0, 30.0, 300.0 ],
                    "source": [ "obj-78", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-89", 0 ],
                    "midpoints": [ 24.85542168674698, 132.0, 0.0, 132.0, 0.0, 72.0, 6.0, 72.0, 6.0, 15.0, 20.0, 15.0 ],
                    "source": [ "obj-95", 0 ]
                }
            }
        ],
        "parameters": {
            "obj-107": [ "position/delay time", "position/delay time", 0 ],
            "obj-108": [ "live.dial[1]", "size", 0 ],
            "obj-109": [ "live.dial[2]", "reverb", 0 ],
            "obj-110": [ "live.dial[3]", "density", 0 ],
            "obj-111": [ "live.dial[4]", "feedback", 0 ],
            "obj-112": [ "live.dial[5]", "pitch (semitones)", 0 ],
            "obj-113": [ "live.dial[6]", "shape", 0 ],
            "obj-114": [ "live.dial[7]", "dry/wet", 0 ],
            "obj-150": [ "live.dial[8]", "gain", 0 ],
            "parameterbanks": {
                "0": {
                    "index": 0,
                    "name": "",
                    "parameters": [ "-", "-", "-", "-", "-", "-", "-", "-" ],
                    "buttons": [ "-", "-", "-", "-", "-", "-", "-", "-" ]
                }
            },
            "inherited_shortname": 1
        },
        "autosave": 0
    }
}