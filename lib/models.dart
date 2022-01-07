class Employee {
  int? id;
  String name;
  Job job;

  Employee(this.id, this.name, this.job);

  static const String tableName = 'Employees';

  static const String createTableStatement = '''
    CREATE TABLE Employees (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      job_id INTEGER NOT NULL,
      supervisor_id INTEGER,
      FOREIGN KEY(job_id) REFERENCES Jobs(id)
    );
  ''';

  String get insertStatement => '''
    INSERT INTO Employees(name, job_id)
    VALUES('$name', ${job.id!});
    ''';
}

class Job {
  int? id;
  String title;
  String description;

  Job(this.id, this.title, this.description);

  static const String tableName = 'Jobs';

  static const String createTableStatement = '''
    CREATE TABLE Jobs (
      id INTEGER PRIMARY KEY NOT NULL,
      title TEXT NOT NULL,
      description TEXT NOT NULL
    );
  ''';

  String get insertStatement => """
    INSERT INTO Jobs(id, title, description)
    VALUES($id, '$title', '$description');
  """;
}
