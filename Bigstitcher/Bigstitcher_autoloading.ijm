pth=getDirectory("Input directory");
print(pth);

tif_string="pattern_0=Tiles move_tiles_to_grid_(per_angle)?=[Move Tiles to Grid (interactive)]";
ometif_string="bioformats_series_are?=Tiles bioformats_channels_are?=Channels move_tiles_to_grid_(per_angle)?=[Do not move Tiles to Grid (use Metadata if available)]"


list = getFileList(pth);
i=0;
while(!(endsWith(list[i], 'tif'))) 
	{i=i+1;};

if(endsWith(list[i], 'ome.tif')) {
	print("ome tiff");
	filetype_string=ometif_string;
} else if(endsWith(list[i], '0.tif')) {
	print("tif");
	filetype_string=tif_string;
} else {
	print(list[i]);
}


new_dataset_automatic_settings="select=define define_dataset=[Automatic Loader (Bioformats based)] project_filename=dataset.xml "+
	"path="+pth+
	" exclude=10 "+filetype_string+" how_to_load_images=[Re-save as multiresolution HDF5] "+
	"dataset_save_path="+pth+
	" check_stack_sizes timepoints_per_partition=1 setups_per_partition=0 use_deflate_compression "+
	"export_path="+pth+"dataset";


run("BigStitcher", new_dataset_automatic_settings);


