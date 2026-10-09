class Exercise {
  const Exercise(
    this.question,
    this.options,
    this.correct,
    this.hint,
    this.explanation,
    this.errors,
  );
  final String question;
  final List<String> options;
  final int correct;
  final String hint;
  final String explanation;
  final List<String> errors;
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
    this.exercises,
  );
  final String id, title, subtitle, symbol, theory, example;
  final List<String> steps;
  final List<Exercise> exercises;
}

class Season {
  const Season(this.number, this.title, this.description, this.lessons);
  final int number;
  final String title, description;
  final List<Lesson> lessons;
  bool get available => lessons.isNotEmpty;
}
