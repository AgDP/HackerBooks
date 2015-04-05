# HackerBooks

1 - ¿Qué otros métodos similares hay? ¿En qué se distingue isMemberOfClass: ?

R: isKindOfClass: y isMemberOfClass: 
isKindOfClass se utiliza para saber si es la clase o una subclase por ejemplo NSArray y NSMutableArray. En cambio isMemberOfClass solo te dice si es una clase especifica. 

2 - ¿Cómo harías eso? ¿Se te ocurre más de una forma de hacerlo? Explica la decisión de diseño que hayas toma
do.
R: He guardado los favoritos cuando la app pasa a segundo plano, ya que mientras tanto utiliza el modelo que tiene cargado y no hace falta penalizar tiempos en guardarlo. La duda que tengo es si puede existir algún momento en que la app se cierre sin pasar por segundo plano.

3 - Cuando cambia el valor de la propiedad isFavorite de un AGTBook, la tabla deberá
￼reflejar ese hecho. ¿Cómo lo harías? Es decir, ¿cómo enviarías información de un AGTBook a un AGTLibraryTableViewController? ¿Se te ocurre más de una forma de hacerlo? ¿Cual te parece mejor? Explica tu elección.

R: Mi diseño lo he realizado con Notificaciones ya que el AGTLibraryTableViewController tiene un delegado. Aquí he tenido una duda en donde meter la notificación ya que al no ver la tabla se da de baja de las notificaciones y lo he solucionado dando de alta la notificación en appDelegate y luego llama a un método en la tabla pero no creo que ésto sea correcto.

4 - ¿Es esto una aberración desde el punto de rendimiento (volver a cargar datos que en su mayoría ya estaban correctos)? Explica por qué no es así. ¿Hay una forma alternativa? ¿Cuando crees que vale la pena usarlo?

R: No me ha dado tiempo a ver la documentación pero entiendo que los datos los tiene guardados por lo que no lo carga otra vez.

5 - Cuando el usuario cambia en la tabla el libro seleccionado, el AGTSimplePDFViewController debe de actualizarse. ¿Cómo lo harías?

R: Lo he realizado con Notificaciones porque me resulta mucho más facil, pero claro, es como comentaba Fernando que luego seguir el camino es complicado y es poco mantenible.


Comentarios: Me ha faltado la parte de descargar los PDFs para no cargarlos cada vez que entremos, pero en principio lo haría como las imagenes. Me ha costado lo de los delegados y he optado para no perder tiempo en poner notificaciones cuando tenía alguna duda con el tipo de comunicación. El diseño es penoso, lo siento y algún código que he metido por ir rápido, como poner 3 for anidados, no tenerlo en cuenta por favor :). Ya he convertido StackOverflow en mi nueva biblia (nunca había entrado tanto en tan poco tiempo). Me queda la parte extra de la práctica pero la completaré cuando tenga un poco de tiempo.
