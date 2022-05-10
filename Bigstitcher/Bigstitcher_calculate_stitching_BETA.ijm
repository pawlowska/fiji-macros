pth = File.openDialog("Select input directory");
print("Source file: "+pth);


run("Calculate pairwise shifts ...", 
	"select="+ pth+
	" method=[Phase Correlation] "+
	"show_expert_grouping_options how_to_treat_timepoints=[treat individually] how_to_treat_channels=compare how_to_treat_illuminations=group how_to_treat_angles=[treat individually] how_to_treat_tiles=compare "+
	"downsample_in_x=4 downsample_in_y=4 downsample_in_z=1");

//run("Filter pairwise shifts ...", 
//	"select="+ pth+
//	" filter_by_link_quality min_r=0.50 max_r=1 "+
//	"filter_by_shift_in_each_dimension max_shift_in_x=50 max_shift_in_y=50 max_shift_in_z=50 max_displacement=100");