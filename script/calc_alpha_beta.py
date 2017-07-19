#! /usr/bin/env python


import sys
import os
import re
import numpy
import optimize

inpdir = sys.argv[1]
outdir = sys.argv[2]


for file in os.listdir(inpdir):

    print "add alpha beta: " + file
    samplename = re.sub(r"[N|T].addcohort", "", file)

    with open(inpdir + "/" + file, "r") as f:
        g = open(outdir + "/" + samplename + ".addbeta", "w")
        cnter = 0

        for line in f:
            cnter += 1
            if cnter == 1:
                g.write("\t".join(["sample","chr","start","misrate_othersnp","depth_othersnp","variant_othersnp","cohort_count","alpha","beta"])+"\n")
                continue

            data = line.rstrip("\n").split("\t")
            chrm = data[0]
            start = data[1]
            ref = data[2]
            alt = data[3]
            other_misrate = data[4]
            other_depth = data[5]
            other_variant = data[6]
            cohort_count = data[7]

            m_arr = other_misrate.split(",")
            d_arr = other_depth.split(",")
            v_arr = other_variant.split(",")

            m_new = []
            d_new = []
            v_new = []

            for i in range(len(m_arr)):
                m = m_arr[i]
                d = d_arr[i]
                v = v_arr[i]

                #remove blank
                if m == "":
                    continue


                if float(m) < 0.95 and (int(d) - int(v)) >= 3:
                    if (int(d) - int(v)) < int(v):
                        #print m, d, v
                        v = int(d) - int(v)
                        m = float(int(v)) / int(d)

                    m_new.append("%03.3f" % float(m))
                    d_new.append(int(d))
                    v_new.append(int(v))


            #if len(m_new) == 0:
            #    continue

            fit = optimize.fit_beta_binomial(numpy.array(d_new), numpy.array(v_new))
            alpha = fit[0]
            beta = fit[1]

            content_arr = [samplename, str(chrm), str(start), ",".join(m_new), ",".join(map(str,d_new)), ",".join(map(str,v_new)), str(cohort_count), str(alpha), str(beta)]
            g.write("\t".join(content_arr)+"\n")


        g.close()





