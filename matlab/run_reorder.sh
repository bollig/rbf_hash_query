#!/bin/bash -l


GRID="regulargrid_10x_10y_10z_final.ascii"
HNX=10
dim=3
STEN_SIZE=16

matlab -nodesktop -nosplash -r "addpath('~/Karen/locality_sensitive_hashing/matlab'); addpath('./int_morton'); drive_new_order('${GRID}', ${STEN_SIZE}, ${dim}, ${HNX}, @rcm); exit;"
matlab -nodesktop -nosplash -r "addpath('~/Karen/locality_sensitive_hashing/matlab'); addpath('./int_morton'); drive_new_order('${GRID}', ${STEN_SIZE}, ${dim}, ${HNX}, @ijk_to_u); exit;"
matlab -nodesktop -nosplash -r "addpath('~/Karen/locality_sensitive_hashing/matlab'); addpath('./int_morton'); drive_new_order('${GRID}', ${STEN_SIZE}, ${dim}, ${HNX}, @ijk_to_x); exit;"
matlab -nodesktop -nosplash -r "addpath('~/Karen/locality_sensitive_hashing/matlab'); addpath('./int_morton'); drive_new_order('${GRID}', ${STEN_SIZE}, ${dim}, ${HNX}, @ijk_to_z); exit;"
matlab -nodesktop -nosplash -r "addpath('~/Karen/locality_sensitive_hashing/matlab'); addpath('./int_morton'); drive_new_order('${GRID}', ${STEN_SIZE}, ${dim}, ${HNX}, @ijk_to_4node_z); exit;"

