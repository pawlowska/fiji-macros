setBatchMode( true );

remove = true;
n_remove = 2;

process=true;
ball_radius=100

input = getDirectory("Input directory");
output = input+"imageSeries_corUsingFiles/";
if (File.exists(output)!=1) {
	print("Tworzę folder: " + output);
	File.makeDirectory(output);
}

//suffix = ".ome.tif";
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

function processFile(input_file, output_subdir, output_file) {
	// do the processing here 
	print("Przetwarzam plik: " + input_file);

	if (File.exists(output_subdir)!=1) {
		print("Tworzę folder: " + output_subdir);
		File.makeDirectory(output_subdir);
	}
	
   	open(input_file);
   	if(remove) {
   		run("Slice Remover", "first=1 last=n_remove increment=1");
   	}

	flat_file="flat_subset.tif";
	flat_none="None";
	dark_file="dark_subset.tif";
	dark_none="None";
	shading_skip="[Skip estimation and use predefined shading profiles]";
	shading_do="[Estimate shading profiles]";

	params_basic_file="processing_stack="+
			File.getName(input_file)+" flat-field="+flat_file+
			" dark-field="+dark_file+" shading_estimation="+shading_skip+
			" shading_model=[Estimate flat-field only (ignore dark-field)]  setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images]";

	if(process) {
		run("BaSiC ", params_basic_file);
		nazwa_cor="Corrected:"+File.getName(input_file);
		selectWindow(nazwa_cor);
	};

   	params = "format=TIFF name="+output_file+" start="+start_indx+" "+"save=["+output_subdir+output_file+".tif]";
   	run("Image Sequence... ", params); 
   	close();

	//nazwa_flat="Flat-field:"+File.getName(input_file);
	//selectWindow(nazwa_flat);
	//saveAs("Tiff", input+nazwa_flat);
	
   	print("Zapisano: " + output_file);
   	print("");
}

