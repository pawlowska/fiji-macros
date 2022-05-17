pth = File.openDialog("Select input directory");
print("Source file: "+pth);


run("Calculate pairwise shifts ...", 
	"select="+ pth+
	" method=[Phase Correlation] "+
	"show_expert_grouping_options how_to_treat_timepoints=[treat individually] how_to_treat_channels=compare how_to_treat_illuminations=group how_to_treat_angles=[treat individually] how_to_treat_tiles=compare "+
	"downsample_in_x=4 downsample_in_y=4 downsample_in_z=1");

max_shift=50;

run("Filter pairwise shifts ...", 
	"select="+ pth+
//	" filter_by_link_quality min_r=0.50 max_r=1 "+
	" filter_by_shift_in_each_dimension   max_shift_in_x="+max_shift+
										" max_shift_in_y="+max_shift+
										" max_shift_in_z="+max_shift+" max_displacement=100");

	/*	
run("Optimize globally and apply shifts ...",
	"select="+pth+
	" relative=2.500 absolute=3.500 "+
	" global_optimization_strategy=[Two-Round using Metadata to align unconnected Tiles] "+
	" show_expert_grouping_options how_to_treat_channels=compare how_to_treat_illuminations=compare how_to_treat_angles=[treat individually] how_to_treat_tiles=compare "+
	" fix_group_0-0 fix_group_0-1 fix_group_0-2 fix_group_0-3 fix_group_0-4 fix_group_0-5");
	*/