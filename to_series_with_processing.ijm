setBatchMode( true );

remove = false;
n_remove = 2;

//process=true;
//ball_radius=100

downsample=true;
first_d=5;
inc_d=10;

input = getDirectory("Input directory");
output = input+"imageSeries_subset/";
createFolder(output);

suffix = ".ome.tif";
start_indx="0";

processFolder(input);

function processFolder(input) {
	list = getFileList(input);
	ileplikow = 0;
	print("Przetwarzam katalog "+input);

	for (i = 0; i < list.length; i++) {
		if(endsWith(list[i], suffix)) {
			ileplikow++;
			namestring=substring(list[i], 0, indexOf(list[i], "MMStack"));
			indx=substring(list[i], indexOf(list[i], "_Pos")+4, indexOf(list[i], ".ome"));
			processFile(input+list[i], output+namestring+"Pos"+indx+"/", namestring+"Pos"+indx+"_");
		}
	}
	print("Koniec "+ input + " ! Przetworzono plikow "+ileplikow);
}

function createFolder(out_dir) {
	if (File.exists(out_dir)!=1) {
		print("Tworzę folder: " + out_dir);
		File.makeDirectory(out_dir);
	}
}

function processFile(input_file, output_subdir, output_file) {
	print("Przetwarzam plik: " + input_file);
	createFolder(output_subdir);
	open(input_file);

	//remove initial slices if set
   	if(remove) {
   		run("Slice Remover", "first=1 last=n_remove increment=1");
   	}

	//downsample if set
	if(downsample) {
		run("Slice Keeper", "first="+first_d+" increment="+"inc_d");
	}

	//process_params="rolling="+ball_radius+" stack";
	//if(process) {
	//	run("Subtract Background...", process_params);
	//}

   	//save as image sequence
   	params = "format=TIFF name="+output_file+" start="+start_indx+" "+"save=["+output_subdir+output_file+".tif]";
   	run("Image Sequence... ", params); 
   	close();

   	print("Zapisano: " + output_file);
   	print("");
}

