package com.dalgona.zerozone.domain.content.letter;

import com.dalgona.zerozone.domain.content.Content;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class Onset extends Content {

    @Id
    @Column(name = "ONSET_ID")
    private Long id;

    @Column(length = 5, nullable = false, unique = true)
    private String onset;
/*
    @Builder
    public Onset(Long id, String onset){
        this.id = id;
        this.onset = onset;
    }
*/
}
