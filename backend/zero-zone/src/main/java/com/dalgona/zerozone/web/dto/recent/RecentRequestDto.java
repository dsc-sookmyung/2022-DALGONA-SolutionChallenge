package com.dalgona.zerozone.web.dto.recent;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
public class RecentRequestDto {

    List<Long> recentProbIdRequestList;

}
