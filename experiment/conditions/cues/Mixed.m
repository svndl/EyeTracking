function dotFrames = Mixed(stmInfo)    
    halfDots = round(stmInfo.numDots*0.5);
    
    same = stmInfo;
    same.numDots = halfDots;

    sameFrames = CDOT(same);
    
    different = stmInfo;
    different.numDots = halfDots;
    
    differentFrames =  FullCue(different);
    
    
    dotFrames.L.x = cat(2, sameFrames.L.x, differentFrames.L.x);
    dotFrames.L.y = cat(2, sameFrames.L.y, differentFrames.L.y);
    
    dotFrames.R.x = cat(2, sameFrames.R.x, differentFrames.R.x);        
    dotFrames.R.y = cat(2, sameFrames.R.y, differentFrames.R.y);        
end