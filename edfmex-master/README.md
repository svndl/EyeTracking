# edfmex
A mex file to load edf files into a Matlab struct

#actions

run makeHeader from Matlab command line. You should see a new file "edf2mex.h"

switch directory to source subfolder
run in Matlab command line
mex edfmex.cpp CXXFLAGS="\$CXXFLAGS -I/Library/Frameworks/edfapi.framework/Headers" LDFLAGS="\$LDFLAGS -framework edfapi"

if you'll see an error about char16_t type, add the following text
mex -Dchar16_t=uint16_t edfmex.cpp CXXFLAGS="\$CXXFLAGS -I/Library/Frameworks/edfapi.framework/Headers" LDFLAGS="\$LDFLAGS -framework edfapi"