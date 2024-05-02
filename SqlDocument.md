- Define en el documento que significado tienen las terminaciones ci, ai y que otras opciones existen.

Intercalaciones con sensibilidad o no a mayúsculas y minúsculas (CS=Case Sensitive o CI=Case Insensitive). En una intercalación Case Insensitive, A es igual a a, mientras en una Case Sensitive no lo son.

Intercalaciones con sensibilidad o no a acentos. (AS=Accent Sensitive y AI=Accent Insensitive). En una intercalación Accent Insensitive, á es igual a a, mientras que en una Accent Sensitive no son iguales.

- Abre el documento Word y escribe para que se usa cada uno de los tipos, su tamaño en bytes, las diferencias entre campos con un tipo similar y describe cuando es mejor usar uno u otro, compara los tipos numéricos, string, datetimes, unique identifier, etc.

CHAR:
Uso: Almacena cadenas de longitud fija.
Tamaño: Depende de la longitud especificada, cada carácter ocupa 1 byte.
Diferencia con VARCHAR: CHAR siempre ocupa el mismo espacio de almacenamiento, independientemente de la longitud de la cadena, mientras que VARCHAR solo ocupa el espacio necesario para almacenar los datos.
Mejor uso: Para datos de longitud fija, como códigos postales o códigos de país.

NCHAR:
Uso: Similar a CHAR, pero para almacenar caracteres Unicode.
Tamaño: Depende de la longitud especificada, cada carácter ocupa 2 bytes.
Diferencia con NVARCHAR: Al igual que CHAR y VARCHAR, NCHAR y NVARCHAR difieren en que NCHAR almacena caracteres Unicode, mientras que CHAR almacena caracteres de un conjunto de caracteres específico.
Mejor uso: Para datos de longitud fija que requieren soporte Unicode, como nombres de personas.

UNIQUEIDENTIFIER:
Uso: Almacena un identificador único global (GUID).
Tamaño: 16 bytes.
Diferencia con otros tipos de datos: Los UNIQUEIDENTIFIER son útiles cuando necesitas generar identificadores únicos a nivel mundial, por ejemplo, para identificar de manera única filas en tablas distribuidas o replicadas.
Mejor uso: Para asignar identificadores únicos a entidades de datos, especialmente en entornos distribuidos.

INT:
Uso: Almacena números enteros.
Tamaño: 4 bytes.
Diferencia con BIGINT: INT puede almacenar números enteros más pequeños que BIGINT, lo que lo hace más eficiente en términos de almacenamiento.
Mejor uso: Para almacenar números enteros dentro de un rango relativamente pequeño.

DOUBLE:
Uso: Almacena números de punto flotante de doble precisión.
Tamaño: 8 bytes.
Diferencia con FLOAT: DOUBLE proporciona una mayor precisión que FLOAT.
Mejor uso: Para almacenar números decimales que requieren una alta precisión, como cantidades monetarias.

MONEY:
Uso: Almacena valores de dinero.
Tamaño: 8 bytes.
Diferencia con DECIMAL: MONEY es una implementación específica de SQL Server que almacena valores monetarios con precisión fija y redondea los valores automáticamente.
Mejor uso: Para almacenar valores monetarios cuando la precisión fija y el redondeo automático son importantes, como en aplicaciones financieras.

VARCHAR / NVARCHAR:
Uso: Almacenan cadenas de longitud variable.
Tamaño: Depende de la longitud de la cadena almacenada.
Diferencia con CHAR / NCHAR: VARCHAR y NVARCHAR ocupan solo el espacio necesario para almacenar los datos, mientras que CHAR y NCHAR ocupan espacio adicional debido a su longitud fija.
Mejor uso: Para datos de longitud variable, como descripciones de productos o comentarios de usuarios.

DATETIME / DATETIME2:
Uso: Almacenan fechas y horas.
Tamaño: DATETIME ocupa 8 bytes, mientras que DATETIME2 puede ocupar de 6 a 8 bytes dependiendo de la precisión.
Diferencia con DATE / TIME: DATETIME almacena tanto fecha como hora, mientras que DATE y TIME almacenan solo la fecha o la hora respectivamente. DATETIME2 proporciona una mayor precisión que DATETIME.
Mejor uso: Para almacenar información de fecha y hora, como registro de eventos o transacciones.

