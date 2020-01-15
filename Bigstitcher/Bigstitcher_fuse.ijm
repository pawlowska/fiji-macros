//nie pamiętam czy to działa

pth="E:/Dane/2018/2018_08/2018_08_01/alignment_R_start_2/dataset.xml";
pth_out="E:/Dane/2018/2018_08/2018_08_01/alignment_R_start_2/.";

run("Fuse dataset ...", 
"select="+pth+
" downsampling=1 pixel_type=[16-bit unsigned integer] interpolation=[Linear Interpolation] image=Virtual interest_points_for_non_rigid=[-= Disable Non-Rigid =-] preserve_original fused_image=[Save as (compressed) TIFF stacks] "+
"output_file_directory="+pth_out);