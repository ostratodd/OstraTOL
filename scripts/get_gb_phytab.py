#!/usr/bin/env python
# coding: utf-8

# In[18]:


#!/usr/bin/python
#How to read out a text file; input file is one of our accession tabs
#USAGE: python ./get_gb_phytab.py
#Author: Lisa Mesrop


# In[19]:


from Bio import Entrez
from Bio import SeqIO

import re
import time # 'time' package; I kept getting errors from NCBI about 'too many requests' so I used the time.sleep() function from the time package to resolve this problem. 
import os # 'os' package for setting up my path directories 


# In[20]:


# I'm creating my directory path; os.path.join function reads the system you're using and joins the path of your directories by the appropriate fwd or rvs slash, depending on your system. 
dir_path = os.path.join("data", "accessions") 
out_dir_path = os.path.join("data", "sequences")


# In[21]:


# This is going outside of my loop that I created below. 
Entrez.email = "lmesrop@ucsb.edu"


# In[23]:


# This is a fancy script I found online for reading and making a list of all files that are not directories in my dir_path. 
onlyfiles = [f for f in os.listdir(dir_path) if os.path.isfile(os.path.join(dir_path, f))]

for filename in onlyfiles: 
    # Combine directory path with filename to create the directory paths for all the txt files. 
    filepath = os.path.join(dir_path, filename)
    #print(filepath)
    
    with open(filepath) as fp: #using 'with' so I don't have to use file.close() function. 
        outfile = filename.replace('.txt', '.phytab') #changing the extension of my outfile. with .replace() function. 
        outpath = os.path.join(out_dir_path, outfile)

        lines = fp.readlines() #read in the lines from fp object
       # print(lines)
        gname = lines[0].strip() # .strip() fucntion only takes the zero line which is my gname I want which I want to use for phytab format later. I was having issues using regax for the gname since we have different genes. It was hard to make a regax expression that can pull out 18S, CO1 and ITS and etc. so I'm removing it from the header. On Osiris, you actually write the gname so its easier to put into phytab format.  
        #print(gname)
        
        accessions = [] #creating an empty list for where I will append my accessions in my line object. 
        
        for line in lines[1:]: #[1:] skips the first line which is my gname. 
            accessions.append(line.strip())
            #print(accessions)
            
        handle = Entrez.efetch(db="nucleotide", id=accessions, rettype="fasta", retmode="text")#used the list I created in the step before.
        record = SeqIO.parse(handle, "fasta")
        records = list(record)
        
        with open(outpath, 'w') as fp:

            for row in records:
                #rec_id = re.findall("([^\.]*)", row.id)[0]
                if "cf." in row.description:
                    species = re.findall("\S* (\S* \S* \S*)", row.description)[0] #using [0] so it pulls out the first element of my string. 
                    #print(species)
                else:
                    species = re.findall("\S* (\S* \S*)", row.description)[0]
                species = species.replace(" ", "_")
                #gname = re.findall(" ([A-Z0-9]{3})", row.description)[0]
                seq = row.seq

                line = "{}\t{}\t{}\t{}\n".format(species, gname, rec_id, seq)
                fp.write(line)




# In[ ]:





# In[ ]:





# In[ ]:




