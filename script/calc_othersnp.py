#! /usr/bin/env python

import sys
import os
import pysam
#import tabix

inpdir = sys.argv[1]
dbpath = sys.argv[2]
outdir = sys.argv[3]


for file in os.listdir(inpdir):

    samplename = file.rstrip("\n").replace(".genomon_mutation.result.filt.txt", "")
    print "add snp around: " + samplename

    with open(inpdir + "/" + file, "r") as f:
        g = open(outdir + "/" + samplename + ".addsnp", "w")
        g.write("\t".join(["chr","start","ref","alt","misrate_othersnp","depth_othersnp","variant_othersnp"])+"\n")

        cnter = 0

        for line in f:
            cnter += 1
            if cnter == 1:
                continue

            data = line.split("\t")
            chrm = data[0]
            start = data[1]
            end = data[2]
            ref = data[3]
            alt = data[4]


            #if chrm == "X":
            #    chrm = 22
            #elif chrm == "Y":
            #    chrm = 23
            #else:
            #    chrm = int(chrm)-1

            span = 100000

            #tb = tabix.open(url)
            #records = tb.queryi(chrm, int(start)-int(span), int(end)+int(span))

            misRate_str = ""
            depth_str = ""
            variant_str = ""

            try:
                url = dbpath + "/" + samplename + ".filt.snp.gz"
                tbx = pysam.TabixFile(url)
            except:
                url = dbpath + "/" + samplename.replace("N","T") + ".filt.snp.gz"
                tbx = pysam.TabixFile(url)
                #print url
                #print tbx
                #print chrm, start, end, int(start)-int(span), int(end)+int(span)

            start_pos = max(0, int(start)-int(span))
            end_pos = int(end) + int(span)

            for r in tbx.fetch("chr"+chrm, start_pos, end_pos, parser=pysam.asTuple()):
            #for r in records:
                misRate_t = r[5]
                depth_t = r[6]
                variant_t = r[7]

                if float(misRate_t) >= 0.900:
                    continue

                misRate_str += misRate_t + ","
                depth_str += depth_t + ","
                variant_str += variant_t + ","


            g.write("\t".join([chrm,start,ref,alt,misRate_str[:-1],depth_str[:-1],variant_str[:-1]])+"\n")

        g.close()





