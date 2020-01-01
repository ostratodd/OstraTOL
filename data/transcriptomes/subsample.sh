grep 18S oakley_2013_mbe.phytab > oakley_2013_18S.phytab
grep 28S oakley_2013_mbe.phytab > oakley_2013_28S.phytab

grep binary oakley_2013_mbe.phytab > oakley_2013_binary.phytab
grep multi oakley_2013_mbe.phytab > oakley_2013_multi.phytab

#remove gaps
perl -pi -e 's/\-//g' oakley_2013_18S.phytab
perl -pi -e 's/\-//g' oakley_2013_28S.phytab

#change to specific dataset name
perl -pi -e 's/\tbinary/\tbinary_Oakley_2013/g' oakley_2013_binary.phytab
perl -pi -e 's/\tmulti/\tmultistate_Oakley_2013/g' oakley_2013_multi.phytab
