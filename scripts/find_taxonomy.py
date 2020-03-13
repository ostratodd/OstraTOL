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
        for lineage in lineages:
            if randic[lineage] == category:
                category = linamedic[lineage]
                return category
        else:
            return '-'
    # print(s + '\t '+ k + '\t' + p + '\t' + c + '\t' + o +'\t' + f + '\t' + g + '\n')

    specieslist = sys.argv[1]
    outputfile = sys.argv[2]
    ncbi = NCBITaxa()

    with open (specieslist,'r') as splist:
        with open (outputfile,'w') as outfile:
            outfile.write('species' + '\t' + 'kingdom' + '\t' + 'phylum' + '\t' + 'subphylum' + '\t' + 'superclass'+ '\t' + 'class' + '\t' + 'subclass' + '\t' + 'order' + '\t' + 'suborder'+ '\t' + 'superfamily' + '\t' + 'family' + '\t' + 'genus' + '\t' 'species' '\n')
            for taxaname in splist:
                taxaname = taxaname.strip('\n')
                name2taxid = ncbi.get_name_translator([taxaname])
                if len(name2taxid) == 0:
                    outfile.write(taxaname + '\n')  #    + '\t' + '-' + '\t' + '-' + '\t' + '-' + '\t' + '-' + '\t' + '-' + '\t' + '-' + '\t' + '-'+ '\t' + '-'+ '\t' + '-'+ '\t' + '-'+ '\t' + '-'+ '\n')
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
                    sph = lookuplineage('subphylum')
                    supc = lookuplineage('superclass')
                    subc = lookuplineage('subclass')
                    subo = lookuplineage('suborder')
                    supf = lookuplineage('superfamily')
                    outfile.write(taxaname + '\t '+ k + '\t' + p + '\t' + sph + '\t' + supc + '\t' + c + '\t' +subc + '\t' + o + '\t' +subo + '\t' + supf +'\t' + f + '\t' + g + '\t' + s + '\n')

        outfile.close()
    splist.close() 