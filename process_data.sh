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

for stem in mres_$ms; do
  $exe_dir/bin.py ./data/$stem $tstart $tend $tinc $bin
done

# bin 2pt functions
#for stem in pion-00WP pion-00WW fp-00WP kaon-00WP kaon-00WW fk-00WP za_$ml 2pion000 mres_$ml \
#  sss-x-00WP sss-y-00WP sss-z-00WP box-sss-x-00WP box-sss-y-00WP box-sss-z-00WP; do
for stem in pion-00WP pion-00WW fp-00WP kaon-00WP kaon-00WW fk-00WP za_$ml 2pion000 mres_$ml sss-x-00WP sss-y-00WP sss-z-00WP \
  2pion1-1-1 2pion1-11 2pion11-1 2pion111; do
  $exe_dir/bin.py ./data/$stem $tstart $tend $tinc $bin
done

# bin 3pt functions
# for stem in zpa-00 zpa-00-ref zka-00 zka-00-ref bk; do
for stem in zpa-00 zpa-00-ref zka-00 zka-00-ref bk; do
  $exe_dir/bin_3pt.py ./data/$stem $tstart $tend $tinc $bin 
done

# mres
$exe_dir/process_mres.py ./data/mres_$ml.bin_$bin ./processed_data/mres_$ml.ratio $tstart $tend_binned $tinc_binned $T
$exe_dir/process_mres.py ./data/mres_$ms.bin_$bin ./processed_data/mres_$ms.ratio $tstart $tend_binned $tinc_binned $T

# <PP>
for stem in pion-00WP pion-00WW kaon-00WP kaon-00WW; do
  $exe_dir/fold_sym.py ./data/$stem.bin_$bin ./processed_data/$stem.fold $tstart $tend_binned $tinc_binned $T
done

#for stem in pion-00WW-HP; do
#  $exe_dir/bin.py ./data/$stem $tstart $tend $tinc $bin
#done

# <PP> also imaginary part
#for stem in pion-00WW-HP; do
#  $exe_dir/fold_sym.py ./data/$stem.bin_$bin ./processed_data/$stem.fold $tstart $tend_binned $tinc_binned $T
#  $exe_dir/fold_sym_imag.py ./data/$stem.bin_$bin ./processed_data/$stem.fold $tstart $tend_binned $tinc_binned $T
#done

# <AP>
for stem in fp-00WP fk-00WP; do
  $exe_dir/fold_asym.py ./data/$stem.bin_$bin ./processed_data/$stem.fold $tstart $tend_binned $tinc_binned $T
  $exe_dir/flip_sign.py ./processed_data/$stem.fold $tstart $tend_binned $tinc_binned
done

# ZA
$exe_dir/process_za.py ./data/za_$ml.bin_$bin ./processed_data/za_$ml.ratio $tstart $tend_binned $tinc_binned $T

# BK
$exe_dir/bk_3pt_to_2pts.py ./data/bk.bin_$bin $tstart $tend_binned $tinc_binned
$exe_dir/process_bk.py ./data/bk.bin_$bin ./processed_data/bk.contr $tstart $tend_binned $tinc_binned $T

# ZV
for stem in zpa-00 zpa-00-ref zka-00 zka-00-ref; do
  $exe_dir/kl3_3pt_to_2pts.py ./data/$stem.bin_$bin $tstart $tend_binned $tinc_binned
done
$exe_dir/process_zv_corr.py ./data/zpa-00.bin_$bin ./data/zpa-00-ref.bin_$bin ./processed_data/zpa-00 $tstart $tend_binned $tinc_binned $T
$exe_dir/process_zv_corr.py ./data/zka-00.bin_$bin ./data/zka-00-ref.bin_$bin ./processed_data/zka-00 $tstart $tend_binned $tinc_binned $T

# two pion HP
$exe_dir/process_sum_2pion.py ./data/2pion1-1-1.bin_$bin ./data/2pion1-11.bin_$bin ./data/2pion11-1.bin_$bin ./data/2pion111.bin_$bin ./processed_data/Epp-1.I2 $tstart $tend_binned $tinc_binned $T
$exe_dir/fold_sym.py ./processed_data/Epp-1.I2 ./processed_data/Epp-1.I2.fold $tstart $tend_binned $tinc_binned $T

$exe_dir/process_2pion_dE_ratio.py ./processed_data/Epp-1.I2 ./data/pion-00WW.bin_$bin ./processed_data/RppWW-1.I2 $tstart $tend_binned $tinc_binned $T
$exe_dir/fold_sym.py ./processed_data/RppWW-1.I2 ./processed_data/RppWW-1.I2.fold $tstart $tend_binned $tinc_binned $((T-1))

# two pion
$exe_dir/process_2pion.py ./data/2pion000.bin_$bin ./processed_data/Epp-0.I2 $tstart $tend_binned $tinc_binned $T
$exe_dir/fold_sym.py ./processed_data/Epp-0.I2 ./processed_data/Epp-0.I2.fold $tstart $tend_binned $tinc_binned $T
$exe_dir/process_2pion_dE_ratio.py ./processed_data/Epp-0.I2 ./data/pion-00WW.bin_$bin ./processed_data/RppWW-0.I2 $tstart $tend_binned $tinc_binned $T
$exe_dir/fold_sym.py ./processed_data/RppWW-0.I2 ./processed_data/RppWW-0.I2.fold $tstart $tend_binned $tinc_binned $((T-1))
#
# omega
$exe_dir/process_omega.py ./data/sss-x-00WP.bin_$bin ./data/sss-y-00WP.bin_$bin ./data/sss-z-00WP.bin_$bin ./processed_data/sss-00WP $tstart $tend_binned $tinc_binned $T
#$exe_dir/process_omega.py ./data/box-sss-x-00WP.bin_$bin ./data/box-sss-y-00WP.bin_$bin ./data/box-sss-z-00WP.bin_$bin ./processed_data/box-sss-00WP $tstart $tend_binned $tinc_binned $T
