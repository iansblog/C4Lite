# Kroki Diagram Examples
With the incusion of the Kroki Diagram engine you can add visulisations into the markdown files.

## Mermaid
Mermaid is a JavaScript-based diagramming and charting tool that renders Markdown-inspired text definitions to create and modify diagrams dynamically.

```kroki-mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```

## PlantUML
PlantUML allows you to create UML diagrams using simple and intuitive text descriptions.

```kroki-plantuml
@startuml
Alice -> Bob: Hello Bob!
Bob --> Alice: Hi Alice!
@enduml
```

## BlockDiag
BlockDiag helps you draw block diagrams with a simple and straightforward text-based description.

```kroki-blockdiag
blockdiag {
    A -> B -> C;
}
```


## ActDiag
ActDiag helps you create activity diagrams using text descriptions.

```kroki-actdiag
actdiag {
    write -> convert -> image
    write -> image [label = "success"]
}
```

## NwDiag
NwDiag allows you to draw network diagrams with a text-based description.

```kroki-nwdiag
nwdiag {
    network {
        web -> app -> db;
    }
}
```

## PacketDiag
PacketDiag helps you create packet format diagrams using text-based descriptions.

```kroki-packetdiag
packetdiag {
    colwidth = 8;
    node_width = 16;
    0-15: Source Port;
    16-31: Destination Port;
    32-63: Sequence Number;
    64-95: Acknowledgment Number;
    96-99: Data Offset;
    100-105: Reserved;
    106: Flags [color = lightblue];
    107: Flags [color = lightblue];
    108: Flags [color = lightblue];
    109: Flags [color = lightblue];
    110: Flags [color = lightblue];
    111: Flags [color = lightblue];
    112-127: Window Size;
    128-143: Checksum;
    144-159: Urgent Pointer;
    160-191: Options;
    192-223: Padding;
    224-255: Data;
}
```

## Ditaa
Ditaa allows you to convert ASCII art diagrams into proper bitmap graphics.

```kroki-ditaa
+--------+
|  User  |
+--------+
    |
   / \
+--------+    +--------+
|  Nginx  |---|  Tomcat  |
+--------+    +--------+
```

## Vega
Vega is a visualization grammar, a declarative format for creating, sharing, and exploring a wide variety of interactive visualizations.

```kroki-vega
{
  "$schema": "https://vega.github.io/schema/vega/v5.json",
  "width": 200,
  "height": 200,
  "data": [
    {
      "name": "table",
      "values": [1, 2, 3, 4, 5],
      "transform": [
        {
          "type": "formula",
          "expr": "datum.data * datum.data",
          "as": "square"
        }
      ]
    }
  ],
  "marks": [
    {
      "type": "rect",
      "from": {"data": "table"},
      "encode": {
        "enter": {
          "width": {"scale": "x", "band": 1},
          "x": {"scale": "x", "field": "data"},
          "y": {"scale": "y", "field": "square"},
          "y2": {"scale": "y", "value": 0}
        },
        "update": {"fill": {"value": "steelblue"}}
      }
    }
  ],
  "scales": [
    {
      "name": "x",
      "type": "band",
      "domain": {"data": "table", "field": "data"},
      "range": "width",
      "padding": 0.05,
      "round": true
    },
    {
      "name": "y",
      "type": "linear",
      "domain": {"data": "table", "field": "square"},
      "range": "height"
    }
  ]
}
```

## WaveDrom
WaveDrom is a digital timing diagram rendering engine that uses JavaScript and JSON.

```kroki-wavedrom
{
  "signal": [
    {"name": "clk", "wave": "p.....|..."},
    {"name": "Data", "wave": "x.345x|=.x", "data": ["head", "body", "tail", "data"]},
    {"name": "Request", "wave": "0.1..0|1.0"},
    {},
    {"name": "Acknowledge", "wave": "1.....|01."}
  ]
}
```
