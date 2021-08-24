/* LOADS ULTRAMICROSCOPE .ome.tif FILES INTO BIGSTITCHER
 *  data will be resaved as HDF5 ready to open in Bigstitcher and stitch
 *  overlap 20%, 
 *  
 *  requires from the user: 
 *  - output file name
 *  - selecting input directory
 */

// output file name and input directory
prefix=getString("Define output file name:","dataset");
pth=getDirectory("Select input directory");
print(pth);

pth_output=pth+"stitched";
if (File.exists(pth_output)!=1) {
	print("Creating: " + pth_output);
	File.makeDirectory(pth_output);
/*
} else {
	
	print("Creating: " + pth_output + "_1");
	File.makeDirectory(pth_output);	
}
*/

// set Bigstitcher settings and run
UM_settings="define_dataset=[Automatic Loader (Bioformats based)] "+
	"project_filename="+prefix+".xml "+
	"path="+pth+" exclude=10 bioformats_channels_are?=Channels "+
	"pattern_0=Tiles pattern_1=Tiles move_tiles_to_grid_(per_angle)?=[Move Tile to Grid (Macro-scriptable)] "+
	"grid_type=[Right & Down             ] tiles_x=2 tiles_y=2 tiles_z=1 overlap_x_(%)=20 overlap_y_(%)=20 overlap_z_(%)=20 "+
	"keep_metadata_rotation how_to_load_images=[Re-save as multiresolution HDF5] "+
	"dataset_save_path="+pth_output+" "+
	"timepoints_per_partition=1 setups_per_partition=0 use_deflate_compression "+
	"export_path="+pth_output+prefix+"_dataset";

run("Define dataset ...", UM_settings);
print("DONE!");

// Log file save
getInfo("Log");
saveAs("text", pth_output+"log.txt");

/* NOTES
 *  dopasowanie lepiej robic na kanale 0 (cFOS)
 *  
 *  
 *  run("BigStitcher", "select=define define_dataset=[Automatic Loader (Bioformats based)] project_filename=shila_29s.xml 
 *  path=W:/Ultramikroskop2021/Shila/210818_Shila_29s_13-07-51 exclude=10 bioformats_channels_are?=Channels pattern_0=Tiles 
 *  pattern_1=Tiles move_tiles_to_grid_(per_angle)?=[Do not move Tiles to Grid (use Metadata if available)] how_to_load_images=[Re-save as multiresolution HDF5] 
 *  dataset_save_path=W:/Ultramikroskop2021/Shila/210818_Shila_29s_13-07-51 subsampling_factors=[{ {1,1,1}, {2,2,2}, {4,4,4}, {8,8,8} }] 
 *  hdf5_chunk_sizes=[{ {16,16,16}, {16,16,16}, {16,16,16}, {16,16,16} }] timepoints_per_partition=1 setups_per_partition=0 
 *  use_deflate_compression export_path=W:/Ultramikroskop2021/Shila/210818_Shila_29s_13-07-51/dataset");
run("Script...");
 */