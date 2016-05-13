function val = convertValues(trials, eyelinkInfo, ipd)
% convert href to vergence, etc

    val.LxCm = trials.Lx.*eyelinkInfo.href2cm;
    val.LyCm = trials.Ly.*eyelinkInfo.href2cm;
    val.RxCm = trials.Rx.*eyelinkInfo.href2cm;
    val.RyCm = trials.Ry.*eyelinkInfo.href2cm;
    
    val.LxAng = screen2deg(val.LxCm, eyelinkInfo, ipd);
    val.LyAng = screen2deg(val.LyCm, eyelinkInfo, ipd);
    val.RxAng = screen2deg(val.RxCm, eyelinkInfo, -ipd);
    val.RyAng = screen2deg(val.RyCm, eyelinkInfo, -ipd);
    
    val.vergenceH = val.LxAng - val.RxAng;
    val.vergenceV = val.LyAng - val.RyAng;
    
    val.versionH = nanmean(cat(3, val.LxAng, val.RxAng), 3);
    val.versionV = nanmean(cat(3, val.LyAng, val.RyAng), 3);
end
