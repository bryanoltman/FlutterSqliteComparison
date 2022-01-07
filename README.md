# FlutterSqliteComparison

Comparing the performance of two different sqlite libraries by `INSERT`ing 10000 rows one-by-one
and then `SELECT`ing all rows in that table.

## Results

Running on a Pixel 4a, we see the following (results formatted as h:mm:ss):

| Library   | Inserting 10000 rows | SELECTing 10000 rows |
| :---      |    :----:           |  ---:                |
| sqlite3   | 0:00:44.044629       | 0:00:00.032467       |
| sqflite   | 0:05:33.144242       | 0:00:00.133296       |
