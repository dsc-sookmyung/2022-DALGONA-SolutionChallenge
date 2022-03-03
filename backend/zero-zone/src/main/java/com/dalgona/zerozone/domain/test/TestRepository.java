package com.dalgona.zerozone.domain.test;

import com.dalgona.zerozone.domain.user.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TestRepository extends JpaRepository<Test, Long> {

    Page<Test> findAllByUser(User user, Pageable paging);

}
