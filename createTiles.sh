#!/bin/bash
echo "Script Started..."
while :; do
    case $1 in
    -file)
        if [ "$1" ]; then
            fileName=$2
            shift
        else
            echo 'ERROR: "--file" requires a non-empty option argument.'
        fi
        ;;
    -ulx)
        if [ "$1" ]; then
            ulx=$2
            shift
        else
            echo 'ERROR: "--file" requires a non-empty option argument.'
        fi
        ;;  
    -uly)
        if [ "$1" ]; then
            uly=$2
            shift
        else
            echo 'ERROR: "--file" requires a non-empty option argument.'
        fi
        ;; 
    -llx)
        if [ "$1" ]; then
            llx=$2
            shift
        else
            echo 'ERROR: "--file" requires a non-empty option argument.'
        fi
        ;; 
    -lly)
        if [ "$1" ]; then
            lly=$2
            shift
        else
            echo 'ERROR: "--file" requires a non-empty option argument.'
        fi
        ;;                              
    -?*)
        printf 'WARN: Unknown option (ignored): %s\n' 
        ;;
    *)
        break
        ;;
    esac
    shift
done
data=`gdalinfo -json $fileName`
key='colorTable'
dir=$(echo "$fileName" | cut -f 1 -d '.')       		
if [[ "$data" == *"$key"* ]]; 
then
    gdal_translate -of vrt -a_srs EPSG:4326 -a_ullr $ulx $uly $llx $lly $fileName temp.vrt
    gdal_translate -of vrt -expand rgba temp.vrt output.vrt
    gdal2tiles.py output.vrt $dir
    rm temp.vrt output.vrt
else
    gdal_translate -of vrt -a_srs EPSG:4326 -a_ullr $ulx $uly $llx $lly $fileName output.vrt
    gdal2tiles.py output.vrt $dir 
    rm output.vrt  
fi
echo "done"
