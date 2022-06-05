package com.dalgona.zerozone.hangulAnalyzer;

public class SpacingInfoCreator {

    static String regexp = ".*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*";
    static String to = "_ ";

    public static String createSpacingInfo(String content){
        content = content.replace(" ", "  ");
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

        spacing_info = spacing_info.replace("   ","  ");
        System.out.println("spacing_info = " + spacing_info);

        return spacing_info;
    }

}
