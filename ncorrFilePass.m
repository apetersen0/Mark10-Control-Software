function ncorrFilePass(images)

handles_ncorr = ncorr;
handles_ncorr.set_ref(images{1});
handles_ncorr.set_cur(images(2:end));