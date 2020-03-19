[Normal](#normal)

1. image patch extract 
2. prediction 
3. heatmap stitching




# 1. image patch extract 
qsub heatmap_main.sh test /scratch/mikem/UserSupport/weizhe.li/runs_process_cn_True/testing_wnorm_448_400_7690953

# For color normalization True
qsub process_main.sh ./config_testing_cn_true.txt
qsub process_main.sh ./config_normal_cn_true.txt
qsub process_main.sh ./config_tumor_cn_true.txt

# For color normalization False
* qsub process_main.sh ./config_testing.txt
qsub process_main.sh ./config_normal.txt
qsub process_main.sh ./config_tumor.txt


qsub split_main.sh ./config_testing.txt
bash create_lookup_grp.sh ./config_testing.txt
qsub process_main.sh ./config_testing.txt

qsub split_main.sh ./config_normal.txt
bash create_lookup_grp.sh ./config_normal.txt
qsub process_main.sh ./config_normal.txt

qsub split_main.sh ./config_tumor.txt
bash create_lookup_grp.sh ./config_tumor.txt
qsub process_main.sh ./config_tumor.txt

#Real Cool Heading

qsub split_main.sh ./config_testing_wc.txt


# TESTING
[mikem@betsy02 split_wsi]$ ls -alsh /scratch/wxc4/CAMELYON16-testing | less
total 206G
[mikem@betsy02 split_wsi]$ ls -1 /scratch/wxc4/CAMELYON16-testing | wc -l
129

# TUMOR
[mikem@betsy02 split_wsi]$ ls -alsh /scratch/wxc4/CAMELYON16-training/tumor | less
total 219G
[mikem@betsy02 split_wsi]$ ls -1 /scratch/wxc4/CAMELYON16-training/tumor | wc -l
111

#NORMAL
[mikem@betsy02 split_wsi]$ ls -alsh /scratch/wxc4/CAMELYON16-training/normal | less
total 278G
[mikem@betsy02 split_wsi]$ ls -1 /scratch/wxc4/CAMELYON16-training/normal | wc -l
159



location of the bouding box

    dimensions = {'normal' : '/home/weizhe.li/li-code4hpc/pred_dim_0314/training-updated/normal/dimensions',
                  'tumor' : '/home/weizhe.li/li-code4hpc/pred_dim_0314/training-updated/tumor/dimensions',
                  'test' : '/home/weizhe.li/li-code4hpc/pred_dim_0314/testing/dimensions'  
        }
slide.dimensions
A (width, height) tuple for level 0 of the slide.

get_tile_dimensions(level, address)
    Return a (pixels_x, pixels_y) tuple for the specified tile.

get_tile_coordinates(level, address)
Return the OpenSlide.read_region() arguments corresponding to the specified tile.
read_region(location, level, size)
Return an RGBA Image containing the contents of the specified region.
•llocation (tuple) – (x, y) tuple giving the top left pixel in the level 0 reference frame
•level (int) – the level number
•size (tuple) – (width, height) tuple giving the region size


>>> crds
((96, 0), 0, (512, 288))
>>> crds[0]
(96, 0)
>>> crds[0][0]
96
>>> crds[2]
(512, 288)
>>> crds[2][0]
512
>>> crds[2][1]
288
>>> crds[1]
0

The numbers of dimension times 224 is the actually dimension for the highest resolution image. 

The dimension from openslide is a coordinate (x, y) x is the width and y is the height.
If the image was read into a numpy array. When you check the numpy array shape, you will get another coordinate (x, y) x is the height, y is the width. Please note that the sequence is reversed. Please use the description of the dimension file in this email. 
By the way, the openslide use the top left corner as the (0, 0) point. X axis poinst to right; Y axis points down
The dimension files I mentioned in my last email have their contents as the following:

Each file store a list: [item1, item2, item3, item4, item5, item6, item7, item8]  br:  4256   5152   4256   5152

item1:  height of the WSI image
item2:  width of the WSI image
item3: number of channels ( equal to 3. We don’t need this item)
item4:  x coordinate on left of bounding box;
item5:  x coordinate on right of bounding box;
item6: y coordinate on top of bounding box;
item7: y coordinate on bottom of bounding box;
item8: height of the bounding box of bounding box;
item9: width of the bounding box of bounding box.


=====

Each file stores a list of bounding box. The actually coordinate on highest resolution needs to be timed by 224. I will send you a description tomorrow morning.

The dimension files I mentioned in my last email have their contents as the following:

Each file store a list: [item1, item2, item3, item4, item5, item6, item7, item8]

item1:  width of the WSI image
item2:  height of the WSI image
item3: number of channels ( equal to 3. We don’t need this item)
item4:  x coordinate on left of bounding box;
item5:  x coordinate on right of bounding box;
item6: y coordinate on top of bounding box;
item7: y coordinate on bottom of bounding box;
item8: width of the bounding box of bounding box;
item9: height of the bounding box of bounding box.




Level counting
qsub get_levels.sh
cat level_count/* >> all_level_count.csv
sort -k1n all_level_count.csv > all_level_count-sorted.csv


1. Create a list of WSI located under: /scratch/wxc4/CAMELYON16-testing/
   cd /projects/mikem/UserSupport/weizhe.li/split_wsi
   ls -1 /scratch/wxc4/CAMELYON16-testing > list.txt

2. Run the below job to split TIF files intosmaller HDF5 files 
   qsub split_grp.sh 

3. Geneate look-up table:
   bash create_lookup_grp.sh 
   
4. Run below script to process all HDF5 file in parallel.
   qsub process_main.sh

process_images_grp.o7677468

At [mikem@betsy02 split_wsi]$:
RESULT=grp_timing1
BASEDIR=/projects/mikem/UserSupport/weizhe.li/split_wsi/sysout_process_images_grp
APP_PREFIX=process_images_grp.o7678134
find $BASEDIR -name "$APP_PREFIX.*" | xargs grep "seconds" > "$RESULT".txt
sort -k2 -n "$RESULT".txt > "$RESULT"_sorted.txt 


find /projects/mikem/UserSupport/weizhe.li/split_wsi/sysout_process_images_ds -name "process_images_ds.o7676383.*" | xargs grep "seconds" > ds_timing1.txt
sort -k2 -n ds_timing1.txt > ds_timing1_sorted.txt 

find /projects/mikem/UserSupport/weizhe.li/split_wsi/sysout_process_images_ds -name "process_images_ds.o7674135.*" | xargs grep "seconds" > ds_timing.txt
sort -k2 -n ds_timing.txt > ds_timing_sorted.txt 
find /projects/mikem/UserSupport/weizhe.li/split_wsi/sysout_process_images -name "process_images.o7673281.*" | xargs grep "seconds" > file_timing.txt
sort -k2 -n file_timing.txt > file_timing_sorted.txt 

create_dataset, see: http://docs.h5py.org/en/stable/high/group.html
 

# for splitting and grouping 
D=/scratch/mikem/UserSupport/weizhe.li/runs_split_group/448_400_7684656/sysout
find $D -name "split*" | xargs grep "real" > split_timing.txt
 
 
 
 
   
