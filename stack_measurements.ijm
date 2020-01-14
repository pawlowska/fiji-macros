//setBatchMode( true );

signal=getDirectory("Stitched stack directory");
print(signal);
name_dir=File.getParent(File.getParent(signal));

mask_path=File.openDialog("Mask");
open(mask_path);
m_id=getImageID();
print("mask: "+m_id);
nMask=nSlices;


list=getFileList(signal);
run("Image Sequence...", "open=["+signal+list[0]+"] sort use");
setMinAndMax(0, 1000);
s_id=getImageID();
print("signal: "+s_id);


run("Clear Results");
for (i = 1; i < nMask; i++) {
	selectImage(m_id);
	setSlice(i);
	setThreshold(1, 255);
	run("Create Selection");
	selectImage(s_id);
	setSlice(25*(i-1)+1);
	run("Restore Selection");
	run("Measure");
}


saveAs("Results", name_dir+".txt");

print("DONE");
