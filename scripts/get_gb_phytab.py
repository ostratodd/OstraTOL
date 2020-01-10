#!/usr/bin/env python
# coding: utf-8

# In[2]:


#!/usr/bin/python
#This script does two things:(1) Grab accession files from Genbank (2) Reformat fasta file to phytab file. 
#USAGE: python ./get_gb_phytab.py
#Author: Lisa Mesrop


# In[ ]:


from Bio import Entrez
from Bio import SeqIO

import os
import re
import time 

dir_path = os.path.join("data", "accessions") 
out_dir_path = os.path.join("data", "sequences")

onlyfiles = [f for f in os.listdir(dir_path) if os.path.isfile(os.path.join(dir_path, f))]

for filename in onlyfiles: 
    filepath = os.path.join(dir_path, filename)
    
    
    with open(filepath) as fp: 
        outfile = filename.replace('.txt', '.phytab') 
        outpath = os.path.join(out_dir_path, outfile)

        lines = fp.readlines() 
        gname = lines[0].strip() 
        
        accessions = [] 
        for line in lines[1:]: 
            accessions.append(line.strip())
            
        Entrez.email = "lmesrop@ucsb.edu"    
        handle = Entrez.efetch(db="nucleotide", id=accessions, rettype="gb", retmode="text")
        record = SeqIO.parse(handle,"gb")
        #handle = Entrez.efetch(db="nucleotide", id=accessions, rettype="fasta", retmode="text")
        #record = SeqIO.parse(handle, "fasta")
        records = list(record)
        
        with open(outpath, 'w') as fp:

            for row in records:
                #print(row)
                rec_id = row.id
                #rec_id = re.findall("([^\.]*)", row.id)[0]
                #if "cf." in row.description:
                #    species = re.findall("\S* (\S* \S* \S*)", row.description)[0] 
                #else:
                #    species = re.findall("\S* (\S* \S*)", row.description)[0]
                species = row.annotations["organism"]
                species_replace = species.replace(" ", "_")
                #gname = re.findall(" ([A-Z0-9]{3})", row.description)[0]
                seq = row.seq

                line = "{}\t{}\t{}\t{}\n".format(species_replace, gname, rec_id, seq)
                fp.write(line)


# In[ ]:





# In[ ]:




