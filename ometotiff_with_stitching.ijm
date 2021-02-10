setBatchMode( true );

//parametry_konwersji
remove = false;
n_remove = 1;

//parametry_stitchingu
overlap=20;

//start_script
input = getDirectory("Input directory");
output = input+"/tifs/";
if (File.exists(output)!=1) {
	print("Tworzę folder: " + output);
	File.makeDirectory(output);
}

//open dialog to let user ddefine the grid
Dialog.create("Number of tiles");
Dialog.addString("x= ", "1", 2);
Dialog.addString("y= ", "2", 2);
Dialog.show();
x = Dialog.getString();
y = Dialog.getString();
xInt=parseInt(x);
yInt=parseInt(y);
ile=xInt*yInt;

//ome to tif
suffix_raw = ".ome.tif";
processFolderOmetotiff(input, suffix_raw);

//prepare stitching
suffix = ".tif";
suff_ii="{ii}";
number_ii=lengthOf(suff_ii)-2;
ileplikow = 0;

input=output;

nazwa = processFolderCountfiles(input, suffix);
print("Znaleziono plikow: "+ileplikow);

if(ile>ileplikow)
	print("Za malo plikow do stitchingu!");
else {
	print("Prawidłowa liczba plikow");

	v = newArray(0,0,0);
	v = getSizes(input);
	unit = "µm";
	print("after getSizes "+ unit +" "+ v[0] +" "+ v[1] +" "+ v[2]);

	nazwaPliku=nazwa+suff_ii;
	print("Nazwa pliku bedzie taka: "+nazwaPliku);

	setBatchMode( false );
	
	type = "type=[Grid: column-by-column] order=[Down & Right                ]"; //kamera Hamamatsu
	grid_size = " grid_size_x="+x+" grid_size_y="+y;
	file_names = " file_names="+nazwaPliku+suffix;
	dir=" directory="+input;
	rest=" output_textfile_name=TileConfig.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap display_fusion computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]";
	restdisk=" output_textfile_name=TileConfig.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap display_fusion computation_parameters=[Save memory (but be slower)] image_output=[Write to disk]";
	params = type+grid_size+" tile_overlap="+overlap+" first_file_index_i=0"+dir+file_names+rest;
	run("Grid/Collection stitching", params);
	setVoxelSize(v[0], v[1], v[2], unit);
}

/////////////////////////////////////////////////////////////////////////////////
//funkcje
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

function processFolderOmetotiff(input, suffix_in) {
	list = getFileList(input);
	ileplikow = 0;
	//print("Przetwarzam katalog "+input);
	folderstring=substring(input,0,lengthOf(input)-1);
	folderstring=substring(folderstring, lastIndexOf(folderstring, "\\")+1, lengthOf(folderstring));

	for (i = 0; i < list.length; i++) {
		if(endsWith(list[i], suffix_in)) {
			ileplikow++;
			namestring=substring(list[i], 0, indexOf(list[i], "MMStack"));
			indx=substring(list[i], indexOf(list[i], "_Pos")+4, indexOf(list[i], suffix_in));
			print(indx);
			processFileOmetotiff(input+list[i], output+namestring+indx+".tif");
		}
	}
	print("Koniec "+ input + " ! Przetworzono plikow "+ileplikow);
	//print("koniec testu");
}

function processFileOmetotiff(input_file, output_file) {
	// do the processing here 
	
   	open(input_file);
   	if(remove) {
   		run("Slice Remover", "first=1 last=n_remove increment=1");
   	}
   	saveAs("Tiff", output_file);
   	close();

   	print("Zapisano: " + output_file);
   	print("");
}

function processFolderCountfiles(input, suffix) {
	list = getFileList(input);
	brak_nazwy=1;
	for (i = 0; i < list.length; i++) {
		if(endsWith(list[i], suffix)) {
			if(brak_nazwy) {
				nazwa=substring(list[i], 0, indexOf(list[i], suffix)-number_ii);
				brak_nazwy=0;
			}
			ileplikow++;
		}
	}
	return nazwa;
}

function getSizes(input) {
	list = getFileList(input);
	print("Trying to find dimensions of: "+input+list[0]);
	open(input+list[0], "virtual");
	vw=0;
	vh=0;
	vd=0;
	unit="";
	getVoxelSize(vw, vh, vd, unit);
	v = newArray(vw, vh, vd);

	close(list[0]);
	return v;
}