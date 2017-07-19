#! /usr/bin/env python

import os, sys, re

if len(sys.argv) != 4:
    print "Usage: python categorize.py ./input_dir ./output_file_path category"
    quit()

category = sys.argv[1]
inputdir = sys.argv[2]
outdir = sys.argv[3]



#snp138
if category == "A":
    col_snp = 19
else:
    col_snp = 19

#cosmic70
if category == "A":
    col_cosmic = 23
else:
    col_cosmic = 23

#ExAc frequency
if category == "A":
    col_exac = 91
else:
    col_exac = 80




files = os.listdir(inputdir)
for file in os.listdir(inputdir):
    with open(inputdir + "/" + file, "r") as f:
        sample = re.sub(r"[N|T].genomon_mutation.result.filt.txt", "", file)
        g = open(outdir + "/" + sample + ".addexac", "w")
        cnter = 0

        for line in f:
            cnter += 1
            if cnter == 1:
                g.write("\t".join(["sample","chr","start","dbsnp","cosmic","exac"])+"\n")
                continue

            data = line.rstrip("\n").split("\t")
            chrm = data[0]
            start = data[1]
            dbsnp = data[col_snp]
            cosmic = data[col_cosmic]
            exac = data[col_exac]            

            dbsnp_flag = False
            cosmic_all = 0

            if dbsnp != "":
                dbsnp_flag = True

            if cosmic != "":
                cosmic_slice = cosmic[cosmic.find("OCCURENCE="):]
                cosmic_num = re.compile(r"\d").findall(cosmic_slice)
                for num in cosmic_num:
                    cosmic_all += int(num)

            if exac == "---":
                exac = 0

            arr = [sample, chrm, start, str(dbsnp_flag), str(cosmic_all), str(exac)]
            g.write("\t".join(arr) + "\n")

        g.close()



