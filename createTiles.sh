#!/bin/bash
echo "Script Started..."
while :; do
    case $1 in
    -file)
        if [ "$1" ] && [ "$2" ]; then
            fileName=$2
            shift
        else
            echo 'ERROR: "--file" requires a non-empty option argument.'
            exit 0;
        fi
        ;;
    -ulx)
        if [ "$1" ] && [ "$2" ]; then
            ulx=$2
            shift
        else
            echo 'ERROR: "--ulx" requires a non-empty option argument.'
            exit 0;
        fi
        ;;  
    -uly)
        if [ "$1" ] && [ "$2" ]; then
            uly=$2
            shift
        else
            echo 'ERROR: "--uly" requires a non-empty option argument.'
            exit 0;
        fi
        ;; 
    -llx)
        if [ "$1" ] && [ "$2" ]; then
            llx=$2
            shift
        else
            echo 'ERROR: "--llx" requires a non-empty option argument.'
            exit 0;
        fi
        ;; 
    -lly)
        if [ "$1" ] && [ "$2" ]; then
            lly=$2
            shift
        else
            echo 'ERROR: "--lly" requires a non-empty option argument.'
            exit 0;
        fi
        ;;                              
    -?*)
        printf 'WARN: Unknown option\n'
        exit 0; 
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
#    mv $fileName $dir
else
    gdal_translate -of vrt -a_srs EPSG:4326 -a_ullr $ulx $uly $llx $lly $fileName output.vrt
    gdal2tiles.py output.vrt $dir 
    rm output.vrt
#    mv $fileName $dir   
fi
echo "done"