- Describe cuando es adecuado usar default values en el diseño de una tabla, escribe distintos ejemplos de default values usando distintos tipos de campos.

Los valores predeterminados (default values) en el diseño de una tabla son útiles cuando deseas proporcionar un valor predeterminado para una columna en caso de que no se especifique un valor al insertar una nueva fila en la tabla. Esto puede simplificar el proceso de inserción de datos y garantizar la coherencia de los datos en la base de datos. Aquí hay algunas situaciones en las que sería adecuado usar valores predeterminados:

1.- Fecha de Creación: Puedes establecer una columna "created_at" con un valor predeterminado de la fecha y hora actual al insertar una nueva fila. Esto es útil para rastrear cuándo se agregaron registros a la tabla.

created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

2.- Estado Activo/Inactivo: Si tienes una columna para indicar el estado de un elemento, por ejemplo, "active" para indicar si un usuario está activo o inactivo, puedes establecer un valor predeterminado de "1" para activo y "0" para inactivo.

active BOOLEAN DEFAULT 1

3.- Prioridad: Para una columna que indique la prioridad de un elemento, como la prioridad de una tarea en una lista, podrías establecer un valor predeterminado de "0".

priority INT DEFAULT 0

- Analiza que columnas deben usar nulos y cuales no, define ventajas y desventajas usando columnas con o sin nulos.

Ventajas de usar valores nulos:

1.- Flexibilidad en los datos: Permiten representar datos faltantes o desconocidos de manera explícita, lo que proporciona flexibilidad en la gestión de datos incompletos o opcionales.

2.- Ahorro de espacio: Si una columna puede ser nula y el valor nulo es común, no se desperdicia espacio almacenando valores predeterminados repetidos.

3.- Consultas más simples: Al permitir valores nulos, las consultas pueden ser más simples y legibles ya que no es necesario tratar con valores predeterminados artificiales.

Desventajas de usar valores nulos:

1.- Mayor complejidad en la validación: A menudo es necesario tener en cuenta los valores nulos al escribir consultas y aplicar restricciones, lo que puede aumentar la complejidad del código y la lógica de validación.

2.- Potencial para errores de lógica: La presencia de valores nulos puede llevar a errores de lógica si no se manejan adecuadamente en consultas y aplicaciones.

3.- Mayor riesgo de inconsistencia: Los valores nulos pueden introducir inconsistencias en los datos si no se gestionan de manera coherente en toda la base de datos.

- Los campos clave pueden estar compuestos de varios campos, describe cuando usarías esta estrategia y si te parece una buena práctica.

Se utiliza en situaciones donde una única columna no puede garantizar la unicidad de las filas en una tabla. Esto ocurre cuando la combinación de dos o más columnas es necesaria para identificar de forma única cada fila.

Hay varias razones por las que podrías optar por utilizar claves primarias compuestas:

1.- Modelado de datos preciso: En algunos casos, el modelo de datos requiere la combinación de múltiples atributos para identificar de manera única una entidad

2.- Optimización de consultas: Algunas consultas pueden beneficiarse de la indexación de una clave primaria compuesta. Si a menudo buscas datos basados en una combinación específica de columnas, tener una clave primaria compuesta que refleje esa combinación puede mejorar el rendimiento de las consultas.

3.- Integridad referencial: En situaciones donde una relación entre dos tablas depende de múltiples columnas, utilizar una clave primaria compuesta puede ayudar a mantener la integridad referencial entre esas tablas.

Sin embargo, también hay consideraciones a tener en cuenta:

1.-Complejidad: La introducción de claves primarias compuestas puede aumentar la complejidad del diseño de la base de datos y de las consultas asociadas. Esto puede dificultar el mantenimiento y la comprensión del esquema de la base de datos.

