//quick stitching using Plugins-> Stitching -> Grid/Collection...
//USE WITH TIF FILES
//USE OMETOTIFF_WITH_STITCHING FOR .ome.tif

/* TODO
sprawdzić różny blending
Result of getSizes: µm 1.4501 1.4501 8
*/

input = getDirectory("Input directory");

overlap=20;

suffix = ".tif";
suff_ii="{ii}";
number_ii=lengthOf(suff_ii)-2;

list=getFileList(input);
list = Array.delete(list, 'DisplaySettings.json'); 
print("Znaleziono plikow: "+list.length)

nazwa = processFolderFindFilename(list);

v = newArray(0,0,0);
v = getSizes(list);
unit="µm";

Dialog.create("Number of tiles");
Dialog.addString("x= ", "1", 2);
Dialog.addString("y= ", "2", 2);
Dialog.show();
x = Dialog.getString();
y = Dialog.getString();
xInt=parseInt(x);
yInt=parseInt(y);
ile=xInt*yInt;

if(ile>list.length)
	print("Za malo plikow!");
else {
	nazwaPliku=nazwa+suff_ii;
	print("Nazwa pliku bedzie taka: "+nazwaPliku);

	//type = "type=[Grid: column-by-column] order=[Down & Left]"; //Standa
	type = "type=[Grid: column-by-column] order=[Down & Right                ]"; //kamera Hamamatsu
	grid_size = " grid_size_x="+x+" grid_size_y="+y;
	file_names = " file_names="+nazwaPliku+suffix;
	dir=" directory="+input;
	//rest=" output_textfile_name=TileConfig.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap display_fusion computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]";
	
	rest_virtual=" output_textfile_name=TileConfig.txt fusion_method=[Max. Intensity] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap display_fusion use_virtual_input_images";	
	params = type+grid_size+" tile_overlap="+overlap+" first_file_index_i=0"+dir+file_names+rest_virtual;
	run("Grid/Collection stitching", params);
	setVoxelSize(v[0], v[1], v[2], unit);
}

/////////////
function processFolderFindFilename(list) {
	brak_nazwy=1;
	i=0;
	while(brak_nazwy) {
		if(endsWith(list[i], suffix)) {
			nazwa=substring(list[i], 0, indexOf(list[i], suffix)-number_ii);
			brak_nazwy=0;
		}
		i++;
	}
	return nazwa;
}

function getSizes(list) {
	//print("Trying to find size of: "+list[1]);
	open(list[1], "virtual");
	vw=0;
	vh=0;
	vd=0;
	unit="";
	getVoxelSize(vw, vh, vd, unit);
	v = newArray(vw, vh, vd);

	close(list[1]);
	print("Result of getSizes: "+ unit +" "+ v[0] +" "+ v[1] +" "+ v[2]);
	return v;
}