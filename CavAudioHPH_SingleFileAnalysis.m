function [Ic_ch1,outStr] = CavAudioHPH_SingleFileAnalysis(fileName,cutTime,doDisp,fMin,fMax)
% function [I] = CavAudioHPH_SingleFileAnalysis(fileName)
% Calculates the corrected audio integral (I^*_{audio}) from a wav-file
% specified by 'filename'. 
% 
% Additional input options: 
% CavAudioHPH_SingleFileAnalysis(fileName,cutTime,doDisp,fMin,fMax)
% cutTime: Only uses the first 'cutTime' seconds of the signal. (Default: use whole file) 
% doDisp: If set to 1, displays spectra (Default: 0, not showing spectra)
% fMin: Minimum frequency to use in calculating the audio integral 
% fMax: Maximum frequency to use in calculating the audio integral
%
% Additional output options: 
% [I,outStr] = CavAudioHPH_SingleFileAnalysis(fileName)
% outStr: A structure contaning spectra (from both channels), input info ,
% etc. 
%
% Andreas Haakansson, 2025 (andreas.hakansson@ple.lth.se)

%[I,outStr] = readHPHcavAudio('2024-12-10/ZOOM0001.WAV',0,0,1,30e3,45e3)

%% Default settings
if nargin < 4
    fMin     = 30e3; %Integrate from 30 to 45 kHz
    fMax     = 45e3;
end
if nargin < 3
    doDisp = 0; %Do not display spectra
end
if nargin < 2
    cutTime = 0; %Use the entire audio file duration
end

%% Read audio file:
[audioIn,fs]       = audioread(fileName);

%% Cut to only keep 'cutTime' seconds of the signal (optional)
if cutTime > 0
    num_samp = round(fs); % Number of samples in a sec    
    audioIn = audioIn(1:num_samp*cutTime,:);     
end

%% Calculate the spectrum of the entire file
[pv_ch1,fv_ch1] = pspectrum(audioIn(:,1),fs);
    
%% Calculate Corrected spectra and audio integrals
y_ch1 = -pow2db(pv_ch1)/pow2db(pv_ch1(end)); %I^*_{audio} 
x_ch1  = fv_ch1;
idOK = find((x_ch1>fMin).*(x_ch1<fMax));
Ic_ch1 = trapz(x_ch1(idOK),y_ch1(idOK));

% If there is a second channel, perform calculations for that also
if size(audioIn,2)>1
    [pv_ch2,fv_ch2] = pspectrum(audioIn(:,2),fs);
    y_ch2 = -pow2db(pv_ch2)/pow2db(pv_ch2(end));
    x_ch2  = fv_ch2;
    idOK = find((x_ch2>fMin).*(x_ch2<fMax));
    Ic_ch2 = trapz(x_ch2(idOK),y_ch2(idOK));  
else
    y_ch2  = NaN;
    x_ch2  = NaN;
    Ic_ch2 = NaN;
end


%% Plot spectra (optional).
if doDisp == 1
    figure(1)
    hold on
        plot(fv_ch1/1e3,pow2db(pv_ch1),'r-')
        plot(fv_ch2/1e3,pow2db(pv_ch2),'b-')

    hold off    
    xlabel('f [kHz]')
    ylabel('Amplitude, A [dB]')
    legend('ch1','ch2')
    grid on
    set(gca,'FontSize',16)

    figure(2)
    hold on
        plot(x_ch1/1e3,y_ch1,'r-')        
        plot(x_ch2/1e3,y_ch2,'b-')        
    hold off    
    xlabel('f [kHz]')
    ylabel('Scaled amplitude, A^* [dB]')
    legend('ch1','ch2')
    grid on    
    set(gca,'FontSize',16)
end

%% Saving more extensive output data in a structure
%Audio spectrum of whole signal
outStr.spectrum.pv_ch1 = y_ch1;  
outStr.spectrum.fv_ch1 = x_ch1;
outStr.spectrum.pv_ch2 = y_ch2;
outStr.spectrum.fv_ch2 = x_ch2;
outStr.Ic_ch1 = Ic_ch1;
outStr.Ic_ch2 = Ic_ch2;

%Saving input settings (for tracebility)
outStr.input.fileName   = fileName;
outStr.input.fMin       = fMin;
outStr.input.fMax       = fMax;
outStr.input.cutTime    = cutTime;
outStr.input.doDisp     = doDisp;
outStr.input.analysed   = datetime;


