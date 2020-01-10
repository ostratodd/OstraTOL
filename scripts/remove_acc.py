#!/usr/bin/env python
# coding: utf-8

# In[ ]:


#!/usr/bin/python
#This script checks if the accession numbers in the .txt files match the accession numbers from .phytab files. Accession numbers in .phytab files were retrieved from Genbank. If the accession numbers match, then it will place them in a match folder. If the accession numbers don't match, then it will place them in a delete folder.   
#USAGE: python ./remove_acc_nomatch_LM.py
#Author: Lisa Mesrop


# In[12]:


import os 
import re

# Create my directory paths; I'm creating two additional paths for accession numbers that match and for accession numbers that don't match the phytab files. 
acc_dir_path = os.path.join("data", "accessions")
seq_dir_path = os.path.join("data", "sequences")
match_dir_path = os.path.join("data", "matches")
delete_dir_path = os.path.join("data", "delete")

# Make a list of my files in my path. 
acc_files = [f for f in os.listdir(acc_dir_path) if os.path.isfile(os.path.join(acc_dir_path, f))]
seq_files = [f for f in os.listdir(seq_dir_path) if os.path.isfile(os.path.join(seq_dir_path, f))]
#print(seq_files)

# Loop through each accession .txt file one at a time
for acc_filename in acc_files:
    #print(acc_filename)
    
    # Create a filename string from the .txt filename swapping .txt to .phytab so we can match below. 
    seq_filename = acc_filename.replace('.txt', '.phytab')
    #print(seq_filename)

    # Check if .txt file has matching .phytab file. 
    if seq_filename in seq_files:
        # Since our .txt and .phytab match we can create filenames and filepaths for .match and .delete.
        match_filename = acc_filename.replace('.txt', '.match')
        delete_filename = acc_filename.replace('.txt', '.delete')
        
        # Combine directory path with filename
        acc_filepath = os.path.join(acc_dir_path, acc_filename)
        seq_filepath = os.path.join(seq_dir_path, seq_filename)
        match_filepath = os.path.join(match_dir_path, match_filename)
        del_filepath = os.path.join(delete_dir_path, delete_filename)
        #print(match_filepath)

        # Open the accession and .phytab files
        with open(acc_filepath) as acc_fp, open(seq_filepath) as seq_fp:
    
            # Create lists to store matching accession data and delete unmatching accession data.
            match_data = []
            del_data = []
            
            # Read in the accession file
            acc_lines = acc_fp.readlines()
            acc_data = []
            # Loop over each line of .txt skipping the first one with gname
            for acc_line in acc_lines[1:]:
                # Strip removes whitespace from the beginning and end of each line of text. Add each accession id to the acc_data list
                acc_data.append(acc_line.strip())
                #print(acc_data)
            
            # Read in phytab file
            seq_lines = seq_fp.readlines()
            # print(lines)
            for seq_line in seq_lines:
                # Get accession id from phytab file; split takes a string and breaks it apart into a list. This removes the tabs from the split so there is no more whitespace
                phytab_acc_id = seq_line.split('\t')[2] #Pulling out the second element of the list which is accesion id. 
                #print(phytab_acc_id)

                # Create an accesion without the .1 at the end in case the .txt file is missing it. The .txt files we initally made does not have the '*.1' at the end for some accession numbers and so if we want to match the accession number in phytab to the accesion number in .txt files, we need to remove the '*.1' from the phytab files I pulled out.  
                phytab_acc_id_no_suffix = re.findall("([^\.]*)", phytab_acc_id)[0]
        
                # Match accession from .phytab (accession retrieved by Entrez_fetch) to the .txt file; if that doesn't work try removing .1 from the .phytab file to see if that matches in case the .txt file is missing it using 'or'
                if phytab_acc_id in acc_data or phytab_acc_id_no_suffix in acc_data:
                    match_data.append(seq_line)
                else:
                    del_data.append(seq_line)
            
            # If match data list is not empty then create file and write to it
            if match_data:
                with open(match_filepath, 'w') as match_fp:
                    match_fp.write(''.join(match_data)) 
                    # Join takes a list and turns it into a string, the quotes before it are how you might want to separate the data. 
                    
            # If delete data list is not empty then create file and write to it
            if del_data:
                with open(del_filepath, 'w') as del_fp:
                    del_fp.write(''.join(del_data))
    
                






# In[ ]:




