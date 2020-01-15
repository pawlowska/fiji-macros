setBatchMode( true );

remove = false;
n_remove = 2;

process=true;

input = getDirectory("Input directory");
output = input+"imageSeries_corBasic/";
createFolder(output);

suffix = ".ome.tif";
start_indx="1";

flat_file="flat_subset.tif";
dark_file="dark_subset.tif";

processFolder(input);

function createFolder(out_dir) {
	if (File.exists(out_dir)!=1) {
		print("Tworzę folder: " + out_dir);
		File.makeDirectory(out_dir);
	}
}

function processFolder(input) {
	print("Szukam plikow tla");
	open(flat_file);
	open(dark_file);
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

function processFile(input_file, output_subdir, output_file) {
	// do the processing here 
	print("Przetwarzam plik: " + input_file);

	createFolder(output_subdir);
	
   	open(input_file);
   	if(remove) {
   		run("Slice Remover", "first=1 last=n_remove increment=1");
   	}
	
	flat_none="None";
	dark_none="None";
	shading_skip="[Skip estimation and use predefined shading profiles]";
	shading_do="[Estimate shading profiles]";
				
	if(process) {
		params_basic_file="processing_stack="+
			File.getName(input_file)+" flat-field="+flat_file+" dark-field="+dark_file+
			" shading_estimation="+shading_skip+" correction_options=[Compute shading and correct images]";
		run("BaSiC ", params_basic_file);
		nazwa_cor="Corrected:"+File.getName(input_file);
		selectWindow(nazwa_cor);
	};

   	params = "format=TIFF name="+output_file+" start="+start_indx+" "+"save=["+output_subdir+output_file+".tif]";
   	run("Image Sequence... ", params); 
   	close();

	
   	print("Zapisano: " + output_file);
   	print("");
}

