setBatchMode( true );

remove = true;
n_remove = 2;

input = getDirectory("Input directory");
output = input+"/tifs/";
if (File.exists(output)!=1) {
	print("Tworzę folder: " + output);
	File.makeDirectory(output);
}
suffix = ".ome.tif";

processFolder(input);


function processFolder(input) {
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
			processFile(input+list[i], output+namestring+indx+".tif");
		}
	}
	print("Koniec "+ input + " ! Przetworzono plikow "+ileplikow);
	//print("koniec testu");
}

function processFile(input_file, output_file) {
	// do the processing here 
	print("Przetwarzam plik: " + input_file);
	
   	open(input_file);
   	if(remove) {
   		run("Slice Remover", "first=1 last=n_remove increment=1");
   	}
	bigfile_file=replace(input_file, suffix, bigfile+suffix);

	if(File.exists(bigfile_file)) {
		print("Opening "+bigfile_file);
		open(bigfile_file);
		run("Concatenate...", "image1="+File.getName(input_file)+" image2="+File.getName(bigfile_file));
		//rename(name_to_process);
	}
   	
   	saveAs("Tiff", output_file);
   	close();

   	print("Zapisano: " + output_file);
   	print("");
}

