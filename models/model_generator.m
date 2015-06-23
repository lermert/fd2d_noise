

matrix = rand(600,600);
matrix = double(matrix>0.999);

sum_level = 2;
for i:1
matrix(2:end-1,2:end-1) = matrix(2:end-1,2:end-1) + matrix(1:end-2,1:end-2);


pcolor(test)
shading interp