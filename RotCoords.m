function [rdot,xidot,phidot,gammadot,vdot,zetadot] = RotCoords(r,xi,phi,gamma,v,zeta,L,D,m,alpha,chi)
% Determination of motion in rotating coordinates

%xi  Longitude (rad)
%phi  Latitude (rad)
%gamma  Flight Path Angle (rad)
%zeta  Heading Angle (rad)

mu_E = 3.986e14; % m^3/s^2 Earth Gravitational Parameter
omega_E = 7.292115e-5; % s^-1 Earth Rotation Rate
T = 0; % No thrust

rdot = v.*sin(gamma);

xidot = v.*cos(gamma).*cos(zeta)./(r.*cos(phi));

phidot = v.*cos(gamma).*sin(zeta)./r;

gammadot = L./(m.*v).*cos(chi) + T.*sin(alpha)./(m.*v).*cos(chi) + (v./r - mu_E./(r.^2.*v)).*cos(gamma) + cos(phi).*(2.*omega_E.*cos(zeta) + omega_E.^2.*r./v.*(cos(phi).*cos(gamma)+sin(phi).*sin(gamma).*sin(zeta)));

vdot = T.*cos(alpha)./(m) - mu_E.*sin(gamma)./r.^2 -D./m + omega_E.^2.*r.*cos(phi).*(cos(phi).*cos(gamma)+sin(phi).*sin(gamma).*sin(zeta));

zetadot = L./(m.*v).*sin(chi) + T.*sin(alpha)./(m.*v).*sin(chi) + -v./r.*tan(phi).*cos(gamma).*cos(zeta) + 2.*omega_E.*cos(phi).*tan(gamma).*sin(zeta) - omega_E.^2.*r./(v.*cos(gamma)).*sin(phi).*cos(phi).*cos(zeta)-2.*omega_E.*sin(phi);

end