2.- Posibles problemas de rendimiento: Aunque las claves primarias compuestas pueden mejorar el rendimiento de algunas consultas, también pueden introducir problemas de rendimiento en otras situaciones. Es importante considerar cómo se utilizarán las tablas y qué consultas serán comunes antes de decidir sobre el uso de claves primarias compuestas.

- Usando triggers o campos calculados haz que los campos Total y TotalLine de las tablas se actualice cada vez que un campo relacionado con estos cálculos se actualice. Razona y describe en el documento (Antes de buscarlo en ChatGPT), que ventajas y desventajas representa el uso de campos calculados o triggers.

Campos Calculados:

Ventajas:

1.- Simplicidad de uso: Los campos calculados permiten definir cálculos directamente en la definición de la tabla, lo que facilita su uso y comprensión.
2.- Mantenimiento simplificado: Al definir los cálculos directamente en la estructura de la tabla, los cambios en los cálculos son más fáciles de realizar y mantener.
3.- Optimización de rendimiento: Los campos calculados pueden ser indexados, lo que puede mejorar el rendimiento de las consultas que dependen de esos cálculos.

Desventajas:

1.- Redundancia de datos: Los campos calculados pueden llevar a la redundancia de datos si el mismo cálculo se realiza en múltiples lugares de la base de datos.
2.- Limitaciones de complejidad: Algunos cálculos pueden ser demasiado complejos para ser manejados eficientemente como campos calculados, lo que podría requerir el uso de otras técnicas más avanzadas.
3.- Impacto en el rendimiento de la inserción y actualización: Los campos calculados pueden afectar el rendimiento de las operaciones de inserción y actualización, especialmente si los cálculos son costosos.

Triggers:

Ventajas:

1.- Flexibilidad: Los triggers pueden realizar una amplia variedad de acciones en respuesta a eventos específicos, lo que proporciona una gran flexibilidad en la lógica de negocio y las reglas de integridad.
2.- Integridad de datos: Los triggers pueden garantizar la integridad de los datos al aplicar reglas de negocio complejas o realizar validaciones adicionales.
3.- Auditabilidad: Los triggers pueden ser utilizados para rastrear y auditar cambios en los datos, proporcionando un registro de las acciones realizadas en la base de datos.

Desventajas:

1.- Complejidad: Los triggers pueden introducir complejidad adicional en la base de datos, especialmente cuando se utilizan para implementar reglas de negocio complejas.
2.- Dificultad de mantenimiento: Los triggers pueden ser difíciles de mantener y depurar, especialmente en bases de datos con una gran cantidad de triggers o con lógica de negocio compleja.
3.- Impacto en el rendimiento: Los triggers pueden afectar el rendimiento de las operaciones de inserción, actualización y eliminación, especialmente si realizan operaciones costosas o si se disparan con frecuencia.

- Diferentes campos de una tabla pueden tener distintos collation. Describe las limitaciones de su uso y diseña una tabla con este ejemplo.

Cuando se tienen diferentes collations en los campos de una tabla, es importante considerar algunas limitaciones y posibles complicaciones que pueden surgir:

1.- Comparaciones y ordenamientos inconsistentes: Las consultas que involucran comparaciones o ordenamientos entre campos con diferentes collations pueden producir resultados inconsistentes o errores. Esto se debe a que el ordenamiento y la comparación de cadenas pueden variar según la configuración de collation utilizada en cada campo.

2.- Joins problemáticos: Las operaciones de JOIN entre campos con collations diferentes pueden ser problemáticas, ya que el motor de base de datos debe realizar conversiones implícitas para igualar los collations antes de realizar la comparación.

3.- Overhead de rendimiento: Las conversiones implícitas realizadas para igualar collations pueden generar un overhead de rendimiento, especialmente en tablas con un gran volumen de datos.

CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY,
    Nombre NVARCHAR(100) COLLATE Latin1_General_CI_AI, -- Collation para nombres en español
    Apellido NVARCHAR(100) COLLATE French_CI_AI, -- Collation para apellidos en francés
    Email NVARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS -- Collation por defecto para emails
);
