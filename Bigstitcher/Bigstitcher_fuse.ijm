//MP 24.05.2022
//fuse stitched file to xml+hdf5

pth = File.openDialog("Select input directory");
print("Source file: "+pth);

d=File.getParent(pth);
pth_out=d+File.separator;

run("Fuse dataset ...", 
"select="+pth+
" downsampling=1 pixel_type=[16-bit unsigned integer] "+
" image=Cached preserve_original fused_image=[Save as new XML Project (HDF5)]"+
"output_file_directory="+pth_out);