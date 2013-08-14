//NSTORM reconstructor with drift correction by fiducial
//Author: Yoshiyuki Arai
//Data: 2013.08.05
macro NSTROMreconstructor {
	// read rapidSTORM text data
	NSTORMfile = File.openDialog("Select NSTORM text data");
	NSTORMtxt = File.openAsString(NSTORMfile);
	datatxt = split(NSTORMtxt,"\n"); //split each line in datatxt array
	hdr = split(datatxt[0]);

	// Dialog for getting parameters
	Dialog.create("Input parameters");
	Dialog.addNumber("width of image (um)",16.575);
	Dialog.addNumber("height of image (um)",16.575);
	Dialog.addNumber("superresolution image pixels size (nm)",10);
	Dialog.show();
	w=Dialog.getNumber();
	h=Dialog.getNumber();
	ps=Dialog.getNumber();

	newImage("NSTORM","16-bit black",round(w*1000/ps),round(h*1000/ps),1); // create image
	run("Set Scale...", "distance=1 known="+ps+" pixel=1 unit=nm"); // set scale
	cnt=0;
	for(i=1;i<(datatxt.length);i++) {
		line=split(datatxt[i],"\t"); // Tab
		x=parseFloat(line[0]);
		y=parseFloat(line[1]);
		sx=x/ps; // interpolate raw data in pixels
		sy=y/ps;

		val = getPixel(round(sx),round(sy)); // get pixel value
		setPixel(round(sx),round(sy),val+1); // add pixel value

	}
	run("Enhance Contrast", "saturated=0.35"); // auto enhance
}