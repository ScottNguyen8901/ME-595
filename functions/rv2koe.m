function [koe] = rv2koe(r0,v0,mu)
    %
    % DESCRIPTION
    %   Convert state vector into keplarian orbital elements
    %
    % INPUTS    
    %   r0      (3,1)   Initial position vector [DU]   
    %   v0      (3,1)   Initial velocity vector [DU^3/TU^2]
    %   mu      (1,1)   Gravitational parameter [DU^3/TU^2]
    %
    % OUTPUTS
    %   koe     {struct}   Keplarian orbital elements structure
    %    .a     (1,1)      Semi-major axis   [DU]
    %    .e     (1,1)      Eccentricity      []
    %    .i     (1,1)      Inclination       [rad]
    %    .W     (1,1)      RAAN              [rad]
    %    .w     (1,1)      Arg of periapsis  [rad]
    %    .f     (1,1)      True anomaly      [rad]
    %    .fpa   (1,1)      Flight path angle [rad]
    % NOTES
    %
    %
    % FUNCTION 
    
    %i,j,k vectors
    I = [1 0 0];
    J = [0 1 0];
    K = [0 0 1];
    
    %Norm of r0 and v0
    r = norm(r0);
    v = norm(v0);
    
    %Calculating semi-major axis using vis-viva eqn
    a = 1/((2/r) - ((v^2)/mu));
    
    %Calculating eccentricity vector then eccentricity
    e_vec = (((v^2)/mu) - (1/r))*r0 - (1/mu)*dot(r0,v0)*v0;
    e = norm(e_vec);
    
    %Solving for inclination
    h_vec = cross(r0,v0);
    i = acos(dot((h_vec/norm(h_vec)),K));
    
    %Solving for RAN
    n = cross(K,h_vec);
    if dot(n,J) < 0
        W = acos(dot((n/norm(n)),I));
        W = 2*pi - W;
    else
        W = acos(dot((n/norm(n)),I));
    end
    
    %Solving for argument of periapsis
    if dot(e_vec,K) < 0
        w = acos(dot((n/norm(n)),(e_vec/norm(e_vec))));
        w = 2*pi - w;
    else
        w = acos(dot((n/norm(n)),(e_vec/norm(e_vec))));
    end
    
    %Solving for true anomaly
    if dot(r0,v0) < 0
        f = acos(dot((r0/norm(r0)),(e_vec/norm(e_vec))));
        f = 2*pi - f;
    else
        f = acos(dot((r0/norm(r0)),(e_vec/norm(e_vec))));
    end
    
    fpa = acos(norm(h_vec)/ (norm(r0) * norm(v0)));

    % Populating KOE output sturcture
    
    koe.a   = a;
    koe.e   = e;
    koe.i   = i;
    koe.W   = W;
    koe.w   = w;
    koe.f   = f; 
    koe.fpa = fpa;
end