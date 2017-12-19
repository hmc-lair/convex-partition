function [ x, y ] = calculateXY( origLat, origLng, lat, lng )
%calculateXY Calculate x&y in Cartesian coordinates
radius = 6371000;
x = (lng - origLng).*pi./180.*cos((lat + origLat)./2*pi./180)*radius;
y = (lat - origLat).*pi./180.*radius;

end

