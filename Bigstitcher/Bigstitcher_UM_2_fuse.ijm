/*
 * ULTRAMICROSCOPE FILE 2/2
 * FUSE STITCHED IMAGES IN BIGSTITCHER
 * data will be resaved as HDF5 ready to open in Bigstitcher and stitch
 * results are saved in new folder "stitched_(highest.number)"
 *  
 * default settings:
 * - saved as TIFF
 * - 
 * 
 * requires from the user: 
 * - selecting input directory
 */

// output file name and input directory
//prefix = getString("Define output file name:", "dataset");
//pth = getDirectory("Select input directory");
print("Your path is: "+pth);

// fuse dataset
run("Fuse dataset ...",
	"select="+pth_output+prefix+".xml process_angle=[All angles] process_channel=[All channels] "+
	"process_illumination=[All illuminations] process_tile=[All tiles] process_timepoint=[All Timepoints] "+
	"bounding_box=[Currently Selected Views] downsampling=1 pixel_type=[16-bit unsigned integer] "+
	"interpolation=[Linear Interpolation] image=[Virtual] interest_points_for_non_rigid=[-= Disable Non-Rigid =-] "+
	"blend produce=[Each timepoint & channel] "+
	"preserve_original_data_anisotropy=1"+ //this line might not work?
	"fused_image=[Save as (compressed) TIFF stacks] "+
	"output_file_directory="+pth_output);

// Log file save
getInfo("Log");
saveAs("text", pth_output+"log.txt");
print("FUSION IS DONE!");

// quit after we are finished
eval("script", "System.exit(0);");

/* NOTES
 *  https://imagej.net/plugins/bigstitcher/
 *  
 */