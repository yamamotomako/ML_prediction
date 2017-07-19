#! /usr/bin/env python

import sys
import os

inpdir = sys.argv[1]
outdir = sys.argv[2]
coresult = sys.argv[3]

ref_dict = {}

with open(coresult, "r") as f:
    for line in f:
        data = line.rstrip("\n").split("\t")
        ref_dict[data[0]] = data[1]




for file in os.listdir(inpdir):

    samplename = file.rstrip("\n").replace(".addsnp", "")
    print "add cohort count: " + samplename

    with open(inpdir + "/" + file, "r") as f:
        g = open(outdir + "/" + samplename + ".addcohort", "w")
        cnter = 0

        for line in f:
            cnter += 1
            if cnter == 1:
                g.write(line.rstrip("\n")+"\t"+"cohort_count"+"\n")
                continue

            data = line.rstrip("\n").split("\t")
            chrm = data[0]
            start = data[1]
            ref = data[2]
            alt = data[3]

            key = chrm+"_"+start+"_"+ref+"_"+alt

            if key in ref_dict:
                cohort_count = ref_dict[key]
            else:
                cohort_count = "0"

            g.write(line.rstrip("\n")+"\t"+cohort_count+"\n")


        g.close()





