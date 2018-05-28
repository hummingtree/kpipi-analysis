#!/bin/bash

# path to correlator-fit utilities 
exe_dir=/Users/hummingtree/alice/fitting-hantao-meas-david/correlator-fit/utility

# trajectories
tstart=1000
tend=2140
tinc=20
bin=1
tend_binned=$((tend-tinc*(bin-1)))
tinc_binned=$((tinc*bin))

# lattice parameters
ml=0.00107
ms=0.085
L=24
T=64

for stem in k2pipi-1 k2pipi-1-ref k2pipi-0 k2pipi-0-ref; do
  $exe_dir/bin_3pt.py ./data/$stem $tstart $tend $tinc $bin
  $exe_dir/kpipi_3pt_to_2pts.py ./data/$stem.bin_$bin $tstart $tend_binned $tinc_binned
done

$exe_dir/process_kpipi_ratio_isolated.py ./correlator_fits/results/fit_params/ZKWW ./correlator_fits/results/fit_params/Zpp-0-r.I2 ./correlator_fits/results/fit_params/mK ./correlator_fits/results/fit_params/Epp-0-r.I2 ./correlator_fits/results/fit_params/Cpp-0.I2 ./data/k2pipi-0.bin_$bin ./data/k2pipi-0-ref.bin_$bin ./processed_data/kpipi_ratio_isolated-0 $tstart $tend_binned $tinc_binned $L $T

#$exe_dir/process_kpipi_ratio.py ./data/kaon-00WW.bin_$bin ./processed_data/Epp-HP.Ieq2 ./data/k2pipi-1.bin_$bin ./data/k2pipi-1-ref.bin_$bin ./processed_data/kpipi_ratio $tstart $tend_binned $tinc_binned $L $T
#$exe_dir/process_kpipi.py ./data/k2pipi-1.bin_$bin ./data/k2pipi-1-ref.bin_$bin ./processed_data/kpipi-1 $tstart $tend_binned $tinc_binned $L $T
#$exe_dir/process_omega.py ./data/box-sss-x-00WP.bin_$bin ./data/box-sss-y-00WP.bin_$bin ./data/box-sss-z-00WP.bin_$bin ./processed_data/box-sss-00WP $tstart $tend_binned $tinc_binned $T
$exe_dir/process_kpipi_ratio_isolated.py ./correlator_fits/results/fit_params/ZKWW ./correlator_fits/results/fit_params/Zpp-1-r.I2 ./correlator_fits/results/fit_params/mK ./correlator_fits/results/fit_params/Epp-1-r.I2 ./correlator_fits/results/fit_params/Cpp-1.I2 ./data/k2pipi-1.bin_$bin ./data/k2pipi-1-ref.bin_$bin ./processed_data/kpipi_ratio_isolated $tstart $tend_binned $tinc_binned $L $T
