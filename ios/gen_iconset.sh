#!/bin/sh

export PROJECT=wol
export ICONDIR=ios/iconset
export IMAGEDIR=ios/imageset
export ORIGICON=img/wol.png

mkdir -p $ICONDIR
mkdir -p $IMAGEDIR

# function to generate a single icon
gen_icon () {
    sips -z $1 $1 $ORIGICON --out $ICONDIR/${2}.png ;
}

# function to generate a single launch image
gen_launch_image () {
    sips -z $2 $1 $ORIGICON --out $IMAGEDIR/${3}.png ;
}

# Icons for iPhone-only Applications
gen_icon 512 "iTunesArtwork"
gen_icon 1024 "iTunesArtwork@2x"
gen_icon 120 "Icon-60@2x"
gen_icon 180 "Icon-60@3x"
gen_icon 76 "Icon-76"
gen_icon 152 "Icon-76@2x"
gen_icon 167 "Icon-83.5@2x"
gen_icon 20 "Icon-20"
gen_icon 40 "Icon-20@2x"
gen_icon 60 "Icon-20@3x"
gen_icon 80 "Icon-40@2x"
gen_icon 120 "Icon-40@3x"
gen_icon 29 "Icon-29"
gen_icon 58 "Icon-29@2x"
gen_icon 87 "Icon-29@3x"

# iPhone-only applications with a deployment target of iOS 6.1 or earlier use
gen_icon 57 "Icon-57"
gen_icon 114 "Icon-57@2x"
gen_icon 72 "Icon-72"
gen_icon 144 "Icon-72@2x"
gen_icon 50 "Icon-50"
gen_icon 100 "Icon-50@2x"

# Icons for iPad-only Applications
gen_icon 167 "Icon-83.5@2x"

# Launch images
gen_launch_image 320 480 "LaunchImage"
gen_launch_image 640 960 "LaunchImage@2x"
gen_launch_image 640 1136 "LaunchImage-568h@2x"
gen_launch_image 1024 768 "LaunchImage-Landscape"
gen_launch_image 2048 1496 "LaunchImage-Landscape@2x"
gen_launch_image 768 1004 "LaunchImage-Portrait"
gen_launch_image 1536 2008 "LaunchImage-Portrait@2x"

gen_launch_image 640 960 "LaunchImage-iOS7@2x"
gen_launch_image 640 1136 "LaunchImage-iOS7-568h@2x"
gen_launch_image 1024 768 "LaunchImage-iOS7-Landscape"
gen_launch_image 2048 1536 "LaunchImage-iOS7-Landscape@2x"
gen_launch_image 768 1024 "LaunchImage-iOS7-Portrait"
gen_launch_image 1536 2048 "LaunchImage-iOS7-Portrait@2x"

gen_launch_image 1242 2688 "LaunchImage-iOS12-XsMax-Portrait"
gen_launch_image 828 1792 "LaunchImage-iOS12-Xr-Portrait"
gen_launch_image 2688 1242 "LaunchImage-iOS12-XsMax-Landscape"
gen_launch_image 1792 828 "LaunchImage-iOS12-Xr-Landscape"

gen_launch_image 1125 2436 "LaunchImage-iOS11-X-Portrait"
gen_launch_image 2436 1125 "LaunchImage-iOS11-Xs-Landscape"

gen_launch_image 750 1334 "LaunchImage-iOS8-Small-Portrait"
gen_launch_image 1242 2208 "LaunchImage-iOS8-Large-Portrait"
gen_launch_image 2208 1242 "LaunchImage-iOS8-Large-Landscape"
