// Macro for Image correction and stitching procedure using BaSiC and Grid/Collection Stitching
// --------------------------------------------------------------------------------------------


// USER SETTINGS
file = "m21-5";
x = 15; // x-axis tiles
y = 17; // y-axis tiles
path = "/Users/marcin/Nencki/OPUS 2020/IntelliCage/BAC-DID-spinningdisk";


folder = file;
path_folder = path + "/" + folder;


// rename files in the folder
nameArray = getFileList(path_folder);
for ( i = 0; i < nameArray.length; i++ ) {
	name_last = substring(nameArray[i], lengthOf(nameArray[i])-7);	
	if ( matches(name_last, ".*m.*") ) {	
		name_last = substring(name_last, lengthOf(name_last)-6);
		if ( matches(name_last, ".*m.*") ) {
			name_last = substring(name_last, lengthOf(name_last)-5);
			name_new = file + "-00" + name_last;
		} else {
			name_new = file + "-0" + name_last;
		}
	} else {
		name_new = file + "-" + name_last;
	}
	File.rename( path_folder + "/" + nameArray[i], path_folder + "/" + name_new );
	print("File saved: " + name_new);
}


// files import and preparation
run("Image Sequence...", "open='" + path + "/" + folder + "' starting=0 sort");
run("Split Channels");

// use BaSiC plugin and save result
selectWindow(folder + " (red)");
run("BaSiC ", "processing_stack=[" + folder + " (red)] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
File.makeDirectory(path + "/" + folder + "/" + file + "-corrected");
run("Image Sequence... ", "format=TIFF name=" + file + "- digits=4 save=[" + path + "/" + folder + "/" + file + "-corrected]");

// stitch images and save
run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x=" + x + " grid_size_y=" + y + " tile_overlap=10 first_file_index_i=0 directory=[" + path + "/" + folder + "/" + file + "-corrected] file_names=" + file + "-{iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT");
saveAs("PNG", path + "/" + file + ".png");

// close and notify
while (nImages>0) {
	selectImage(nImages); 
	close(); 
	}
if (isOpen("Log")) {
	selectWindow("Log");
	run("Close" );
	}

print("DONE!");
print("Your stitched file '" + file + "' was saved in:");
print(path);