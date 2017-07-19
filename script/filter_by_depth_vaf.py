#! /usr/bin/env python

import sys
import os


inputdir = sys.argv[1]
ok_resultdir = sys.argv[2]
ng_resultdir = sys.argv[3]
flag = sys.argv[4]


if flag == "TN":
    col_depth = 50
else:
    col_depth = 50

if flag == "TN":
    col_variant = 51
else:
    col_variant = 51


#ok_ff = open(ok_resultfile, "w")
#ng_ff = open(ng_resultfile, "w")

#header = "\t".join(["sample","chr","start","end","ref","alt"])+"\n"

#ok_ff.write(header)
#ng_ff.write(header)


for file in os.listdir(inputdir):
    samplename = file.rstrip("\n").replace(".genomon_mutation.result.filt.txt", "")
    print samplename

    with open(inputdir + "/" + file, "r") as f:
        ok_f = open(ok_resultdir + "/" + file, "w")
        ng_f = open(ng_resultdir + "/" + file, "w")

        cnter = 0
        for line in f:
            cnter += 1

            #header
            if cnter == 1:
                ok_f.write(line)
                ng_f.write(line)
                continue

            data = line.strip().split("\t")
            chrm = data[0]
            start = data[1]
            end = data[2]
            ref = data[3]
            alt = data[4]
            str = "\t".join([samplename,chrm,start,end,ref,alt])+"\n"

            #filter by depth, vaf
            vaf = float(data[col_variant]) / int(data[col_depth])
            if int(data[col_depth]) >= 20 and vaf >= 0.25:
                ok_f.write(line)
                #ok_ff.write(str)
            else:
                ng_f.write(line)
                #ng_ff.write(str)

        ok_f.close()
        ng_f.close()


#ok_ff.close()
#ng_ff.close()

