#! /usr/bin/env python

import sys
import os
from collections import OrderedDict


samplepath = sys.argv[1]
resultdir = sys.argv[2]
resultfile = sys.argv[3]
flag = sys.argv[4]


if flag == "TN":
    col_refgene = 5
else:
    col_refgene = 5

if flag == "TN":
    col_misrate = 58
else:
    col_misrate = 54

col_ref = 3
col_alt = 4


g = open(resultfile, "w")
#g.write("\t".join(["sample","chr","start","end","ref","alt"])+"\n")



mutation_count = OrderedDict()


with open(samplepath, "r") as lines:
    for line in lines:
        sample_name = line.strip().split(",")[0]
        mutation_file = line.strip().split(",")[1]
        print sample_name

        if flag == "TN":
            sample_name_r = sample_name + "_TN"
        elif flag == "N":
            sample_name_r = sample_name + "_N"
        else:
            sample_name_r = sample_name + "_T"

        mutation_count[sample_name_r] = 0

        with open(mutation_file, "r") as f:
            gg = open(resultdir + "/" + sample_name + ".genomon_mutation.result.filt.txt", "w")

            #remove header
            cnter = 0
            for line in f:
                cnter += 1
                if cnter < 4:
                    continue

                #header
                if cnter == 4:
                    gg.write(line)
                    continue

                data = line.strip().split("\t")
                chrm = data[0]
                start = data[1]
                end = data[2]
                ref = data[3]
                alt = data[4]


                #filter by Func.refGene
                if data[col_refgene] == "exonic" or data[col_refgene] == "splicing" or data[col_refgene] == "exonic;splicing":

                    #filter by misrate
                    if float(data[col_misrate]) >= 0.05:

                        #filter by indel
                        if not data[col_ref] == "-" and not data[col_alt] == "-":
                            mutation_count[sample_name_r] += 1
                            gg.write(line)

            gg.close()



for key in mutation_count:
    g.write(key + "\t" + str(mutation_count[key]) + "\n")



g.close()


