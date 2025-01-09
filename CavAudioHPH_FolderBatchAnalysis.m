function [I_vector,I_table] = CavAudioHPH_FolderBatchAnalysis(folderName,fMin,fMax,Imin,Imax,doSaveStructure)
% [I_vector] = CavAudioHPH_FolderBatchAnalysis(folderName)
% Reads all audio (wav)-files in a folder 'folderName', and subjects them
% to the function 'CavAudioHPH_SingleFileAnalysis', to calculate the corrected auido integrals (I*). Outputs a vector of corrected audio integral values, one for each file in the folder. 
%
% Additional input options: 
% CavAudioHPH_FolderBatchAnalysis(folderName,fMin,fMax,Imin,Imax,doSaveStructure)
% fMin: Minimum frequency to use in calculating the audio integral 
% fMax: Maximum frequency to use in calculating the audio integral
% Imin: Renormalization, minimum value 
% Imax: Renormalization, maximum value 
%doSaveStructure: Set to 1 if save structrues with details to .mat-file
%(default 0) 
%
% Additional output option: 
% [I_vector,I_table] = CavAudioHPH_FolderBatchAnalysis(folderName,fMin,fMax,Imin,Imax,doSaveStructure)
% I_table: A MATLAB table containing I, I* and the file-name. For example,
% this could be used to write a Spreadsheet file using:  
% writetable(I_table,'myOutputFile.xlsx')
%
% Andreas Hakansson, 2025, andreas.hakansson@ple.lth.se


%% Default settings
if nargin < 2
    fMin     = 30e3; %Integrate from 30 to 45 kHz
    fMax     = 45e3;
end
if nargin < 4 
    Imin     = -1.35e4; %Default re-normalization-limits 
    Imax     = -1.31e4;
end
if nargin < 6
    doSaveStructure     = 0;  %Set to 1 to save a .mat-file with detailed data  
end

cutTime = 0;  %Analyize the whole recording
doDisp  = 0;  %Do not plot

%% Listing all wav-files in folder:
allAudioFiles = dir([folderName,'\*.wav']);
K = numel(allAudioFiles); %Number of files in the folder


%% Looping over to save all files
for k=1:K   
    [I(k),outStr{k}] = CavAudioHPH_SingleFileAnalysis([folderName,'\',allAudioFiles(k).name],cutTime,doDisp,fMin,fMax);
    disp(['Done analyzing file ',num2str(k), ' out of ',num2str(K),'...'])
    fileName{k} = [folderName,'\',allAudioFiles(k).name];
end

%% Re-normalization (I -> I^*)
k = -1/(Imin-Imax);
m = -Imin/(Imax-Imin);
Ifcn = @(I) k.*I+m;
Istar = Ifcn(I);

% Saving results 
I_vector = Istar;

varNames = {'FileName','I*','I'};
I_table = table(fileName',I_vector',I','VariableNames',varNames);


%% Saving detailed information (optional)
if doSaveStructure == 1
    saveName = [folderName,'_CavAudioHPH_details.mat'];
    save(saveName,'outStr');
end



