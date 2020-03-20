[1 Image patch extraction](#1-image-patch-extraction)   
[2 Prediction](#2-prediction)  
[3 Heatmap stitching](#3-heatmap-stitching)  
[4 Retreiving run-time statistics](#4-Retreiving-run-time-statistics)  

# 1 Image patch extraction
The following commands launch Son of Grid Engine (SGE) jobs to extract, group patches in HDF5 files and create a lookup table for every HDF5 file. 
## 1.1 With color normalization
- qsub split_main.sh ./config_testing_cn_true.txt  
- qsub split_main.sh ./config_normal_cn_true.txt  
- qsub split_main.sh ./config_tumor_cn_true.txt  

## 1.2 Without color normalization
- qsub split_main.sh ./config_testing.txt  
- qsub split_main.sh ./config_normal.txt  
- qsub split_main.sh ./config_tumor.txt  

## 1.3 Creating lookup tables
- bash create_lookup_grp.sh ./config_testing.txt  
- bash create_lookup_grp.sh ./config_normal.txt  
- bash create_lookup_grp.sh ./config_tumor.txt  

The lookup tables are created only once. 

# 2 Prediction
The following commands launch SGE jobs to generate prediction matrices.
## 2.1 With color normalization
- qsub process_main.sh ./config_testing_cn_true.txt  
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
In *time_all_stats_pred.sh* file adjust job results root directory, DIR and slides type, PREFIX (normal, test or tumor), like below:  
- DIR=/scratch/mikem/UserSupport/weizhe.li/runs_process_cn_False/normal_wnorm_448_400_7691563  
- PREFIX=normal
Then run:  
- time bash ./time_all_stats_pred.sh    



