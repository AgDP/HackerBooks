//
//  AGTLibraryTableViewController.m
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import "AGTLibraryTableViewController.h"
#import "AGTLibrary.h"
#import "AGTBooksViewController.h"
#import "AGTBook.h"
#import "Cons.h"

@interface AGTLibraryTableViewController ()

@end

@implementation AGTLibraryTableViewController

#pragma mark - Init
-(id) initWithModel: (AGTLibrary *) model style: (UITableViewStyle) style{
    
    if (self = [super initWithStyle:style]) {
        _model = model;
        self.title = TITLE_LIBRARY;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Meto esto aquí ya que si lo pongo en el AGTLibraryTableViewController al cerrarse la tabla cuando pongo el simulador horizontal se da de baja de las notificaciones en el dealloc y no las recibe
    //No creo que esto esté correcto
#warning Comprobar donde poner la notificación
    //Alta en notificación cargada la tabla
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(notifyThatBooksDidChange:)
               name:NOTIFICATION_DATA_IN_MODEL_NAME
             object:nil];
    
    
    
    
    
}


-(void) dealloc{
    //Me doy de baja de las notificaciones
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    int numberSection = 1;
    numberSection += self.model.tagsCount;
    return numberSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (section == FAVORITE_SECTION) {
        return self.model.favoritesCount;
    }else{
        int sectionABuscar = section;
        sectionABuscar -= 1;
        NSString *tag = [self.model.tagsBooks objectAtIndex:sectionABuscar];
        NSArray *arr = [self.model.booksWithTags objectForKey:tag];
        return arr.count;
    }
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == FAVORITE_SECTION) {
        return TITLE_SECTION_FAVORITES;
    }else{
        return [self.model.tagsBooks objectAtIndex:section-1];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Obtener el book para la fila
    AGTBook *book = [self rowAtIndexPath: indexPath];
 
    //Crear una celda
    static NSString *cellId = CELL_ID;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        //La tenemos que crear nosotros desde cero
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    //Configurarla
    //Sincronizar modelo (pj) con la vista (celda)
    cell.imageView.image = book.image;
    cell.textLabel.text = book.titulo;
    cell.detailTextLabel.text = book.authorInString;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    

    
    //Devolverla
    return cell;
}

-(AGTBook *) rowAtIndexPath: (NSIndexPath *) indexPath{
    
    NSArray *tags = nil;
    
    if (indexPath.section == FAVORITE_SECTION) {
        tags = [self.model bookFavoriteAtIndex:FAVORITE_KEY_DICTIONARY];
    }else{
        NSString *tag = [self.model.tagsBooks objectAtIndex:indexPath.section-1];
        
        tags = [self.model bookTagAtIndex:tag];
    }
    AGTBook *book = [tags objectAtIndex:indexPath.row];
    
    return book;
}



#pragma mark - Delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    //Obtener el book seleccionado
    AGTBook *book = [self rowAtIndexPath: indexPath];
    
    //Avisar al delegado siempre y cuando entienda el mensaje
    if ([self.delegate respondsToSelector:@selector(libraryTableViewController:didSelectedBook:)])  {
        
        //te lo mando
        [self.delegate libraryTableViewController:self didSelectedBook:book];
    }
    
    // mandamos una notificacion
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    NSDictionary *dict = @{NOTIFICATION_SELECT_BOOK_LIBRARY_KEY : book};
    
    NSNotification *n = [NSNotification notificationWithName:NOTIFICATION_SELECT_BOOK_LIBRARY_NAME object:self userInfo:dict];
    
    [nc postNotification:n];

}

//Protocol
-(void) libraryTableViewController: (AGTLibraryTableViewController *)library didSelectedBook: (AGTBook *)book{
    
    //Creamos un book
    AGTBooksViewController *bookController = [[AGTBooksViewController alloc] initWithModel:book];
    
    //Hago un push
    [self.navigationController pushViewController:bookController animated:YES];
    
}

#pragma mark - Notification

// "dataChange"
-(void) notifyThatBooksDidChange:(NSNotification *) notification{
    
    //Actualizo la tabla cuando carga los datos
    [self.tableView reloadData];
    
}

// "favoritesChange"
-(void) notifyThatFavoritesDidChange:(NSNotification *) notification{
    
    
    //Sacamos el personaje
    NSDictionary *books = notification.userInfo;
    
    
    //Guardo los datos en el modelo
    for (id key in books){
        bool existe = false;
        AGTBook *book = [books objectForKey:key];
        
        if (book.isFavorite) {
            book.isFavorite = FALSE;
            
            
            NSMutableArray *arrayDeLibrosGuardados = [self.model.booksWithFavorites objectForKey:FAVORITE_KEY_DICTIONARY];
            
            //Me creo este array para la iteracion ya que si no falla al añadir al mismo array
            NSMutableArray *arrayParaIterar = [[NSMutableArray alloc] init];
            [arrayParaIterar addObjectsFromArray:arrayDeLibrosGuardados];
            
            
            //******CAmbiar esto que hace daño a los ojos********
            for (AGTBook* obj in arrayParaIterar){
                if([obj.titulo isEqualToString: book.titulo]){
                    [arrayDeLibrosGuardados removeObjectAtIndex:[arrayDeLibrosGuardados indexOfObject:obj]];
                    
                }
                
            }
            
            
        }else{
            book.isFavorite = TRUE;
            if ([self.model.booksWithFavorites objectForKey:FAVORITE_KEY_DICTIONARY]) {
                NSMutableArray *arrayDeLibrosGuardados = [self.model.booksWithFavorites objectForKey:FAVORITE_KEY_DICTIONARY];
                
                //Me creo este array para la iteracion ya que si no falla al añadir al mismo array
                NSMutableArray *arrayParaIterar = [[NSMutableArray alloc] init];
                [arrayParaIterar addObjectsFromArray:arrayDeLibrosGuardados];
                
                //******CAmbiar esto que hace daño a los ojos********
                for (AGTBook* obj in arrayParaIterar){
                    if([obj.titulo isEqualToString: book.titulo]){
                        existe = true;
                    }
                    
                }
                if (!existe) {
                    [arrayDeLibrosGuardados addObject:book];
                    [self.model.booksWithFavorites setValue:arrayDeLibrosGuardados forKey:FAVORITE_KEY_DICTIONARY];
                }
                
                
            }else{
                NSMutableArray *arrayDeLibrosGuardados = [[NSMutableArray alloc] init];
                [arrayDeLibrosGuardados addObject:book];
                [self.model.booksWithFavorites addEntriesFromDictionary:@{FAVORITE_KEY_DICTIONARY:arrayDeLibrosGuardados}];
            }
        }
        
        
        
        
    }

    //Actualizo la tabla cuando carga los datos
    [self.tableView reloadData];
    
}

@end
