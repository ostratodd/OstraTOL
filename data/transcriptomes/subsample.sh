grep 18S oakley_2013_mbe.phytab > oakley_2013_18S.phytab
grep 28S oakley_2013_mbe.phytab > oakley_2013_28S.phytab

#remove gaps
perl -pi -e 's/\-//g' oakley_2013_18S.phytab
perl -pi -e 's/\-//g' oakley_2013_28S.phytab
