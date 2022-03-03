package com.dalgona.zerozone.domain.test;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TestProbsRepository extends JpaRepository<TestProbs, Long> {

    Page<TestProbs> findAllByTest(Test test, Pageable paging);

}
