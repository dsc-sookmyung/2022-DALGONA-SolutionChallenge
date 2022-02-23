package com.dalgona.zerozone.domain.letter;

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
public class Onset {

    @Id
    @Column(name = "ONSET_ID")
    private Long id;

    @Column(length = 5, nullable = false, unique = true)
    private String onset;

}
