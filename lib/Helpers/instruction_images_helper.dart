final List<List<String>> instructionImages = [
  ['plank holds', 'https://github.com/KizKizz/workout_planner/blob/main/workout_gifs/Plank%20Hold.gif?raw=true'],
];

String activityImageGet(String activity) {
  for (var list in instructionImages) {
    if (list.first.toLowerCase() == activity.toLowerCase()) {
      return list.last;
    }
  }
  return 'https://raw.githubusercontent.com/KizKizz/workout_planner/main/workout_gifs/gif-placeholder.webp';
}
