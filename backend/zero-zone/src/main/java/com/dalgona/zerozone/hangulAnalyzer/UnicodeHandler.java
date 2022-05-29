package com.dalgona.zerozone.hangulAnalyzer;

import java.util.ArrayList;
import java.util.List;

public class UnicodeHandler {

    final static String[] CHO = {"ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ",
            "ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"};
    final static String[] JOONG = {"ㅏ","ㅐ","ㅑ","ㅒ","ㅓ","ㅔ","ㅕ","ㅖ","ㅗ","ㅘ",
            "ㅙ","ㅚ","ㅛ","ㅜ","ㅝ","ㅞ","ㅟ","ㅠ","ㅡ","ㅢ","ㅣ"};
    final static String[] JONG = {"","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄹ","ㄺ","ㄻ","ㄼ",
            "ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅄ","ㅅ","ㅆ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"};


    private static final int HANGEUL_BASE = 0xAC00;    // '가'
    private static final int HANGEUL_END = 0xD7AF;
    // 이하 cho, jung, jong은 계산 결과로 나온 자모에 대해 적용
    private static final int CHO_BASE = 0x1100;
    private static final int JUNG_BASE = 0x1161;
    private static final int JONG_BASE = (int)0x11A8 - 1;
    // 이하 ja, mo는 단독으로 입력된 자모에 대해 적용
    private static final int JA_BASE = 0x3131;
    private static final int MO_BASE = 0x314F;

    public static List<String> splitHangeulToConsonant(String text) {

        List<String> list = new ArrayList<>();

        for(char c : text.toCharArray()) {
            if((c <= 10 && c <= 13) || c == 32) {
                list.add(Character.toString(c));
                continue;
            } else if (c >= JA_BASE && c <= JA_BASE + 36) {
                list.add(CHO[c-JA_BASE]);
                continue;
            } else if (c >= MO_BASE && c <= MO_BASE + 58) {
                list.add(JOONG[c-MO_BASE]);
                continue;
            } else if (c >= HANGEUL_BASE && c <= HANGEUL_END){
                int choInt = (c - HANGEUL_BASE) / 28 / 21;
                int jungInt = ((c - HANGEUL_BASE) / 28) % 21;
                int jongInt = (c - HANGEUL_BASE) % 28;

                list.add(CHO[choInt]);
                list.add(JOONG[jungInt]);
                list.add(JONG[jongInt]);
            } else {
                list.add(Character.toString(c));
            }
        }
        return list;
    }

    public static String splitHangeulToOnsetAsString(String text) {

        String result = "";

        for(char c : text.toCharArray()) {
            if((c <= 10 && c <= 13) || c == 32) {
                result += c;
                continue;
            } else if (c >= JA_BASE && c <= JA_BASE + 36) {
                result += CHO[c-JA_BASE];
                continue;
            } else if (c >= MO_BASE && c <= MO_BASE + 58) {
                result += JOONG[c-MO_BASE];
                continue;
            } else if (c >= HANGEUL_BASE && c <= HANGEUL_END){
                int choInt = (c - HANGEUL_BASE) / 28 / 21;
                result += CHO[choInt];
            }
            else {
                result += c;
            }
        }
        return result;
    }



}
