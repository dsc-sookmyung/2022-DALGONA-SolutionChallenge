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
public class Nucleus extends Content {

    @Id
    @Column(name = "NUCLEUS_ID")
    private Long id;

    @Column(length = 5, nullable = false, unique = true)
    private String nucleus;

}
