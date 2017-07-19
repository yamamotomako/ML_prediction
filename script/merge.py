#! /usr/bin/env pyhton


import os, sys, re

inputdir = sys.argv[1]
exacdir = sys.argv[2]
betadir = sys.argv[3]
outdir = sys.argv[4]


ref_dict = {}
ref_dict_2 = {}


for file in os.listdir(betadir):
    with open(betadir + "/" + file) as f:
        for line in f:
            data = line.rstrip("\n").split("\t")
            samplename = data[0]
            chrm = data[1]
            start = data[2]
            info = data[3:]

            key = samplename+"_"+chrm+"_"+start
            ref_dict[key] = info




for file in os.listdir(exacdir):
    with open(exacdir + "/" + file) as f:
        for line in f:
            data = line.rstrip("\n").split("\t")
            samplename = data[0]
            chrm = data[1]
            start = data[2]
            info = data[3:]

            key = samplename+"_"+chrm+"_"+start
            ref_dict_2[key] = info



for file in os.listdir(inputdir):
    with open(inputdir + "/" + file, "r") as f:
        g = open(outdir + "/" + file, "w")
        print "merge: " + file
        cnter = 0

        for line in f:
            cnter += 1

            if cnter == 1:
                g.write(line.rstrip("\n") + "\t".join(["dbsnp","cosmic","exac","misrate_othersnp","depth_othersnp","variant_othersnp","cohort_count","alpha","beta"]) + "\n")
                continue

            samplename = re.sub(r"[N|T].genomon_mutation.result.filt.txt", "", file)
            data = line.rstrip("\n").split("\t")
            chrm = data[0]
            start = data[1]
            
            key = samplename+"_"+chrm+"_"+start
            if key in ref_dict:
                g.write(line.rstrip("\n") + "\t" + "\t".join(ref_dict_2[key]) + "\t" + "\t".join(ref_dict[key]) + "\n")

        g.close()



