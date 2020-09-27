/**
 * Smart Blur filter shader by Rodrigo Villani (https://github.com/RVillani)
 * Created on 09/2020
 *
 * Blurs the image only where there are subtle changes in color.
 *
 * For use with obs-shaderfilter (https://github.com/Oncorporation/obs-shaderfilter/)
 */

uniform float Blur_Size = 16.0;
uniform float Color_Threshold = 0.08f;
uniform int Blur_Directions = 16;
uniform int Blur_Quality = 3;

uniform string notes = "Size defines the amount of blur.\n\nThreshold is how different colors need to be to be blurred together. Lower values blur less colors together. 1 is maximum and blurs everything.";

uniform string Advanced_Notes = "Directions is the number of steps taken around each pixel to blur them with their neighboring pixels.\n\nQuality defines how many samples are taken on each direction.\n\nThe total number of samples per pixel is Directions * Quality. So for 16 and 3, you have 48 samples for each pixel. Higher values yield smoother blurring, but are also heavier to compute.";

float4 mainImage(VertData v_in) : TARGET
{
	float4 CenterColor = image.Sample(textureSampler, v_in.uv);
	float4 BlurredColor = CenterColor;

	// blur
	float Pi = 6.28318530718; // Pi*2
   
    float2 Radius = Blur_Size * uv_pixel_interval;

    float AngleStepSize = Pi / Blur_Directions;
    float DistStepSize = 1.0 / Blur_Quality;

    int AddedSteps = 1;

    float maxColorVal = length(float3(1, 1, 1));
    
    // Blur calculations
    for(int AngleStep = 0; AngleStep < Blur_Directions; ++AngleStep)
    {
    	float angle = AngleStep * AngleStepSize;
		for(int DistStep = 1; DistStep <= Blur_Quality; ++DistStep)
        {
        	float dist = DistStep * DistStepSize;
			float4 Neighbor = image.Sample(textureSampler, v_in.uv + float2(cos(angle),sin(angle)) * Radius * dist);

			if (distance(Neighbor.rgb, CenterColor.rgb) / maxColorVal < Color_Threshold)
			{
				BlurredColor += Neighbor;
				++AddedSteps;
			}
        }
    }
    
    // Output to screen
    BlurredColor /= AddedSteps;

	return BlurredColor;
}
