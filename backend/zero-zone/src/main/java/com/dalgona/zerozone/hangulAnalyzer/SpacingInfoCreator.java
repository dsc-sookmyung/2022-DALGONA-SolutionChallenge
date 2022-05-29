package com.dalgona.zerozone.hangulAnalyzer;

public class SpacingInfoCreator {

    static String regexp = ".*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*";
    static String to = "_";

    public static String createSpacingInfo(String content){
        String arr[] = content.split("");
        String spacing_info = "";

        for(String token : arr){
            if(token.matches(regexp)) {
                spacing_info += to;
            }
            else{
                spacing_info += token;
            }
        }
        return spacing_info;
    }

}
