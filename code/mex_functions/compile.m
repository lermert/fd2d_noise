
path(path,genpath('../../'))

% G_2
i1 = coder.typeof(complex(zeros(2,2,2)),[inf,inf,inf],1);

% noise_source_distribution, adstf
i2 = coder.typeof(zeros(2,2),[inf,inf],1);

% src, rec
i3 = coder.typeof(zeros(2,2),[inf,2],1);

% run_forward_source_inversion(G_2,noise_source_distribution,rec)
codegen run_forward_source_fast.m -args {i1,i2,i3}

% run_noise_source_kernel(G_2,stf,adsrc)
codegen run_noise_source_kernel_fast.m -args {i1,i2,i3}

clear i1
clear i2
clear i3