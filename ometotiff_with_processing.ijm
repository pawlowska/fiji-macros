setBatchMode( true );

remove = false;
process=false;
n_remove = 2;
bckg_radius=100;

input = getDirectory("Input directory");
output = input+"/tifs/";
if (File.exists(output)!=1) {
	print("Tworzę folder: " + output);
	File.makeDirectory(output);
}
//output = getDirectory("Output directory");

suffix = ".ome.tif";

processFolder(input);

function linearizeNameString(namestring) {
	stala="Pos_";
	poz1=indexOf(namestring, stala)+lengthOf(stala);
	poz2=poz1+4;
	nazwa=substring(namestring, 0, poz1);
	print(nazwa);
	valX=parseInt(substring(namestring, poz1, poz2-1));
	print(valX);
	valY=parseInt(substring(namestring, poz2, lengthOf(namestring)));
	print(valY);
}

function parseNameString(namestring) {
	stala="Pos_";
	ext=".ome"
	poz1=indexOf(namestring, stala)+lengthOf(stala);
	poz2=indexOf(namestring, ext)
	nazwa=substring(namestring, 0, poz1);
	print(nazwa);
	valX=parseInt(substring(namestring, poz1, poz2-1));
	print(valX);
	valY=parseInt(substring(namestring, poz2, lengthOf(namestring)));
	print(valY);
}

function processFolder(input) {
	list = getFileList(input);
	
	ileplikow = 0;
	print("Przetwarzam katalog "+input);
	folderstring=substring(input,0,lengthOf(input)-1);
	folderstring=substring(folderstring, lastIndexOf(folderstring, "\\")+1, lengthOf(folderstring));

	for (i = 0; i < list.length; i++) {
		print(list[i]);
		if(endsWith(list[i], suffix)) {
			ileplikow++;
			namestring=substring(list[i], 0, indexOf(list[i], "Pos"));
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
   	
	process_params="rolling="+bckg_radius+" stack";
	//process_params="rolling="+bckg_radius+" stack sliding";
	if(process) {
		run("Subtract Background...", process_params);
	}
   	
   	saveAs("Tiff", output_file);
   	close();

   	print("Zapisano: " + output_file);
   	print("");
}

