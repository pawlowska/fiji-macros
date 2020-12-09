//quick stitching using Plugins-> Stitching -> Grid/Collection...


////////////////////TODO
/*
 * w ogóle sizes jak nie ma 
 * sprawdzić różny blending
*/

input = getDirectory("Input directory");

overlap=5;

//suffix = ".tif";
//suffix = "_1.tif"
suffix = ".ome.tif";
l_suffix=lengthOf(suffix);
suff_ii="{ii}";
number_ii=lengthOf(suff_ii)-2;

nazwa = processFolder(input);
print("Znaleziono plikow: "+ileplikow)

v = newArray(0,0,0);
v = getSizes(input);
unit = "µm";
print("after getSizes "+ unit +" "+ v[0] +" "+ v[1] +" "+ v[2]);


Dialog.create("Number of tiles");
Dialog.addString("x= ", "1", 2);
Dialog.addString("y= ", "2", 2);
Dialog.show();
x = Dialog.getString();
y = Dialog.getString();
xInt=parseInt(x);
yInt=parseInt(y);
ile=xInt*yInt;

if(ile>ileplikow)
	print("Za malo plikow!");
else {
	print("Wystarczy plikow");

	nazwaPliku=nazwa+suff_ii;
	print("Nazwa pliku bedzie taka: "+nazwaPliku);

	//type = "type=[Grid: column-by-column] order=[Down & Left]"; //Standa
	//type = "type=[Grid: row-by-row] order=[Up & Left]";
	type = "type=[Grid: column-by-column] order=[Down & Right                ]"; //kamera Hamamatsu
	//type = "type=[Grid: column-by-column] order=[Up & Right]"; //kamera Quantem
	grid_size = " grid_size_x="+x+" grid_size_y="+y;
	file_names = " file_names="+nazwaPliku+suffix;
	dir=" directory="+input;
	//rest=" output_textfile_name=TileConfig.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap display_fusion computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]";
	//rest_old=" output_textfile_name=TileConfig.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap display_fusion use_virtual_input_images";
	rest_virtual=" output_textfile_name=TileConfig.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap display_fusion use_virtual_input_images";	
	params = type+grid_size+" tile_overlap="+overlap+" first_file_index_i=0"+dir+file_names+rest_virtual;
	run("Grid/Collection stitching", params);
	setVoxelSize(v[0], v[1], v[2], unit);
	//setVoxelSize(1.45, 1.45, 10, unit);
}

/////////////
function processFolder(input) {
	list = getFileList(input);
	brak_nazwy=1;
	for (i = 0; i < list.length; i++) {
		if(endsWith(list[i], suffix)) {
			if(brak_nazwy) {
				//print(list[i]);
				nazwa=substring(list[i], 0, indexOf(list[i], suffix)-number_ii);
				//print(nazwa);
				brak_nazwy=0;
			}
			processFile(input, list[i]);
		}
	}
	return nazwa;
}

function getSizes(input) {
	list = getFileList(input);
	print("Trying to find size of: "+list[1]);
	open(list[1], "virtual");
	vw=0
	vh=0
	vd=0
	unit=""
	getVoxelSize(vw, vh, vd, unit);
	v = newArray(vw, vh, vd)

	close(list[0]);
	print("getSizes "+ unit +" "+ v[0] +" "+ v[1] +" "+ v[2]);
	return v;
}

function processFile(input, file) {
	ileplikow++;
}