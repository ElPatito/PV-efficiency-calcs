clear;
//
//         CONSTANTS
//
Ts=5800;  //Temperature of the sun
q=1.602176565e-19;  //Electronic charge
k=1.3806488e-23;  //Boltzmann's constant
h=6.626068e-34;  //Planck's constant
c=2.99792458e8;  //Speed of light, cm/s
D=149.6e6;  //Distance between the sun and the earth (km)
DiaS=1.3914e6;  //Solar diameter (km)
//
//       FIXED VARIABLES
//
Ta=300;  //Cell temperature
Vc=(k.*Ta)./q;
xc=Ta./Ts;
Oabs=2 .*%pi.*(1-cos((DiaS./D)./2));  //Solar solid angle of emission seen by the cell
Oemit=%pi;  //Solid angle of emission of the cell.  For limits under max. concentration, change to equal Oabs

Wav=(350:1:4000)';  //Wavelength range of interest

deff('[X]=xi(E,T)',['E=E.*q; X=((2 .*k.*T)./((c.^2).*(h.^3))).*((E.^3)+3 .*(E.^2).*k.*T+6 .*E.*(k.^2).*(T.^2)+6 .*(k.^3).*(T.^3));'],['c'])
deff('[y]=giota(E,T)',['E=E.*q; y=((2 .*k.*T)./((c.^2).*(h.^3))).*((E.^2)+2 .*k.*T.*E+2 .*(k.^2).*(T.^2));'],['c'])

Pin=Oabs.*xi(0,Ts);
Eg=((h.*c)./q)./(Wav.*1e-9);
Vopt=((Eg.*q).*(1-(Ta./Ts))-Ta.*k.*log(Oemit./Oabs))./q;
Voc=((Eg.*q).*(1-(Ta./Ts))-k.*Ta.*log(Oemit./Oabs)+k.*Ta.*log((giota(Eg,Ts))./(giota(Eg,Ta))))./q;
Jopt=(Oabs.*(giota(Eg,Ts).*exp((-(Eg.*q))./(k.*Ts))-giota(Eg,Ta).*exp((-(Eg.*q))./(k.*Ts)))).*q;
Below_gap=((Oabs.*(xi(0,Ts)-exp(-((Eg.*q)./(k.*Ts))).*xi(Eg,Ts)))./Pin).*100;
Thermalisation=((Oabs.*exp(-((Eg.*q)./(k.*Ts))).*(xi(Eg,Ts)-(Eg.*q).*giota(Eg,Ts)))./Pin).*100;
Emission=((Oabs.*(Eg.*q).*giota(Eg,Ta).*exp((-Eg.*q)./(k.*Ts)))./Pin).*100;
Boltzmann=((((k.*Ta)./q).*log(Oemit./Oabs).*Jopt)./Pin).*100;
Carnot=((Eg.*(Ta./Ts).*Jopt)./Pin).*100;

Power_out=((Jopt.*Vopt)./Pin).*100;  //Efficiency limit
Below_gap=Below_gap+Power_out;  //Below gap photon losses
Thermalisation=Thermalisation+Below_gap;  //Thermalisation or photon cooling losses
Boltzmann=Boltzmann+Thermalisation;  //Etendue mismatch losses
Carnot=Carnot+Boltzmann;  //Carnot losses
Emission=Emission+Carnot;  //Radiative recombination losses

Ag=Eg(1,1); Bg=Eg($,$); Eg=[Ag;Eg;Bg]; A0=0; Power_out=[A0;Power_out;A0]; Below_gap=[A0;Below_gap;A0]; Thermalisation=[A0;Thermalisation;A0]; Boltzmann=[A0;Boltzmann;A0]; Carnot=[A0;Carnot;A0]; Emission=[A0;Emission;A0]; 
scf();
plot(Eg,Power_out,Eg,Below_gap,Eg,Thermalisation,Eg,Boltzmann,Eg,Carnot,Eg,Emission)
a=get("current_axes"); a.tight_limits="on";
xfpoly(Eg,Emission,color("yellow"));xfpoly(Eg,Carnot,color("orange"));xfpoly(Eg,Boltzmann,color("forestgreen"));xfpoly(Eg,Thermalisation,color("dodgerblue"));xfpoly(Eg,Below_gap,color("red3"));xfpoly(Eg,Power_out,color("navy blue"));
title('Efficiency Limit and Associated Losses in PV Devices','fontsize',4)
xlabel('Bandgap (eV)','fontsize',3)
ylabel('Proportion of solar irradiance (%)','fontsize',3)
