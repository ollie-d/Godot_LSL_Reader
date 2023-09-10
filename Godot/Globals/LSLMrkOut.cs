using Godot;
using System;
using LSL;

public partial class LSLMrkOut : Node
{
    StreamInfo inf;
    StreamOutlet outl;
    public override void _Ready()
    {
        inf = new StreamInfo("GodotMarkerStream", "Markers", 1, 0, channel_format_t.cf_string, "OllieGodot000");
        outl = new StreamOutlet(inf);
    }

    public void SendMarker(string marker)
    {
        outl.push_sample(new string[] { marker });
    }
}
