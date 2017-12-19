function [ lat, lon ] = calculateLonLat( origLat, origLng, x, y )

radius = 6371000;
lat = y.*180./(pi.*radius) + origLat;
lon = x./pi.*180./cos((lat + origLat)./2*pi./180)/radius + origLng;

%radius = 6371000;
%x = (lng - origLng).*pi./180.*cos((lat + origLat)./2*pi./180)*radius;
%y = (lat - origLat).*pi./180.*radius;

end

