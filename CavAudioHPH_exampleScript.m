%CavAudioHPH_exampleScript.m

close all
clc

%% Settigns
fMin     = 30e3; %Integrate from 30 to 45 kHz
fMax     = 45e3;
Imin     = -1.35e4; %Default re-normalization-limits 
Imax     = -1.31e4;
doSaveStructure = 1; %Save a detailed structure (only needed if we want to plot spectra)

%% Analyze files
[Iv,It] = CavAudioHPH_FolderBatchAnalysis('exampleAudioFolder',fMin,fMax,Imin,Imax,doSaveStructure);
p1v = [0 600]; %p1 [bar] (from OperatingConditions.txt)

%% Plotting I* vs p_1
figure(1); 
plot(p1v/10,Iv,'ko','MarkerFaceColor','k'); 
xlabel('p_1 [MPa]')
ylabel('I^* [-]')
axis([0 65 -0.2 1.2])
grid on
set(gca,'FontSize',16)

%%Plotting spectra
load exampleAudioFolder_CavAudioHPH_details.mat
figure(2)
hold on
    plot(outStr{1}.spectrum.fv_ch1/1e3,outStr{1}.spectrum.pv_ch1,'k-','LineWidth',2)
    plot(outStr{2}.spectrum.fv_ch1/1e3,outStr{2}.spectrum.pv_ch1,'b-','LineWidth',2)
hold off
xlabel('Frequency, f [kHz]')
ylabel('Amplitude, A^* [-]')
grid on
set(gca,'FontSize',16)
legend('p_1 = 0 MPa','p_1 = 60 MPa')
