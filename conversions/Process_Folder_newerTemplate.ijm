/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ String (label = "File suffix", value = ".tif") suffix

setBatchMode(true);

// See also Process_Folder.py for a version of this code
// in the Python scripting language.

processFolder(input);
print("DONE");

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		//if(File.isDirectory(input + File.separator + list[i]))
		//	processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, input, list[i]);
	}
}

function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + input + File.separator + file);
	run("TIFF Virtual Stack...", "open="+input + File.separator + file);
	makeRectangle(10, 10, 100, 100);
	run("Specify...", "width=2410 height=2630 x=280 y=170 scaled");
	run("Crop");
 	saveAs("tiff",output + File.separator + file);
 	close();
	print("Saving to: " + output + File.separator + file);
}
