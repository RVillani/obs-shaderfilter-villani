/**
 * Outlines filter shader by Rodrigo Villani (https://github.com/RVillani)
 * Created on 09/2020
 *
 * Creates outlines around areas of high contrast.
 *
 * For use with obs-shaderfilter (https://github.com/Oncorporation/obs-shaderfilter/)
 */

uniform float Outline_Thickness = 2.0f;
uniform float Sensitivity = 3.0f;
uniform float Darkness = 6.0f;
uniform int Num_Directions = 8;
uniform int Quality = 2;

uniform string notes = "Outline Thickness is the size of the outlines in pixels.\n\nSensitivity is how different pixels must be to have outlines among them. Lower values result in less outlines.\n\nDarkness defines the color of the outlines. 1 uses a blurred version of the image as the color of the outlines. Less then 1 makes the outlines brighter and higher values darken them.";

uniform string Advanced_Notes = "Num Directions is the number of steps taken around each pixel to compare their contrast with their neighboring pixels.\n\nQuality defines how many samples are taken on each direction.\n\nThe total number of samples per pixel is Directions * Quality. So for 16 and 3, you have 48 samples for each pixel. Higher values yield preciser outlines, but are also heavier to compute.";

float4 mainImage(VertData v_in) : TARGET
{
	float Pi = 6.28318530718; // Pi*2

	float4 CenterColor = image.Sample(textureSampler, v_in.uv);
	float4 BlurredColor = CenterColor;
	float sobelX = 0.0f;
	float sobelY = 0.0f;

	// blur
	float2 Radius = Outline_Thickness * uv_pixel_interval;

	float AngleStepSize = Pi / Num_Directions;
	float DistStepSize = 1.0 / Quality;
	
	// Blur calculations
	for(int AngleStep = 0; AngleStep < Num_Directions; ++AngleStep)
	{
		float angle = AngleStep * AngleStepSize;
		float2 cosSin = float2(cos(angle), sin(angle));

		for(int DistStep = 1; DistStep <= Quality; ++DistStep)
		{
			float dist = DistStep * DistStepSize;
			float4 neighborColor = image.Sample(textureSampler, v_in.uv + cosSin * Radius * dist);
			BlurredColor += neighborColor;

			sobelX += neighborColor.rgb * cosSin.x * Sensitivity;
			sobelY += neighborColor.rgb * cosSin.y * Sensitivity;
		}
	}
	
	int NumIterations = Num_Directions * Quality;
	BlurredColor /= NumIterations + 1.0f;

	sobelX /= NumIterations;
	sobelY /= NumIterations;
	float edges = 1.0f - ceil(length(float2(sobelX, sobelY)) - 0.05f);

	BlurredColor.rgb = pow(BlurredColor.rgb, Darkness) + edges;
	CenterColor.rgb = lerp(BlurredColor.rgb, CenterColor.rgb, edges);

	// Output to screen
	//return float4(edges, edges, edges, 1.0f);
	return CenterColor;
}
