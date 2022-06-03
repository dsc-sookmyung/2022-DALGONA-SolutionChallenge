package com.dalgona.zerozone.hangulAnalyzer;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class URLEnocder {
    private static final String endpoint = "https://storage.googleapis.com/zerozone-custom-video/";
    private static final String fileExtension = ".mp4";

    public static String generateURL(String input_text, BucketType bucketType) {
        String txtEnc;
        String dir;
        if(bucketType==BucketType.t_custom) dir = "custom/";
        else if(bucketType==BucketType.t_static) dir = "static/";
        else throw new IllegalArgumentException("잘못된 요청입니다");
        try {
            txtEnc = URLEncoder.encode(input_text, "UTF-8");
            String result =  endpoint + dir + txtEnc + fileExtension;
            return result;
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return "";
    }

    public static String spaceToUnderscore(String sentenceIncludeSpace){
        return sentenceIncludeSpace.replaceAll("\\s","_");
    }

    public static String generateURLWithTypeAndToken(String type, String content, BucketType bucketType) {
        String filename;
        if(type.compareTo("letter")==0 || type.compareTo("word")==0){
            filename = content;
        }
        else if(type.compareTo("sentence")==0){
            filename = URLEnocder.spaceToUnderscore(content);
        }
        else {
            throw new IllegalArgumentException(type + ": 잘못된 타입입니다");
        }
        return URLEnocder.generateURL(filename, bucketType);
    }
}
