/* author MP
 * flexible script converting ome.tiff to ordinary tif or tif series
 * stacks larger than 4GB are merged
 */

setBatchMode( true );

//convert to stacks or series?
series=false;

//remove first slices?
remove = true;
n_remove = 2;

//input file suffix and index
suffix = ".ome.tif";
start_indx="0";

//input&output directory
input = getDirectory("Input directory");

if(series) {
	output = input+"imageSeries/";
} else{
	output = input+"/tifs/";
}
if (File.exists(output)!=1) {
	print("Tworzę folder: " + output);
	File.makeDirectory(output);
}

processFolder(input, series);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function processFolder(input, series) {
	list = getFileList(input);
	ileplikow = 0;
	bigfile="_1";
	print("Przetwarzam katalog "+input);

	for (i = 0; i < list.length; i++) {
		if((endsWith(list[i], suffix))&&(endsWith(list[i], bigfile+suffix))!=1) {
			ileplikow++;
			namestring=substring(list[i], 0, indexOf(list[i], "MMStack"));
			indx=substring(list[i], indexOf(list[i], "_Pos")+4, indexOf(list[i], suffix));
			print(indx);
			processFile(input+list[i], output+namestring+"Pos"+indx+"/", namestring+"Pos"+indx+"_");
		}
	}
	print("Koniec "+ input + " ! Przetworzono plikow "+ileplikow);
}

function processFile(input_file, output_subdir, output_file){
	print("Now processing: " + input_file);
	
   	open(input_file);

   	if(remove) {
   		run("Slice Remover", "first=1 last=n_remove increment=1");
   	}

	//concatenate tiff with the "_1" file
	bigfile_file=replace(input_file, suffix,bigfile+suffix);
	if(File.exists(bigfile_file)) {
		print("Opening "+bigfile_file);
		open(bigfile_file);
		run("Concatenate...", "image1="+File.getName(input_file)+" image2="+File.getName(bigfile_file));
	}

	//save
	if(series) {
		print("series");
		if (File.exists(output_subdir)!=1) {
			print("Creating: " + output_subdir);
			File.makeDirectory(output_subdir);
		}

		params = "format=TIFF name="+output_file+" start="+start_indx+" "+"save=["+output_subdir+output_file+".tif]";
   		run("Image Sequence... ", params); 
	} else {
		print("not series");
		saveAs("Tiff", output+output_file);
	}
		
	close();
	
   	print("Saved: " + output_file);
   	print("");
}