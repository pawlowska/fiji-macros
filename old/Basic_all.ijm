setBatchMode( true );

//downsampling parameters to reduce data size for Basic
downsample=true;
first_d=10;
inc_d=15;

//remove first slices
remove = true;
n_remove = 2;

input = getDirectory("Input directory");
nazwa_output="imageSeries_subset/";
output = input+nazwa_output;
createFolder(output);

suffix = ".ome.tif";
start_indx="0";

flat_file="flat_subset.tif";
dark_file="dark_subset.tif";

//create subset
processFolder(input);

//run Basic
print("Initialising BaSiC.....");
open(output);
basic_input=File.name;

params_basic="processing_stack="+basic_input+
				" flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] correction_options=[Compute shading only]";
run("BaSiC ", params_basic);
print("BaSiC koniec");

//save and close Basic results
saveAndClose("Flat-field:"+basic_input, flat_file);
saveAndClose("Dark-field:"+basic_input, dark_file);
print("Zapisywanie flat i dark koniec");

//correct all data
output_cor = input+"imageSeries_corBasic/";
createFolder(output_cor);
processFolder_convertUsingFiles(input, output_cor);

print("GOTOWE!");

///////////////helper functions
function saveAndClose(nazwa_okna, nazwa_pliku) {
	selectWindow(nazwa_okna);
	print(nazwa_okna);
	saveAs("Tiff", input+nazwa_pliku);
	close();
}

function processFolder(input) {
	list = getFileList(input);
	ileplikow = 0;
	print("Przetwarzam katalog "+input);

	for (i = 0; i < list.length; i++) {
		if(endsWith(list[i], suffix)) {
			ileplikow++;
			namestring=substring(list[i], 0, indexOf(list[i], "MMStack"));
			indx=substring(list[i], indexOf(list[i], "_Pos")+4, indexOf(list[i], ".ome"));
			processFile(input+list[i], output+"/", namestring+"Pos"+indx+"_");
		}
	}
	print("Koniec "+ input + " ! Przetworzono plikow "+ileplikow);
}

function processFolder_convertUsingFiles(input, output) {
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
			processFile_correct(input+list[i], output+namestring+"Pos"+indx+"/", namestring+"Pos"+indx+"_");
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
	run("TIFF Virtual Stack...", "open="+input_file);

	print(nSlices);

	//downsample if set
	if(downsample) {
		run("Slice Keeper", "first="+first_d+" increment="+inc_d);
	}

	print(nSlices);

   	//save as image sequence
   	params = "format=TIFF name="+output_file+" start="+start_indx+" "+"save=["+output_subdir+output_file+".tif]";
   	run("Image Sequence... ", params); 
   	close();

   	print("Zapisano: " + output_file);
   	print("");
}

function processFile_correct(input_file, output_subdir, output_file) {
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
		
	params_basic_file="processing_stack="+
		File.getName(input_file)+" flat-field="+flat_file+" dark-field="+dark_file+
		" shading_estimation="+shading_skip+" correction_options=[Compute shading and correct images]";
	run("BaSiC ", params_basic_file);
	nazwa_cor="Corrected:"+File.getName(input_file);
	selectWindow(nazwa_cor);
	
   	params_saving = "format=TIFF name="+output_file+" start="+start_indx+" "+"save=["+output_subdir+output_file+".tif]";
   	run("Image Sequence... ", params_saving); 
   	close();

	
   	print("Zapisano: " + output_file);
   	print("");
}