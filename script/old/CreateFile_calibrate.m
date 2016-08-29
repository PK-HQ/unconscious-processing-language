function[] = CreateFile_calibrate(fName_r, ResultSet)

% RESULT TEXT FILE
% 1 Trial #
% 2 Sentence ID
% 3 CON                :  1=CON 2=InCON
% 4 FLIP               :  1=Noflip 2=Flip 
% 5 Stimulus location  :  1=Right 2=Left
% 6 Cue Validity       :  1=Valid 2=Invalid
% 7 Break location     :  0=Non-broken 1=Right 2=Left
% 6 Broken/Unbroken    :  0=Non-broken 1=broken
% 7 Suppression TIME   :  ...
total_trials= 40;
fd = fopen(fName_r, 'w');
for m=1:total_trials
    fprintf(fd, '%3d %3d %d %d %d %d %d %d %d %10.4f\n', ResultSet(m,:));
end
fclose(fd);

end
