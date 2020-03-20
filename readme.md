[1 Image patch extraction](#1-image-patch-extraction)   
[2 Prediction](#2-prediction)  
[3 Heatmap stitching](#3-heatmap-stitching)  
[4 Retreiving run-time statistics](#4-Retreiving-run-time-statistics)  


# 1 Image patch extraction
- Adjust configuration parameters in files *config_testing.txt*, *config_normal.txt* and *config_tumor.txt*.
- Run the commands listed in the following subsections to launch Son of Grid Engine (SGE) jobs to extract, group patches in HDF5 files and create a lookup table for every HDF5 file. 
## 1.2 Extract and group
- qsub split_main.sh ./config_testing.txt  
-- *split_main.sh* in turn submits *split_grp.sh* which in turns runs *split_grp.py* in array job fashion. Every task in the array job processes one slide.
- qsub split_main.sh ./config_normal.txt  
- qsub split_main.sh ./config_tumor.txt  

## 1.3 Creat lookup tables
- bash create_lookup_grp.sh ./config_testing.txt  
- bash create_lookup_grp.sh ./config_normal.txt  
- bash create_lookup_grp.sh ./config_tumor.txt  

The lookup tables are created only once and used at [Prediction](#2-prediction) stage for launching array job tasks. These tasks are run in parallel and scalable manner - if there are not enough resourcs for running all tasks then they are queued up automatically and started as resources become available. Each task processes only one group. 

# 2 Prediction
- Additionally adjust configuration parameters in files, *config_testing_cn_true.txt*, *config_normal_cn_true.txt*, *config_tumor_cn_true.txt*.
- Run commands listed in the below subsections to launch SGE jobs to generate prediction matrices.
## 2.1 With color normalization
- qsub process_main.sh ./config_testing_cn_true.txt  
-- *process_main.sh* in turn submits *process_array.sh* which in turn runs *process_images_grp_normalization_wli.py* in array jobs generated for every slide.
- qsub process_main.sh ./config_normal_cn_true.txt  
- qsub process_main.sh ./config_tumor_cn_true.txt  

## 2.2 Without color normalization 
- qsub process_main.sh ./config_testing.txt  
- qsub process_main.sh ./config_normal.txt  
- qsub process_main.sh ./config_tumor.txt  

# 3 Heatmap stitching
After the predictions matrices have been generated an SGE job using *heatmap_main.sh* SGE scrip could be launched to genertae heatmaps. Two arguments for this launch are: a) type of the slides (test, normal or tumor); b) the root directory of the results, like in below example run:  
- qsub heatmap_main.sh test /scratch/mikem/UserSupport/weizhe.li/runs_process_cn_True/testing_wnorm_448_400_7690953  

# 4 Retreiving run-time statistics
## 4.1 CPU time
In *time_all_stats_pred.sh* file adjust job results root directory, DIR and slides type, PREFIX (normal, test or tumor), like below:  
- DIR=/scratch/mikem/UserSupport/weizhe.li/runs_process_cn_False/normal_wnorm_448_400_7691563  
- PREFIX=normal  
Then run:  
- time bash ./time_all_stats_pred.sh
## 4.2 Wall-Clock time
In *wall_clock_time_stats_pred.sh* file adjust job results root directory, DIR and slides type, PREFIX (normal, test or tumor), like below:  
- DIR=/scratch/mikem/UserSupport/weizhe.li/runs_process_cn_V2_False/testing_wnorm_448_400_7694088  
- PREFIX=test  
Then run:  
- time bash ./wall_clock_time_stats_pred.sh  


