package com.dalgona.zerozone.domain.user;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserEmailAuthRepository extends JpaRepository<UserEmailAuth, Long> {
    Optional<UserEmailAuth> findByEmail(String email);
}