package com.dalgona.zerozone.domain.customProbs.customReading;

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
public class CustomReadingProb {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "C_READINGPROBS_ID")
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

    @Column(length = 100)
    private String hint;

    @Column(length = 100)
    private String spacing_info;

    @Builder
    public CustomReadingProb(String type, String content, String hint, String spacing_info, String url, User user) {
        this.hint = hint;
        this.spacing_info = spacing_info;
        this.user = user;
        this.type = type;
        this.content = content;
        this.url = url;
    }

    public void updateType(String type) {
        this.type = type;
    }

    public void updateHint(String hint) {
        this.hint = hint;
    }

    public void updateSpacingInfo(String spacing_info) {
        this.spacing_info = spacing_info;
    }

    public void updateContent(String content) {
        this.content = content;
    }

    public void updateUrl(String newURL) {
        this.url = newURL;
    }
}
