class Exercise {
  const Exercise(
    this.question,
    this.options,
    this.correct,
    this.hint,
    this.explanation,
    this.errors, {
    this.steps = const [],
    this.difficulty = 0,
    this.skill = '',
    this.visual,
  });
  final String question;
  final List<String> options;
  final int correct;
  final String hint;
  final String explanation;
  final List<String> errors;
  final List<String> steps;
  final int difficulty;
  final String skill;
  final StudyVisual? visual;
}

class Lesson {
  const Lesson(
    this.id,
    this.title,
    this.subtitle,
    this.symbol,
    this.theory,
    this.example,
    this.steps,
    this.exercises, {
    this.guide,
  });
  final String id, title, subtitle, symbol, theory, example;
  final List<String> steps;
  final List<Exercise> exercises;
  final StudyGuide? guide;
}

class StudyGuide {
  const StudyGuide(
    this.prerequisites,
    this.objectives,
    this.formulas,
    this.pitfall,
  );
  final List<String> prerequisites, objectives, formulas;
  final String pitfall;
}

/// Original mathematical data, drawn by Flutter without image assets.
class StudyVisual {
  const StudyVisual(
    this.kind,
    this.caption,
    this.values, {
    this.series = const [],
  });
  final String kind, caption;
  final List<List<double>> values;
  final List<List<List<double>>> series;
}

class Season {
  const Season(this.number, this.title, this.description, this.lessons);
  final int number;
  final String title, description;
  final List<Lesson> lessons;
  bool get available => lessons.isNotEmpty;
}
