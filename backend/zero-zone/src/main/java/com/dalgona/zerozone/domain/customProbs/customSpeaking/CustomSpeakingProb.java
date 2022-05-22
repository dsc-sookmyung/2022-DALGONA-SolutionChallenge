package com.dalgona.zerozone.domain.customProbs.customSpeaking;

import com.dalgona.zerozone.domain.user.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class CustomSpeakingProb {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "SPEAKINGPROBS_ID")
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(length = 20, nullable = false)
    private String type;

    @Column(length = 200)
    private String content;

    @Column
    private String url;

    @Builder
    public CustomSpeakingProb(String type, String content, String url, User user) {
        this.user = user;
        this.type = type;
        this.content = content;
        this.url = url;
    }

    public CustomSpeakingProb updateType(String type){
        this.type = type;
        return this;
    }

    public CustomSpeakingProb updateContent(String content){
        this.content = content;
        return this;
    }

    public CustomSpeakingProb updateUrl(String url){
        this.url = url;
        return this;
    }

}
