function [ output_args ] = inpainting(img, method, Omega)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

getd = @(p)path(p,path); 
getd('toolbox_signal/');
getd('toolbox_general/');

n = size(img,1); % présuppose que les images sont carrées ! 

% mettre true pour plotter les énergies, variable de debug
plot = true;

% paramaters of the wavelet transform.
Jmax = log2(n)-1;
Jmin = Jmax-3;

% operateur de seuillage
SoftThresh = @(x,T)x.*max( 0, 1-T./max(abs(x),1e-10) );

if strcmp(method, 'orthogonal_wavelet')
    options.ti = 0; % orthogonal.
    Psi = @(a)perform_wavelet_transf(a, Jmin, -1,options);
    PsiS = @(f)perform_wavelet_transf(f, Jmin, +1,options);
    SoftThreshPsi = @(f,T)Psi(SoftThresh(PsiS(f),T));
    
    nb_ite = 1000;
    E = zeros(1,nb_ite);
    lambda = .03;
    ProjC = @(f,Omega)Omega.*f + (1-Omega).*y;
    fSpars = img; % img est l'observation avec masque

    for l = 1:nb_ite
        fSpars = ProjC(fSpars, Omega);
        fSpars = SoftThreshPsi(fSpars, lambda);
        no = PsiS(fSpars);
        E(l) = 0.5*norm(y - Phi(fSpars, Omega),'fro')^2 + lambda*norm(no(:),1);
        lambda = lambda / 2;
    end
    
    if plot
        figure();
        plot(E);
    end
end

if strcmp(method, 'invariant_wavelet')
    J = Jmax-Jmin+1;
    u = [4^(-J) 4.^(-floor(J+2/3:-1/3:1)) ];
    U = repmat( reshape(u,[1 1 length(u)]), [n n 1] );

    lambda = .01;

    options.ti = 1; % translation invariance
    Xi = @(a) perform_wavelet_transf(a, Jmin, -1,options);
    PsiS = @(f) perform_wavelet_transf(f, Jmin, +1,options);
    Psi = @(a) Xi(a./U);

    tau = 1.9*min(u);

    a = U.*PsiS(fSpars);

    E = zeros(1,nb_ite);
    for l = 1:nb_ite
        fTI = Psi(a);
        a = a + tau*PsiS( Phi( y-Phi(fTI,Omega),Omega ) );
        a = SoftThresh( a, lambda*tau );
        E(l) = 0.5*norm(y - Phi(Psi(a),Omega), 'fro') + lambda*norm(a(:),1);
        % lambda = lambda / 2;
    end

    figure();
    plot(E);

    
    fTI = Psi(a);
end
end

