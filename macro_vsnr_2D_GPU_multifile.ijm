//author: Sylwia Bednarek Neuroinformatics Lab

// this variable is the input folder
input = "/media/mstefaniuk/DANE-HDD1/mpawlowska/test/";

// this variable is the output folder
output = "/media/mstefaniuk/DANE-HDD1/mpawlowska/test_out/";
list = getFileList(input);
setBatchMode(true); 
for(i = 0;i<list.length;i++){
	denoiseImage(input,	output,	list[i]);
}

function denoiseImage(input, output, filename){
	print(input+filename);
	open(input+filename);
	run("VSNR GPU 2D", "where=[Text File (.txt)] choose=[/media/mstefaniuk/DANE-HDD1/mpawlowska/gpu_params.txt]");
	saveAs("Tiff", output+'denoised_'+filename);
	close();
	close();
}
