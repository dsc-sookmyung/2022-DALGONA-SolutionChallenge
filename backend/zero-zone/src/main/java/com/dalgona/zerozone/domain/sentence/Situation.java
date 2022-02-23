package com.dalgona.zerozone.domain.sentence;

import com.dalgona.zerozone.domain.letter.Onset;
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
public class Situation {

    @Id
    @Column(name = "SITUATION_ID")
    private Long id;

    @Column(length = 200, nullable = false, unique = true)
    private String situation;

}
