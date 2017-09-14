clear;
cd(get_absolute_file_path('SQ_limit.sce'))
//
//         USER INPUT
//
Wave=300:10:4000;  //Wavelength range corresponding to band gap range of interest.  Must be integer values
AM=fscanfMat('AM1_5.txt');  //File containing spectrum of interest.  Change as required.  File must be in the same folder as the .sce file
//
//         CONSTANTS
//
TsS=5800;  //Temperature of the sun
q=1.602176565e-19;  //Electronic charge
k=1.3806488e-23;  //Boltzmann's constant
h=6.626068e-34;  //Planck's constant
c=2.99792458e8;  //Speed of light, cm/s
//
//       FIXED VARIABLES
//
Tc=300;  //Cell temperature
Vc=(k.*Tc)./q;
xc=Tc./TsS;
//
//      SOLAR SPECTRUM
//
AMwav=AM(:,1:1);  //Spectral wavelengths
AMwav_int=flipdim(AMwav,1);
AMspec=(AM(1:$,2)); //Power per nanometre per square metre
AMspec_int=flipdim(AMspec,1);
eV=(((h.*c)./q).*1e9)./AMwav; //Convert wavelength to eV
//
//          FUNCTIONS
//
deff('[RR0]=recombination(x)',['RR0=(x.^2)./((exp(x))-1)'],['c'])  //Radiative recombination function
deff('[J]=current(V)',['J=q.*(Qs-Qc.*(exp(V./Vc)-1))'],['c'])  //Current-voltage relation
deff('[V]=maxV(Vmax)',['V=(exp(Voc./Vc)-((Vmax+Vc)./Vc).*exp(Vmax./Vc))'],['c']) //Transcendental equation for finding the voltage at MPP
//
//          MAIN CALCULATION
//
Eg=(((h.*c)./q)./(Wave.*1e-9))';  //Wavelength range in eV
epf=AMspec./(q.*eV);  //Photon flux per unit wavelength - use with data from file
AM1=inttrap(AMwav_int,AMspec_int);
for Wav=Wave;  //Wavelength equivalent to cell band gap, in nm
i=find(Wav==Wave);
Vg=((h.*c)./q)./(Wav.*1e-9);  //Band gap energy for given wavelength
xg=(q.*Vg)./(k.*TsS);
xgc=xg./(Tc./TsS);
Qs(i)=inttrap(epf(find(Wav==AMwav):$,1:1));  //Integrated photon flux
Qc(i)=((2 .*%pi.*((k.*Tc).^3))/((h.^3).*(c.^2))).*intg(xgc,1000, recombination);  //Cell recombination rate
Voc=Vc.*log((Qs(i)./(Qc(i)))+1);  //Open circuit voltage
Vmax(i)=fsolve(Voc,maxV);  //Voltage at MPP
end;
Jmax=current(Vmax);  //Current at MPP
//
//Fill factor and SQ efficiency limits
//
en=((Vmax.*Jmax)./AM1).*100;  //Shockley-Quiesser efficiency limit using input spectrum
//
//SQ limit graph
//
scf();
title('Shockley-Queisser Limit','fontsize',5)
xlabel('Bandgap (eV)','fontsize',3)
ylabel('Maximum efficiency (%)','fontsize',3)
plot(Eg,en) 
scf();
title('Input Spectrum','fontsize',5)
xlabel('Wavelength (nm)','fontsize',3)
ylabel('Irradiance (W/m2/nm)','fontsize',3)
plot(AMwav,AMspec) 
