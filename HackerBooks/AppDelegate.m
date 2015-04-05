//
//  AppDelegate.m
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import "AppDelegate.h"
#import "AGTLibraryTableViewController.h"
#import "AGTLibrary.h"
#import "AGTBooksViewController.h"
#import "Cons.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //Valor por defecto para saber si es la primera vez
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if (![def objectForKey:MARK_FIRST_TIME_NAME]) {
        
        //Descargo JSON
        [self didRecieveData];
       
        
        //Guardamos un valor por defecto
        [def setObject:@"1" forKey:MARK_FIRST_TIME_NAME];
        
        //Por si acaso...
        [def synchronize];
    }else{
        
        //Compruebo si existe el fichero. si no existe lo descargo
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString  *jsonFile = [NSHomeDirectory() stringByAppendingPathComponent:PATH_JSON_DOCUMENT];
        
        if (![fileManager fileExistsAtPath:jsonFile]){
            
            [self didRecieveData];

        }
    }
    
    // Creamos una vista de tipo UIWindow
    [self setWindow:[[UIWindow alloc]
                     initWithFrame:[[UIScreen mainScreen] bounds]]];
    
    //Creo el modelo
    AGTLibrary *library = [[AGTLibrary alloc] init];
    
    //Detectamos el tipo de pantalla
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        //Tipo tableta
        [self configureForPadWithModel: library];
    }else{
        
        //Tipo teléfono
        [self configureForPhoneWithModel:library];
    }
    
    
    
    // La mostramos
    [[self window] makeKeyAndVisible];
    
    
    
    
    return YES;
}


- (void) didRecieveData{
    
    NSURL *urlJson = [NSURL URLWithString:URL_JSON_DOWNLOAD];
    
    NSData *data = [NSData dataWithContentsOfURL:urlJson];
    
    [self saveDataIntoSandbox: (NSData *) data];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:nil];
    [self saveImagesIntoDcouments: (NSDictionary *) json];
}

-(void) saveDataIntoSandbox: (NSData *) data{
    
    //Averiguar la URL a la carpeta Documents
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *url = [urls lastObject];
    
    //Añadir el componente del nombre del fichero
    url = [url URLByAppendingPathComponent:NAME_FILE_JSON];
    
    //Guardar algo
    
    [data writeToURL:url atomically:YES];

    
}

-(void) saveImagesIntoDcouments: (NSDictionary *) json{
    
    NSDictionary *dictobj = json;
    for (id key in dictobj)
    {
        NSDictionary *value = key;
        //      [book11 setTitulo:[value objectForKey:@"pdf_url"]];
        
        
        NSData *bookImage = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[value objectForKey:@"image_url"] description]]];
        
        //Guardamos la imagen con el nombre del libro + jpg
        NSMutableString *nombreLibro = [[NSMutableString alloc] init];
        [nombreLibro appendString:@"Documents/"];
        [nombreLibro appendString:[value objectForKey:TITLE_JSON_KEY]];
        [nombreLibro appendString:@".jpg"];
        
        //Averiguar la URL a la carpeta Documents
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:nombreLibro];
        

        
        [bookImage writeToFile:jpgPath atomically:YES];
        
    }
    
}

-(void) configureForPadWithModel: (AGTLibrary *) library{
    
    //Creo los Controladores
    AGTLibraryTableViewController *libraryTable = [[AGTLibraryTableViewController alloc] initWithModel:library style:UITableViewStylePlain];
    
    AGTBooksViewController *bookController = [[AGTBooksViewController alloc] initWithModel:nil];
    
    
    //Creo los navigationControllers
    UINavigationController *navLib = [UINavigationController new];
    
    [navLib pushViewController:libraryTable animated:NO];
    
    UINavigationController *navBook = [UINavigationController new];
    
    [navBook pushViewController:bookController animated:YES];
    
    
    //Creo el combinador
    UISplitViewController *split = [[UISplitViewController alloc] init];
    
    [split setViewControllers:@[navLib, navBook]];
    
    
    //Asignamos delegados
    split.delegate = bookController;
    libraryTable.delegate = bookController;
    
    //La pinto
    self.window.rootViewController = split;
    
    
    // ¿Es correcto poner la notificación aqui?
    
    //Alta en notificación de cambio en favoritos
    [self createNotification:libraryTable];
    
}

-(void) configureForPhoneWithModel: (AGTLibrary *) library{
    
    //Creo el controlador
    AGTLibraryTableViewController *libraryTable = [[AGTLibraryTableViewController alloc] initWithModel:library style:UITableViewStylePlain];
    
    //Creo el combinador
    UINavigationController *navLib = [UINavigationController new];
    
    [navLib pushViewController:libraryTable animated:NO];
    
    //Asigno delegado
    libraryTable.delegate = libraryTable;
    
    //La pinto
    self.window.rootViewController = navLib;
    
    // ¿Es correcto poner la notificación aqui?
    
    //Alta en notificación de cambio en favoritos
    [self createNotification:libraryTable];
    
}

-(void) createNotification: (AGTLibraryTableViewController *) libraryTable{
    
    NSNotificationCenter *ncFavorite = [NSNotificationCenter defaultCenter];
    
    [ncFavorite addObserver:libraryTable
                   selector:@selector(notifyThatFavoritesDidChange:)
                       name:NOTIFICATION_MARK_BOOK_FAVORITE_NAME
                     object:nil];
}

@end
