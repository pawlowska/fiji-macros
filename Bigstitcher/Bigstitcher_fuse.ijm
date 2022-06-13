//MP 24.05.2022
//fuse stitched file to xml+hdf5

pth = File.openDialog("Select xml of dataset to fuse");
print("Source file: "+pth);

pth_out=File.getParent(pth)+File.separator;

run("Fuse dataset ...", 
"select="+pth+
" downsampling=1 pixel_type=[16-bit unsigned integer] "+
" image=Cached preserve_original fused_image=[Save as new XML Project (HDF5)]"+
"output_file_directory="+pth_out);