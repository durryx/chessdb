# Logical Data Model

1. Games Table -- where the moves are stored

| games | id | result | id_white | id_black | moves |
| - | - | - | - | - | - |
| / | INT | VARCHAR | INT | INT | VARCHAR |

2. IDs table - associate IDs to usernames

| ids | id | user |
| - | - | - |
| / | INT   | VARCHAR |

## Importation phase
Temporarely import every field in separate tables and then insert them into *games* table, the entries are in order.

TABLE **import_result** -> *result* <br>
TABLE **import_white** -> *id_white* <br>
TABLE **import_black** -> *id_black* <br>
TABLE **import_moves** -> *moves* <br>