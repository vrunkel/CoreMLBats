# CoreMLBats
Image Machine Learning demo for bat call identification

CoreMLBats is provided by ecoObs GmbH and Volker Runkel as a demo application that uses Apple ML framework and a trained image model for classification of bat calls.

The input images must be sonograms created as black and white images with a dimension of 512 to 512 pixels. The call itself should be rendered exactly centered as black outline with no or as little noises around the call. FFT settings must be 1024 window size, overlap 96% and optimally a harris window. This can be best achieved using bcAnalyze 3 and a custom color gradient. After selecting a call in the measurement sonogram of bcAnalyze 3 you can right click and choose to save a single image which will create the 512x512 png image for analysing with CoreMLBats.

In addition the v2 adds models for classifying tabular data created from bcAnalyze or bcAdmin (batIdent2 format).

You can download the sources using GitHub or a [binary version ready to run](docs/CoreMLBats.zip)
