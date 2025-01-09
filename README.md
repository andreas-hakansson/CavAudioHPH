**CavAudioHPH**
Reads recorded audio files (typically 20 s long) intended to analyze cavitation in high-pressure homogenizers (HPHs), calculates spectra and calculates the audio integral. 

*Installation* 
1. Download the MATLAB files in a folder.
2. Download the ZIP-file in the same folder. Ensure that the 'exampleAudioFolder' is placed diretly under the folder where the MATLAB files have been downloaded. 

*Testing the installation*
1. Start MATLAB
2. Navigate to the folder where you downloded the MATLAB files
3. Via the Command Line, run: CavAudioHPH_exampleScript
This should run a batch analysis of all (two) files in the exampleAudioFolder, calculate the audio integrals and plot the spectra of the two measurements. 

*Analyzing single audio files*
This performs the analysis on a single file, with a specified path. 
Run (in the Command line)
 I = CavAudioHPH_SingleFileAnalysis(fileName)
where 'fileName' is the path to the audio recording you wich to analyze. This runs the analysis with standard settings. To run with non-default settings and/or to extract information such as spectra, please see the documentation (help CavAudioHPH_SingleFileAnalysis)
NB! The function will take very long to run if attempting to process files which are much longer than 20s!

*Analyzing  audio files in batch*
This automatically analyses all files in a givn folder. This is the recommended method for analyzing large experimental datasets.   
Run (in the Command line)
 I_vector = CavAudioHPH_FolderBatchAnalysis(folderName)
where 'folderName' is the name of a folder (placed in the same path as the MATLAB functions) contianing all the audio-files. Note that the function only reads wav-files. 
NB! The function will take very long to run if attempting to process files which are much longer than 20s!

