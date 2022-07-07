import 'dart:math';

double getAngle(List<int> pointA, List<int> pointB, List<int> pointC) {
  double radians = atan2(pointC[1] - pointB[1], pointC[0] - pointB[0]) -
      atan2(pointA[1] - pointB[1], pointA[0] - pointB[0]);
  double angle = (radians * 180 / pi).abs();

  if (angle > 180) {
    angle = 360 - angle;
  }

  return angle;
}

double getDistance(int x1, int x2, int y1, int y2) {
  double distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y2, 2));

  return distance;
}

//7월 5일 아이코어 인터뷰 수행 2명
//아이템 기능 검증
//앱 시나리오를 보여주고 사용자의 경험 및 의견 듣기

//7월 6일 아이코어 인터뷰 수행 4명
//사용자의 경험을 위주로 듣기
//가지고 있는 아이템 기능을 시나리오로 설명해서 검증하기
//다양한 타겟층을 대상으로

//7월 7일 아이코어 인터뷰 수행 및 최종발표 준비
//2명 추가 인터뷰
//향후계획 세우기 - 인터뷰 타겟 찾기
//최종 피피티 제출
