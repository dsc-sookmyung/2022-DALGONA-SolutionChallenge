package com.dalgona.zerozone.domain.test;

import com.dalgona.zerozone.domain.BaseTimeEntity;
import com.dalgona.zerozone.domain.user.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Test extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 100, nullable = false, unique = true)
    private String testName;

    @Column
    private int probsCount;

    @Column
    private int correctCount;

    @ManyToOne
    @JoinColumn(name = "USER_ID")
    private User user;

    @OneToMany(mappedBy = "test")
    private List<TestProbs> testProbs = new ArrayList<>();

    @Builder
    public Test(String testName, int probsCount, int correctCount, User user){
        this.testName = testName;
        this.probsCount = probsCount;
        this.correctCount = correctCount;
        this.user = user;
    }

    public Test updateTestName(String newName){
        this.testName = newName;
        return this;
    }

}
