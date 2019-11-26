#!/usr/bin/python
#How to read out a text file; input file is one of our accession tabs
#USAGE: python ./script.py
#Author: Lisa Mesrop

#coding=utf-8
import re
f = open("ListID.txt", 'r')
reData = f.read()
result = re.findall("[A-Z]{2}[0-9]{6}", reData)
print(result)

#from Bio import Entrez
#Entrez.email = "lmesrop@ucsb.edu"
#handle = Entrez.efetch(db="nucleotide", id="result",rettype="fasta", retmode="text")
#print(handle.read())


from Bio import Entrez
Entrez.email = "lmesrop@ucsb.edu"
handle = Entrez.efetch(db="nucleotide", id=result,rettype="fasta", retmode="text")
print(handle.read())

