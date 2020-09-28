# Filters for obs-shaderfilter plugin
My Custom shader filters to use on [OBS Studio](http://obsproject.com/) with the [obs-shaderfilter](https://github.com/Oncorporation/obs-shaderfilter/) plugin.

## Installation

Follow the [instructions](https://github.com/Oncorporation/obs-shaderfilter/) to install obs-shaderfilter and create a filter on one of your sources choosing `User-defined shader` as the filter type and set the filter to `Load shader text from file`.

Download the .shader files from this repository and use them as the text file for the User-defined shader.

### Shaders

* **16-bit:** Pixelates the image, posterize colors and add scanlines. All optional, so you can use any combination of the effects.
* **Outlines:** Creates outlines around areas of high contrast. Useful for cartoon effects.
* **Smart blur:** Blurs the image only where there are subtle changes in color. Can be used to remove noise or to remove skin details.
 
### Sample images

* Original image, without filters
 ![original image][original]
* 16-bit
 ![16-bit example][16-bit]
* Outlines
 ![Outlines example][outlines]
* Smart blur
 ![Smart blur example][smart-blur]
* Smart blur, outlines and 16-bit, in that order.
 ![combined sample][16-bit-combined]


[original]: https://github.com/RVillani/obs-shaderfilter-villani/blob/master/example%20original.jpg?raw=true
[16-bit]: https://github.com/RVillani/obs-shaderfilter-villani/blob/master/example%20pixelate.jpg?raw=true
[outlines]: https://github.com/RVillani/obs-shaderfilter-villani/blob/master/example%20outlines.jpg?raw=true
[smart-blur]: https://github.com/RVillani/obs-shaderfilter-villani/blob/master/example%20smart-blur.jpg?raw=true
[16-bit-combined]: https://github.com/RVillani/obs-shaderfilter-villani/blob/master/example%2016-bit%20outlines%20smart-blur.jpg?raw=true
