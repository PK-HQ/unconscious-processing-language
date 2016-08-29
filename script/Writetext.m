function[]= Writetext(wPtr,text,LeftboxXCenter,RightboxXCenter,YCenter, xadj,yadj, color,fontsize)
Screen(wPtr,'TextFont','sathu');
Screen(wPtr,'TextSize', fontsize);
Screen('DrawText',wPtr,char(text), RightboxXCenter-xadj, YCenter-yadj, color);
Screen('DrawText',wPtr,char(text), LeftboxXCenter-xadj, YCenter-yadj, color);

end