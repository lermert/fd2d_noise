
path(path,genpath('../../'))

% G_2, C_2, C_2_dxv, C_2_dzv
i1 = coder.typeof(complex(zeros(2,2,2)),[inf,inf,inf],1);

% source_dist, mu, adstf
i2 = coder.typeof(zeros(2,2),[inf,inf],1);

% src, rec
i3 = coder.typeof(zeros(2,2),[inf,2],1);


% run_forward_green_fast(mu,src)
codegen run_forward_green_fast.m -args {i2,i3}

% run_forward_correlation_fast(G_2, source_dist, mu, rec)
codegen run_forward_correlation_fast.m -args {i1,i2,i2,i3}

% run_noise_source_kernel_fast(G_2,mu,stf,adsrc)
codegen run_noise_source_kernel_fast.m -args {i1,i2,i2,i3}

% run_noise_structure_kernel_fast(C_2, C_2_dxv, C_2_dzv, mu, stf, adsrc)
codegen run_noise_structure_kernel_fast.m -args {i1,i1,i1,i2,i2,i3}

clear i1
clear i2
clear i3