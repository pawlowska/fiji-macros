pth=getDirectory("Input directory");
print(pth);

list = getFileList(pth);
i=0;
while(indexOf(list[i], 'Pos00')==-1) 
	{i=i+1;};
plik=list[i];
open(plik, "virtual");
vw=0;
vh=0;
vd=0;
unit="";
getVoxelSize(vw, vh, vd, unit);
print("getSizes "+ unit +" "+ vw +" "+ vh +" "+ vd);
close(plik);

nazwa=replace(plik, 'Pos00', 'Pos{xx}');

count=0;
for(j=0; j<lengthOf(list); j++) {
	if(matches(list[j], ".*Pos.*")) {
		count++;
	};
}

new_dataset_manual_settings="select=define define_dataset=[Manual Loader (TIFF only, ImageJ Opener)] project_filename=dataset.xml "+
	"multiple_timepoints=[NO (one time-point)] multiple_channels=[NO (one channel)] _____multiple_illumination_directions=[NO (one illumination direction)] multiple_angles=[NO (one angle)] multiple_tiles=[YES (one file per tile)] "+
	" image_file_directory="+pth+
	" image_file_pattern="+nazwa+
	" tiles_=0-"+count-1+
	" pixel_distance_x="+vw+" pixel_distance_y="+vh+" pixel_distance_z="+vd+" pixel_unit=um";

run("BigStitcher", new_dataset_manual_settings);


resave_settings="select="+pth+"dataset.xml"+
	" subsampling_factors=[{ {1,1,1}, {2,2,1}, {4,4,2}, {8,8,4} }] hdf5_chunk_sizes=[{ {16,16,16}, {16,16,16}, {16,16,16}, {16,16,16} }] timepoints_per_partition=1 setups_per_partition=0 use_deflate_compression"+
	" export_path="+pth+"dataset.xml";

run("As HDF5 ...", resave_settings);

run("BigStitcher", "select="+pth+"dataset.xml");

print("KONIEC!");
print("Uwaga: są otwarte dwa okna Stitching Explorer. Zamknij pierwsze z nich");