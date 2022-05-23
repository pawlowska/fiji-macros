/* 
 * v.4_1
 * LOADS ULTRAMICROSCOPE .ome.tif FILES INTO BIGSTITCHER
 * data will be resaved as HDF5 ready to open in Bigstitcher in new folder "stitched_(highest.number)"
 * creates results folder in the parent folder of data folder
 * tiles are auto-detected
 * requires from the user:
 * - output file name
 * - selecting input directory
 * - overlap value
 */

// output file name and input directory
prefix = getString("Define output file name:", "dataset");
pth = getDirectory("Select input directory");
print("Source path: "+pth);
ovlap = getNumber("Overlap value (%):", "20");
print("Overlap: "+ovlap);

// FUN to create array with subfolder names
function listsFolders(pth) {
	list_all = getFileList(pth);
	for (i=0; i<list_all.length; i++) {
		if (File.isDirectory(list_all[i])
		//if (endsWith(list_all[i], "/"))
			list_dir = Array.concat(list_dir, substring(list_all[i], 0, lengthOf(list_all[i])-1));
	}
	list_dir = Array.slice(list_dir,1);
	return list_dir;
}
// FUN to auto-detect tiles
function detectTiles(pth) {
	list_all = getFileList(pth);
	for (i=0; i<list_all.length; i++) {
		if (endsWith(list_all[i], ".ome.tif")) {
			tiles_row = Array.concat(tiles_row, substring(list_all[i], indexOf(list_all[i],"[")+1, indexOf(list_all[i],"[")+3));
			tiles_col = Array.concat(tiles_col, substring(list_all[i], indexOf(list_all[i],"]")-2, indexOf(list_all[i],"]")));
		}
	}
	tiles_row = Array.slice(tiles_row,1);
	tiles_col = Array.slice(tiles_col,1);
	Array.getStatistics(tiles_row, min, max_x, mean, std);
	Array.getStatistics(tiles_col, min, max_y, mean, std);
	tiles_max = newArray(max_x+1,max_y+1);
	return tiles_max;
}

// Create new subfolder for current stitching output
pth_output = File.getParent(pth)+File.separator+prefix+"_stitched_1";
print(pth_output);
if (File.exists(pth_output) != 1) {
	print("Creating: "+pth_output);
	File.makeDirectory(pth_output);
} else {
	list_dir = listsFolders(File.getParent(pth));
	for (i = 0; i<list_dir.length; i++) {
		dir_num = substring(list_dir[i], lastIndexOf(list_dir[i], "_")+1, lengthOf(list_dir[i]));
		dir_nums = Array.concat(dir_nums, dir_num);
	}
	dir_nums = Array.slice(dir_nums,1);
	Array.getStatistics(dir_nums, min, max, mean, std);
	new_num = max + 1;
	pth_output = pth+File.separator+prefix+"_stitched_"+new_num;
	print("Creating: "+pth_output);
	File.makeDirectory(pth_output);
}

// set BigStitcher settings and run
print("Output path: "+pth_output);
tiles_max = detectTiles(pth);
print("Note! ", tiles_max[1]," x ",tiles_max[0]," tiles matrix was detected.");
run("Define dataset ...",
	"define_dataset=[Automatic Loader (Bioformats based)] "+
	"project_filename="+prefix+".xml "+
	"path="+pth+" exclude=1000 bioformats_channels_are?=Channels "+
	"pattern_0=Tiles pattern_1=Tiles move_tiles_to_grid_(per_angle)?=[Move Tile to Grid (Macro-scriptable)] "+
	"grid_type=[Right & Down             ] tiles_x="+tiles_max[1]+" tiles_y="+tiles_max[0]+" tiles_z=1 overlap_x_(%)="+ovlap+" overlap_y_(%)="+ovlap+" overlap_z_(%)="+ovlap+" "+
	"keep_metadata_rotation how_to_load_images=[Re-save as multiresolution HDF5] "+
	"dataset_save_path="+pth_output+
	" timepoints_per_partition=1 setups_per_partition=0 use_deflate_compression "+
	"export_path="+pth_output+File.separator+prefix+"_dataset");
// Log file save
getInfo("Log");
saveAs("text", pth_output+File.separator+"log.txt");
print("LOADING IS DONE!");

/* NOTES
 * https://imagej.net/plugins/bigstitcher/ 
 * 
 *  dopasowanie lepiej robic na kanale 0 (cFOS)
 *  
 *  a co z zdefiniowanymi tiles? - obraz z mikroskopu może mieć inne wymiary - przetestować czy to ma znaczenie w tych ustawieniach, czy program sam wykryje; 
 *  ew. dodać rozpoznawanie (z ostastniego pliku koordynaty ostatniego tile [00x00]
 *  
 *  Array.print(dir_nums);
 *  
 *  run("BigStitcher", "select=define define_dataset=[Automatic Loader (Bioformats based)] project_filename=shila_29s.xml 
 *  path=W:/Ultramikroskop2021/Shila/210818_Shila_29s_13-07-51 exclude=10 bioformats_channels_are?=Channels pattern_0=Tiles 
 *  pattern_1=Tiles move_tiles_to_grid_(per_angle)?=[Do not move Tiles to Grid (use Metadata if available)] how_to_load_images=[Re-save as multiresolution HDF5] 
 *  dataset_save_path=W:/Ultramikroskop2021/Shila/210818_Shila_29s_13-07-51 subsampling_factors=[{ {1,1,1}, {2,2,2}, {4,4,4}, {8,8,8} }] 
 *  hdf5_chunk_sizes=[{ {16,16,16}, {16,16,16}, {16,16,16}, {16,16,16} }] timepoints_per_partition=1 setups_per_partition=0 
 *  use_deflate_compression export_path=W:/Ultramikroskop2021/Shila/210818_Shila_29s_13-07-51/dataset");
run("Script...");
 */
