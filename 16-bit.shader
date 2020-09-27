/**
 * 16-bit filter shader by Rodrigo Villani (https://github.com/RVillani)
 * Created on 09/2020
 *
 * Pixelates the image, posterize colors and add scanlines.
 *
 * For use with obs-shaderfilter (https://github.com/Oncorporation/obs-shaderfilter/)
 */

uniform bool Pixelate = true;
uniform int Pixels_Horizontal = 150;
uniform int Pixels_Vertical = 90;

uniform bool Cell_Shading = true;
uniform int Bands_Count = 6;
uniform float Bands_Lights_Gamma = 1.0f;
uniform float Bands_Shadows_Gamma = 1.0f;

uniform float Master_Brightness = 1.0f;
uniform float Saturation = 1.5f;

uniform bool Scanlines_Horizontal = true;
uniform bool Scanlines_Vertical = false;
uniform float Scanlines_Alpha = 0.3f;
uniform float Scanlines_Size = 0.1f;

uniform string About_Pixelation = "Pixelates the screen with the resolution set by the Horizontal and Vertical values.";

uniform string About_Cell_Shading = "• Bands Count defines the number shading levels.\n• Bands Lights/Shadows Gamma offset the bands on the brighter/darker levels of the image. Lower values move the bands towards darker values and higher moves them closer to brigher values."

uniform string About_Brightness_Saturation = "• Master Brightness changes the final brightness of the image without affecting cell shading banding effects.\n\nSaturation saturates or desaturates the image.";

uniform string About_Scanliens = "Scanlines can be enabled independently for the horizontal and vertical lines between pixels.\n\nAlpha changes the scanlines opacity.\n\nSize changes how thick they are in relation to pixels. E.g., 0.5 occupies half of each pixel.";

float posterize(float value)
{
	// Divide value btween lights and darks to apply separate gamma values
	float light = saturate(mad(2.0f, value, -1.0f));
	float dark = saturate(value * 2.0f);

	light = pow(light, Bands_Lights_Gamma) * 0.5f;

	dark = pow(dark, Bands_Shadows_Gamma) * 0.5f - 0.5f;
	value = light + dark + 0.5f;

	int bands = max(Bands_Count, 2);
	int maxBandIndex = bands - 1;
	float bandStep = 1.0f / bands;
	int bandIndex = min(maxBandIndex, value / bandStep);

	return (float)bandIndex / maxBandIndex;
}

float4 mainImage(VertData v_in) : TARGET
{
	// pixelation
	float2 targetSize = float2(max(2.0, Pixels_Horizontal), max(2.0, Pixels_Vertical));
	float2 pixelUVs = v_in.uv;
	if (Pixelate)
	{
		pixelUVs = max(floor(pixelUVs * targetSize) / targetSize, uv_pixel_interval);
	}

	float4 c1 = image.Sample(textureSampler, pixelUVs);

	float val = length(c1.rgb);
	float maxVal = length(float3(1.0f, 1.0f, 1.0f));
	float normalVal = val / maxVal;

	// Value posterization
	if (Cell_Shading)
	{
		normalVal = posterize(normalVal);
	}

	// Value brighness adjust
	normalVal = pow(normalVal, 1.0f / Master_Brightness);
	val = normalVal * maxVal;

	c1.rgb = normalize(c1.rgb) * val;
	c1.rgb = lerp(normalVal, c1.rgb, Saturation);

	// Scanlines
	if (Scanlines_Horizontal || Scanlines_Vertical)
	{
		float2 scanlines = frac(v_in.uv * float2(Pixels_Horizontal, Pixels_Vertical));
		scanlines = 1 - ceil(scanlines - Scanlines_Size);

		c1.rgb -= saturate(scanlines.x * Scanlines_Vertical + scanlines.y * Scanlines_Horizontal) * Scanlines_Alpha;
	}

	return c1;
}
