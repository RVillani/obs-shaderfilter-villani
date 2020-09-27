# Filters for obs-shaderfilter plugin
My Custom shader filters for the obs-shaderfilter plugin.

## Introduction

Shader files to use on [OBS Studio](http://obsproject.com/) with the [obs-shaderfilter](https://github.com/Oncorporation/obs-shaderfilter/) plugin.

## Installation

Follow the [instructions](https://github.com/Oncorporation/obs-shaderfilter/) to install obs-shaderfilter and create a filter on one of your sources choosing `User-defined shader` as the filter type and set the filter to `Load shader text from file`.

Download the .shader files from this repository and use them as the text file for the User-defined shader.

### Shaders

* **16-bit:** Pixelates the image, posterize colors and add scanlines. All optional, so you can use any combination of the effects.
* **Outlines:** Creates outlines around areas of high contrast. Useful for cartoon effects.
* **Smart blur:** Blurs the image only where there are subtle changes in color. Can be used to remove noise or to remove skin details.