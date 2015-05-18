function [mu,rho]=define_material_parameters(nx,nz,model_type)

%==========================================================================
% generate material parameters mu [N/m^2] and rho [kg/m^3]
%
% input:    grid points of the velocity and density field in x-direction (nx) and z-direction (nz)
%           model_type
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%==========================================================================

if (model_type==1)
    
    rho=3000.0*ones(nx,nz);
    mu=4.8e10*ones(nx,nz);
    
elseif (model_type==2)
    
    rho=3000.0*ones(nx,nz);
    mu=4.8e10*ones(nx,nz);
    
    rho(98:102,123:127)=rho(98:102,123:127)+2000.0;
    
elseif (model_type==3)
    
    rho=3000.0*ones(nx,nz);
    mu=2.8e10*ones(nx,nz);
    
    rho(1:round(nx/2),:)=rho(1:round(nx/2),:)+200.0;
    mu(1:round(nx/2),:)=mu(1:round(nx/2),:)+3.5e10;
    
elseif (model_type==4)
    
    rho=3000.0*ones(nx,nz);
    mu=2.8e10*ones(nx,nz);
    
    rho(1:round(nx/2),:)=rho(1:round(nx/2),:)+200.0;
    mu(1:round(nx/2),:)=mu(1:round(nx/2),:)+3.5e10;
    
    rho(98:102,123:127)=rho(98:102,123:127)+2000.0;
    
elseif (model_type==5)
    
    rho=3000.0*ones(nx,nz);
    mu=2.0e10*ones(nx,nz);
    
    for k=100:150
        mu(:,k)=mu(:,k)+(k-100)*10.0e8;
    end
    for k=151:nz
        mu(:,k)=mu(:,150);
    end
   
elseif (model_type==6)
    
    rho=3000.0*ones(nx,nz);
    mu=2.0e10*ones(nx,nz);
    
    for k=100:150
        mu(:,k)=mu(:,k)+(k-100)*10.0e8;
    end
    for k=151:nz
        mu(:,k)=mu(:,150);
    end
    
    rho(98:102,123:127)=rho(98:102,123:127)+2000.0;
    
elseif (model_type==7)
    
    rho=3000.0*ones(nx,nz);
    mu=ones(nx,nz);
    mu(1:330,:)=3.675e10;
    mu(331:end,:)=2.7e10;
    
elseif (strcmp(model_type,'picture') )
    
    A = imread('../models/rand.png');
    rho = 3000.0 * ones(nx,nz); 
    
    mu = 4.8e10 - ( (600 * sqrt(3e3) + sqrt(4.8e10))^2 - 4.8e10 ) * flipud( abs((double(A(:,:))-255)/max(max(abs(double(A)-255)))) )';
    
else
    
    load(['models/mu_' str(model_type)]);
    load(['models/rho_' str(model_type)]);
    
end


