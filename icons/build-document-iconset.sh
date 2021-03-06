#!/bin/sh
#
# Create a document iconset for Jupyter notebook from an SVG template
#
base_icon=/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericDocumentIcon.icns
target_icon_name="Jupyter Notebook Document"
svg_icon_file=$(pwd)/ipynb-document.svg
iconutil --convert iconset --output "${target_icon_name}.iconset" "${base_icon}"
iconsizes="16 32 128 256 512"
for size in $iconsizes ; do
    echo $size

    output_name="$(pwd)/${target_icon_name}.iconset/icon_${size}x${size}.png"
    inkscape ${svg_icon_file} --export-id-only --export-id=v${size} \
        --export-png="${output_name}" \
        --export-width=$(echo 4*$size | bc) --export-height=$(echo 4*$size | bc)
    convert "${output_name}" -colorspace RGB +sigmoidal-contrast "6.5,50%" \
        -filter Lanczos -resize "${size}x${size}" \
        -sigmoidal-contrast "6.5,50%" -colorspace sRGB "${output_name}"

    output_name="$(pwd)/${target_icon_name}.iconset/icon_${size}x${size}@2x.png"
    inkscape ${svg_icon_file} --export-id-only --export-id=v${size}x2 \
        --export-png="${output_name}" \
        --export-width=$(echo 4*$size | bc) --export-height=$(echo 4*$size | bc)
    convert "${output_name}" -colorspace RGB +sigmoidal-contrast "6.5,50%" \
        -filter Lanczos -resize $(echo 2*$size | bc)x$(echo 2*$size | bc) \
        -sigmoidal-contrast "6.5,50%" -colorspace sRGB "${output_name}"
done
pushd "${target_icon_name}.iconset"
optipng *.png
popd
