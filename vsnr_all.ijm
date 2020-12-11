//file parameters
suffix = ".ome.tif";
which="3D";

///////////////////
print("\\Clear");
input = getDirectory("Input directory containing raw data");
output = input+"vsnr/";
params_file = File.openDialog("VSNR parameters file"); 
//params_file="Z:/2020/2020_06/Bartek/2016A/vsnr3Dparams.txt";

processFolder_vsnr(input, output);


///////////////////
function processFolder_vsnr(input, output) {
	setBatchMode( true );
	list = getFileList(input);
	createFolder(output);

	for (i = 0; i < list.length; i++) {
		if(endsWith(list[i], suffix)) {
			processFile_vsnr(input+list[i], output+"/", "vsnr_"+substring(list[i], 0, indexOf(list[i], suffix)));
			print("file done: "+ list[i]);
		}
	}
   	print("DONE");
}

function processFile_vsnr(input_file, output_subdir, output_file) {
	print("Processing: " + input_file);
	open(input_file);
	if (which=="3D") {
		getDimensions(w, h, channels, slices, frames);
		if ((slices==1) & (frames>1)) Stack.setDimensions(channels, frames, frames);
		run("VSNR GPU 3D", "where=[Text File (.txt)] choose="+params_file);
	} else {
		run("VSNR GPU 2D", "where=[Text File (.txt)] choose="+params_file);
	}
	//selectWindow("vsnr_"+input_file);
	saveAs("Tiff", output_subdir+"/"+output_file);
	close();

   	close();
}

function createFolder(out_dir) {
	if (File.exists(out_dir)!=1) {
		print("Tworzę folder: " + out_dir);
		File.makeDirectory(out_dir);
	} else 
		print("Directory exists");
}