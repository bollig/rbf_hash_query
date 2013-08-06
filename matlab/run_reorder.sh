#!/bin/bash -l

matlab -nodesktop -nosplash -r "addpath('./int_morton'); drive_new_order(@ijk_to_z); exit;"

