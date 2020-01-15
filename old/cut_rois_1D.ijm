setBatchMode( true );

step=400;
x0=2420;
y=250;
w=110;
h=120;

suffix = ".ome.tif";
padding=4;

input = getDirectory("Input directory");
nazwa_output="rois/";
output = input+nazwa_output;
createFolder(output);

processFolder(input);

function createFolder(out_dir) {
	if (File.exists(out_dir)!=1) {
		print("Tworzę folder: " + out_dir);
		File.makeDirectory(out_dir);
	}
}

function processFolder(input) {
	list = getFileList(input);
	ileplikow = 0;
	print("Przetwarzam katalog "+input);

	for (i = 0; i < list.length; i++) {
		if(endsWith(list[i], suffix)) {
			x=x0-ileplikow*step;
			ileplikow++;
			processFile(input+list[i], output+"/", x);
		}
	}
	print("Koniec "+ input + " ! Przetworzono plikow "+ileplikow);
}

function processFile(input_file, output_dir, x) {
	print("Przetwarzam plik: " + input_file);
	open(input_file);

	run("Specify...", "width="+w+" height="+h+" x="+x+" y="+y+" slice=0 scaled");
	run("Crop");
	
   	//save
   	xS=toString(x);
   	while (lengthOf(xS)<padding) {xS="0"+xS;};
   	print(xS);
   	output_file=output_dir+xS+".tif";
	saveAs("Tiff", output_file);
   	close();

   	print("Zapisano: " + output_file);
   	print("");
}