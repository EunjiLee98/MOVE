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
