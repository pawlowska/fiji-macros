/* SCRIPT FOR VIGNETTING ("SHADOWS") REMOVAL
 * uses Basic plugin (must be installed)
 * input: tif or ome.tif
 * output: tif stack or series
 * 
 * divided in 3 steps:
 * 1. a subset of data is created
 * 2. 'flat' and 'dark' files computed
 * 3. correction done on each original stack
 */


//PRESS RUN

/////////////////////////////////////////////////////////////////////
print("\\Clear");

#@ File (label = "Input directory containing raw data", style = "directory") input
#@ String (label = "File suffix", value = ".ome.tif") suffix 
#@ String (label = "Saving format", choices={"stacks", "series"}, style="radioButtonHorizontal") saving 

//output_subset=Basic_create_subset(input, 5, 15);

output_subset = input+"\\imageSeries_subset\\";
Basic_bckg_from_subset(output_subset, "flat_subset.tif", "dark_subset.tif");

Basic_correct(input, "flat_subset.tif", "dark_subset.tif", saving);

print("DONE!");

/////////////////////////////////////////////////////////////////////
function Basic_create_subset(input, first_d, inc_d) {
	//create subset
	output = input+"\\imageSeries_subset\\";
	processFolder_subset(input, output, first_d, inc_d);
	return output; 
}

function Basic_bckg_from_subset(dir_subset, flat_file, dark_file) {
	setBatchMode(true);
	print("STEP 2: Initialising BaSiC.....");
	open(dir_subset);
	basic_input=File.name;

	params_basic="processing_stack="+basic_input+
				" flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] correction_options=[Compute shading only]";
	run("BaSiC ", params_basic);
	print("Determining flat and dark is done");

	//save and close Basic results
	saveAndClose("Flat-field:"+basic_input, File.getParent(dir_subset), flat_file);
	saveAndClose("Dark-field:"+basic_input, File.getParent(dir_subset), dark_file);
}

//remove first slices
remove = true;
n_remove = 2;

function Basic_correct(input, flat_file, dark_file, saving) {
	setBatchMode(true);

	output = input+"\\imageSeries_corBasic\\";
	createFolder(output);

	//correct all data
	processFolder_convertUsingFiles(input, output, flat_file, dark_file, saving);
}

/////////////////////////////////////////////////////////////////////

function createFolder(out_dir) {
	if (File.exists(out_dir)!=1) {
		print("Tworzę folder: " + out_dir);
		File.makeDirectory(out_dir);
	} else 
		print("Directory exists");
}

function saveAndClose(nazwa_okna, dir, nazwa_pliku) {
	selectWindow(nazwa_okna);
	saveAs("Tiff", dir+"/"+nazwa_pliku);
	close();
}

function processFolder_subset(input, output, first_d, inc_d) {
	setBatchMode( true );
	list = getFileList(input);
	createFolder(output);

	for (i = 0; i < list.length; i++) {
		showProgress(i, list.length);
		if(endsWith(list[i], suffix)) 
			processFile_subset(input+'/'+list[i], output+"/", substring(list[i], 0, indexOf(list[i], suffix))+'_',
			first_d, inc_d);
	}
	print("Subset created: "+ output);
   	print("");
}

function processFile_subset(input_file, output_subdir, output_file, first_d, inc_d) {
	print("Processing: " + input_file);
	run("TIFF Virtual Stack...", "open="+input_file);
	run("Slice Keeper", "first="+first_d+" increment="+"inc_d");

   	//save as image sequence
   	params = "format=TIFF name="+output_file+" start="+0+" "+"save=["+output_subdir+output_file+".tif]";
   	run("Image Sequence... ", params); 
   	close();
}


function processFolder_convertUsingFiles(input, output, flat_file, dark_file, saving) {
	open(flat_file);
	open(dark_file);
	print("'flat' and 'dark' files found");

	remove=false;
	n_remove=3;
	
	list = getFileList(input);
	ileplikow = 0;

	bigfile="_1";

	for (i = 0; i < list.length; i++) {
		if((endsWith(list[i], suffix))&&(endsWith(list[i], bigfile+suffix))!=1) {
			
			ileplikow++;
			namestring=substring(list[i], 0, indexOf(list[i], "MMStack"));
			indx=substring(list[i], indexOf(list[i], "_Pos")+4, indexOf(list[i], suffix));
			
			f=input+"\\"+list[i];
			corrected_name=processFile_correct(f, remove, n_remove, flat_file, dark_file);
			close(list[i]);
			
			//save
			print("Correction done, saving...");
			if (saving=='series') {
				processFile_save_toseries(corrected_name, output+namestring+"Pos"+indx+"/", namestring+"Pos"+indx+"_",0);
			} else if (saving=='stacks') {
				processFile_save_totif(corrected_name, output, namestring+"Pos"+indx);
			} else
				exit("Wrong or missing SAVING parameter");
		}
	}
	run("Close All");
	print("Koniec "+ input + " ! Przetworzono plikow "+ileplikow);
}

function processFile_correct(input_file, remove, n_remove, flat_file, dark_file) {
	print("Processing:  " + input_file);
	
   	open(input_file);
   	name_to_process=File.getName(input_file);
   	if(remove) {
   		run("Slice Remover", "first=1 last=n_remove increment=1");
   	}

	bigfile_file=replace(input_file, suffix,bigfile+suffix);

	if(File.exists(bigfile_file)) {
		print("Opening "+bigfile_file);
		open(bigfile_file);
		run("Concatenate...", "image1="+File.getName(input_file)+" image2="+File.getName(bigfile_file));
		rename(name_to_process);
	}

	getPixelSize(unit, pw, ph, pd);

	//correct open file
	print("Correcting...");
	shading_skip="[Skip estimation and use predefined shading profiles]";
	params_basic_file=
		"processing_stack="+name_to_process+" flat-field="+flat_file+" dark-field="+dark_file+
		" shading_estimation="+shading_skip;
	run("BaSiC ", params_basic_file);

	setVoxelSize(pw, ph, pd, unit);
	return "Corrected:"+name_to_process;
}


function processFile_save_toseries(input_image, output_subdir, output_file, start_indx) {
	//save corrected file
	createFolder(output_subdir);
	selectWindow(input_image);
   	params_saving = "format=TIFF name="+output_file+
   					" start="+start_indx+
   					" save=["+output_subdir+output_file+".tif]";
   	print(params_saving);
   	run("Image Sequence... ", params_saving); 
   	close();

   	print("");
}

function processFile_save_totif(input_image, output_cor, output_file) {
	//save corrected file
	saveAndClose(input_image, output_cor, output_file+".tif");
	
   	print("Saved: " + output_file);
   	print("");
}