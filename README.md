*************************************************************************************************
    	              	      PHOTOVOLTAIC EFFICIENCY CALCULATIONS
*************************************************************************************************

Basic numerical and analytical calculations of the theoretical maximum efficiency limits for 
photovoltaic devices

Copyright (c) 2017 Patrick Isherwood

-------------------------------------------------------------------------------------------------

*************************************************************************************************
				Shockley-Queisser limit calculations (SQ_limit.sce)
*************************************************************************************************

This Scilab script uses a user-defined solar spectrum to calculate the detailed balance or
Shockley-Queisser efficiency limit for photovoltaic devices.  Because the input spectrum can
be varied this script uses a variation of the numerical technique described by Shockley and
Queisser in their original paper [1].  An alternative thermodynamic analytical technique (not 
included here) can be used if the spectrum is limited to that of a blackbody.  The provided 
spectral data file is for the AM1.5G spectrum, and was calculated using SMARTS.  This is a free 
open-source program which was developed by C. A. Gueymard, and is available from the US National 
Renewable Energy Laboratory website [2].

To use this script, ensure that it is in the same folder as the spectrum data file you intend 
to use, and that the data in the spectrum are ordered with wavelength in the left hand column
and irradiance in the right hand column.  Spectral data should be ordered from the longest to 
the shortest wavelength.

The wavelength range you wish to examine should be shorter than the spectral wavelength range.
Wavelengths must be input as a range of integer values.

Whilst with some alteration this script should work in Matlab, it will not work in its current
form!  

-------------------------------------------------------------------------------------------------

*************************************************************************************************
				Fundamental losses in photovoltaics (FLIPV.sce)
*************************************************************************************************

This Scilab script uses the calculations described by Hirst and Ekins-Daukes [3] to produce a 
graph showing both the maximum theoretical efficiency of a photovoltaic device as well as the 
various mechanisms which lead to the energy losses.  This is an analytical technique and is in 
effect the thermodynamic equivalent of the Shockley-Queisser detailed balance limit.  It is 
limited to the use of a blackbody spectrum.

By changing the solid angles of emission of the cell and the sun, the effect of light 
concentration and/or restriced emission can be examined.  It is important to note that the solid
angle of the cell must always be greater than or equal to that of the sun.  The maximum 
concentration or angular restriction is ~42600 times, at which point the Boltzmann or Etendue
expansion loss disappears.  This is why cells have a higher efficiency when under concentrated
light.  

The output graph shows the maximum efficiency curve (dark blue); below gap transmitted photons
(red); above gap photon cooling losses (pale blue); Boltzmann or etendue expansion losses 
(green); Carnot losses (orange) and radiative recombination emission losses (yellow).

Whilst with some alteration this script may work in Matlab, it will not work in its current
form!   

-------------------------------------------------------------------------------------------------

References:

[1] Shockley, W., Queisser, H. J.  Detailed Balance Limit of Efficiency of p-n Junction Solar
Cells.  J Appl Phys 32, 510, 1961.  DOI:10.1063/1.1736034

[2] https://www.nrel.gov/rredc/smarts/

[3] Hirst, L. C., Ekins-Daukes, N. J.  Fundamental losses in solar cells.  Progress in 
Photovoltaics 19, 3, 286-293, 2011.  DOI: 10.1002/pip.1024

-------------------------------------------------------------------------------------------------
