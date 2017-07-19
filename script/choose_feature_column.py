#! /usr/bin/env python

import os, sys, re


flag = sys.argv[1]
inputdir = sys.argv[2]
outfile = sys.argv[3]


if flag == "A":
    col_misrate = 58
    col_depth = 50
    col_variant = 51
    col_end = 95

else:
    col_misrate = 58
    col_depth = 50
    col_variant = 51
    col_end = 84

if flag == "A":
    category = "somatic"
elif flag == "B":
    category = "germline"
else:
    category = "others"




g = open(outfile, "w")
g.write("\t".join(["sample","category","chr","start","end","ref","alt","misrate","depth","variant","dbsnp","cosmic","exac","other_misrate","other_depth","other_variant","cohort_count","alpha","beta"])+"\n")


for file in os.listdir(inputdir):
    with open(inputdir + "/" + file, "r") as f:
        cnter = 0
        for line in f:
            cnter += 1
            if cnter == 1:
                continue

            sample = re.sub(r"[N|T].genomon_mutation.result.filt.txt", "", file)
            data = line.rstrip("\n").split("\t")
            chrm = data[0]
            start = data[1]
            end = data[2]
            ref = data[3]
            alt = data[4]
            misrate = data[col_misrate]
            depth = data[col_depth]
            variant = data[col_variant]
            addinfo = data[col_end+1:]

            g.write("\t".join([sample,category,chrm,start,end,ref,alt,misrate,depth,variant]) + "\t" + "\t".join(addinfo) + "\n")
            

g.close()


