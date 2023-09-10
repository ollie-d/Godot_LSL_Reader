using Godot;
using System;
using LSL;

// Adaptation of essential functions from
// https://github.com/labstreaminglayer/liblsl-Csharp/blob/master/examples/ReceiveData/ReceiveData.cs
public partial class LSL_Inlet : Node
{
    public StreamInfo[] stream_infos;
    private StreamInlet stream_inlet;
    public int num_channels;

    public override void _Ready() {}

    // This is a procedure that connects to a stream given certain properties
    // since we can't really pass around values within GDScript from C#
    // namely, C# types are not available to GDScript I don't think...
    public void connect_to_stream(string prop, string value, int num_channels_)
    {
        StreamInfo[] results = LSL.LSL.resolve_stream(prop, value);
        stream_inlet = new StreamInlet(results[0]);
        results.DisposeArray();
        GD.Print(stream_inlet.info().as_xml());
        num_channels = 8;
        float[] samples = new float[num_channels];
        stream_inlet.pull_sample(samples);
    }

    // Takes no arguments with the assumption that global vars were previously set
    public float[] pull_sample()
    {
        float[] samples = new float[num_channels];
        stream_inlet.pull_sample(samples);
        return samples;
    }

    public void main()
    {
        connect_to_stream("type", "EEG", 8);

        //float[] samples = pull_sample();

        //foreach (float f in samples)
        //    GD.Print(f);

        /*=======================================================*/

        // Below here WORKS
        /*
        //connect_to_stream("type", "EEG", 8);
        StreamInfo[] results = LSL.LSL.resolve_stream("type", "EEG");
        using StreamInlet inlet = new StreamInlet(results[0]);
        stream_inlet = inlet;
        results.DisposeArray();
        GD.Print(stream_inlet.info().as_xml());
        num_channels = 8;

        float[] samples = pull_sample();

        // read samples
        //float[] sample = new float[8];
        //stream_inlet.pull_sample(sample);
        foreach (float f in samples)
            GD.Print(f);
        //return sample;
        //while (true)
        //{
         //   inlet.pull_sample(sample);
          //  foreach (float f in sample)
           //     GD.Print("\t{0}", f);
            //System.Console.WriteLine();
       // }
        */
    }

}
