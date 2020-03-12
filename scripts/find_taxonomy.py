#!/usr/bin/env python
# coding: utf-8

"""
Mar 11 2020
By Depeng Li
Make taxonomic annotation for a list of species

Usage:
    find_taxonomy.py [species_list] [outputfile]

"""
import sys
from ete3 import NCBITaxa

if len(sys.argv) < 2:
    sys.stderr.write(__doc__)
    sys.stderr.write('Two arguements are needed')
else:

    def lookuplineage(category):
        k = '-'
        p = '-'
        c = '-'
        o = '-'
        f = '-'
        g = '-'
        s = '-'
        for lineage in lineages:
            if randic[lineage] == category:
                category = linamedic[lineage]
        return category
    # print(s + '\t '+ k + '\t' + p + '\t' + c + '\t' + o +'\t' + f + '\t' + g + '\n')

    specieslist = sys.argv[1]
    outputfile = sys.argv[2]
    ncbi = NCBITaxa()

    with open (specieslist,'r') as splist:
        with open (outputfile,'w') as outfile:
            outfile.write('species' + '\t' + 'kingdom' + '\t' + 'phylum' + '\t' + 'class' + '\t' + 'order' + '\t' + 'family' + '\t' + 'genus' + '\n')
            for taxaname in splist:
                taxaname = taxaname.strip('\n')
                name2taxid = ncbi.get_name_translator([taxaname])
                if len(name2taxid) == 0:
                    outfile.write(taxaname + '\t' + '-' + '\t' + '-' + '\t' + '-' + '\t' + '-' + '\t' + '-' + '\t' + '-' + '\n')
                else:
                    
                    for id in name2taxid[taxaname]:
                        lineages = ncbi.get_lineage(id)
                    linamedic = ncbi.get_taxid_translator(lineages)  # linamedic: lineagename dictionary
                    randic = ncbi.get_rank(lineages)              # randic : ranks dictionary 

                    s = lookuplineage('species')
                    k = lookuplineage('kingdom')
                    p = lookuplineage('phylum')
                    c = lookuplineage('class')
                    o = lookuplineage('order')
                    f = lookuplineage('family')
                    g = lookuplineage('genus')
                    outfile.write(s + '\t '+ k + '\t' + p + '\t' + c + '\t' + o +'\t' + f + '\t' + g + '\n')

        outfile.close()
    splist.close() 