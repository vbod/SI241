function [  ] = inpainting(img, Omega)

img = im2double(img);
Omega = ones(size(Omega)) - Omega;

getd = @(p)path(p,path); 
getd('toolbox_signal/');
getd('toolbox_general/');


n = size(img,1);

Phi = @(f,Omega)f.*(1-Omega);
y = Phi(img, Omega);
figure('name','image masquée');
imshow(y);


SoftThresh = @(x,T)x.*max( 0, 1-T./max(abs(x),1e-10) );

% paramaters of the wavelet transform.
Jmax = log2(n)-1;
Jmin = Jmax-3;

options.ti = 0; % 0 pour orthogonal 1 pour invariant par translation
Psi = @(a)perform_wavelet_transf(a, Jmin, -1,options);
PsiS = @(f)perform_wavelet_transf(f, Jmin, +1,options);

SoftThreshPsi = @(f,T)Psi(SoftThresh(PsiS(f),T));
ProjC = @(f,Omega)Omega.*f + (1-Omega).*y;

nb_ite = 1000;
E = zeros(1, nb_ite);
lambda = .07; % utiliser dans le cas à pas fixe
% lambda_list = linspace(1,0,nb_ite);

fSpars = y;

for i = 1:nb_ite
   fSpars = ProjC(fSpars,Omega);
   fSpars = SoftThreshPsi(fSpars, lambda);
   no = PsiS(fSpars);
   E(i) = .5*norm(y-Phi(fSpars,Omega),'fro')^2 + lambda*norm(no(:),1);
end

figure('name','Energy_orthogonal');
plot(E);

figure('name','Inpainting_orthogonal');
imageplot(clamp(fSpars));

J = Jmax-Jmin+1;
u = [4^(-J) 4.^(-floor(J+2/3:-1/3:1)) ];
U = repmat( reshape(u,[1 1 length(u)]), [n n 1] );

% lambda = .01;

options.ti = 1; % use translation invariance
Xi = @(a)perform_wavelet_transf(a, Jmin, -1,options);
PsiS = @(f)perform_wavelet_transf(f, Jmin, +1,options);
Psi = @(a)Xi(a./U);

tau = 1.9*min(u);

a = U.*PsiS(fSpars);

EE = zeros(1,nb_ite);
for l = 1:nb_ite
    fTI = Psi(a);
    a = a + tau*PsiS( Phi( y-Phi(fTI,Omega),Omega ) );
    a = SoftThresh( a, lambda*tau );
    EE(l) = 0.5*norm(y - Phi(Psi(a),Omega), 'fro') + lambda*norm(a(:),1);
end

figure('name','Energy_translation invariant');
plot(EE);

fTI = Psi(a);
figure('name','Energy_translation invariant');
imageplot(clamp(fTI));


% Inpainting using Iterative Hard Thresholding
HardThresh = @(x,t)x.*(abs(x)>t);

niter = 500;
lambda_list = linspace(1,0,niter);

fHard = y;
tau = 2;

for i = 1:niter
    fHard = ProjC(fHard,Omega);
    fHard = Xi( HardThresh( PsiS(fHard), tau*lambda_list(i) ) );
end

figure('name', 'Inpainting');
imageplot(clamp(fHard));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Inpainting variationel !!!! A faire ! 

end

