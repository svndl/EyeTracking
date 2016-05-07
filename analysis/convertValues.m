function val = convertValues(trials, eyelinkInfo, ipd)
% convert href to vergence, etc

    val.LxCm = trials.LEx.*eyelinkInfo.href2cm;
    val.LyCm = trials.LEy.*eyelinkInfo.href2cm;
    val.RxCm = trials.REx.*eyelinkInfo.href2cm;
    val.RyCm = trials.REy.*eyelinkInfo.href2cm;
    
    val.LxAng = screen2deg(val.LxCm, eyelinkInfo, ipd);
    val.LyAng = screen2deg(val.LyCm, eyelinkInfo, ipd);
    val.RxAng = screen2deg(val.RxCm, eyelinkInfo, -ipd);
    val.RyAng = screen2deg(val.RyCm, eyelinkInfo, -ipd);
    
    val.vergenceH = val.LxAng - val.RxAng;
    val.vergenceV = val.LyAng - val.RyAng;
    
    val.versionH = mean(cat(3, val.LxAng, val.RxAng), 3);
    val.versionV = mean(cat(3, val.LyAng, val.RyAng), 3);
end
