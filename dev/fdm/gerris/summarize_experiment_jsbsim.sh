#!/bin/bash
# Copyright (C) 2012  Anders Gidenstam  (anders(at)gidenstam.org)
# This file is licensed under the GPL license version 2 or later.
#
# Usage: summarize_experiment.sh <base dir>/<name base>


BASE=$1

# Hydrodynamic reference point [m].
HRPX=25.5
HRPZ=3.0

# Height offset above the HRP [m]. Input on the command line.
#HAGL=

# Note: We are only interested in 
#  z force and pitch and roll moment.
#  Output formatted as JSBSim tables with pitch angle
#  as row and roll angle as column index.
#
#  The resulting "coefficients" are scaled for imperial units
#  and expressed as
#    F/(Rho*G) and M/(Rho*G)

echo "Z Force (pitch, roll)"
echo "   -4.0  -2.0   0.0   2.0   4.0"
for pitch in -4 -2 0 2 4; do
  ROW=${pitch}
  for roll in -4 -2 0 2 4; do
    dir=${BASE}_r${roll}_p${pitch}
    ROW=${ROW}`awk 'BEGIN {
            U = 100.0*3.2808399; Rho = 1.0; G = 1.0;
            k_F = -U^3 * Rho * G;
            k_M = -U^4 * Rho * G;
          }
          /[0-9]*\.0/ { print "   " k_F*$4; }' ${dir}/f`
  done;
  echo ${ROW}
done;
echo;

echo "Y Moment (pitch, roll) (~pitch moment)"
echo "   -4.0  -2.0   0.0   2.0   4.0"
for pitch in -4 -2 0 2 4; do
  ROW=${pitch}
  for roll in -4 -2 0 2 4; do
    dir=${BASE}_r${roll}_p${pitch}
    ROW=${ROW}`awk 'BEGIN {
             U = 100.0*3.2808399; Rho = 1.0; G = 1.0;
             k_F = -U^3 * Rho * G;
             k_M = -U^4 * Rho * G;
           }
           /[0-9]*\.0/ { print "   " k_M*$9; }' ${dir}/f`
  done
  echo ${ROW}
done;
echo;

echo "Z Moment (pitch, roll) (~roll moment)"
echo "   -4.0  -2.0   0.0   2.0   4.0"
for pitch in -4 -2 0 2 4; do
  ROW=${pitch}
  for roll in -4 -2 0 2 4; do
    dir=${BASE}_r${roll}_p${pitch}
    ROW=${ROW}`awk 'BEGIN {
             U = 100.0*3.2808399; Rho = 1.0; G = 1.0;
             k_F = -U^3 * Rho * G;
             k_M = -U^4 * Rho * G;
           }
           /[0-9]*\.0/ { print "   " k_M*$10; }' ${dir}/f`
  done
  echo ${ROW}
done;
echo;
