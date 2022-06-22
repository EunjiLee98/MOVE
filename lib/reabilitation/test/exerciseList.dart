import 'exerciseItem.dart';
import 'exercise_handler.dart';

Map<String, Exercise> Exercises = {
  "dumbell_curl": Exercise(
      exercise_image: 'assets/img/card_dumbellcurl.png',
      exercise_name: "dumbell_curl",
      exercise_displayName: "Dumbell curl",
      reps: 1,
      sets: 1,
      handler: DumbellCurlHandler()),
};
