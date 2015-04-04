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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //Valor por defecto para saber si es la primera vez
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if (![def objectForKey:@"firstTime"]) {
        
        //Descargo JSON
        [self didRecieveData];
       
        
        //Guardamos un valor por defecto
        [def setObject:@"1" forKey:@"firstTime"];
        
        //Por si acaso...
        [def synchronize];
    }else{
        
        //Compruebo si existe el fichero. si no existe lo descargo
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString  *jsonFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/JSON.txt"];
        
        if (![fileManager fileExistsAtPath:jsonFile]){
            
            NSLog(@"No existe");
            //Descargo JSON
           // NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"]];
            
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

-(AGTBook *) lastSelectedBookInModel: (AGTLibrary *) u{
    
    //Obtengo el NSUserDefaults
   /* NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    */
    //Saco las cordenadas del ultimo personaje
  /*  NSArray *coords = [def objectForKey:LAST_SELECTED_BOOK];
    NSUInteger section = [[coords objectAtIndex:0] integerValue];
    NSUInteger pos = [[coords objectAtIndex:1] integerValue];
  */
    
    
    //Obtengo el personaje
    AGTBook *book = [u bookTagAtIndex:0];
    /*if (section == FAVORITE_SECTION) {
        book = [u bookFavoriteAtIndex:pos];
    }else{
        book = [u bookTagAtIndex:pos];
    }*/
    
    
    //Lo devuelvo
    return book;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void) didRecieveData{
    
    NSURL *urlJson = [NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"];
    
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
    url = [url URLByAppendingPathComponent:@"JSON.txt"];
    
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
        
        
        //AGTBook *book = [[AGTBook alloc] initWithTitulo:[value objectForKey:@"title"] autores:book1Authores tags:book1Tags image:image pdf:nil];
        
        //Guardamos la imagen con el nombre del libro + jpg
        NSMutableString *nombreLibro = [[NSMutableString alloc] init];
        [nombreLibro appendString:@"Documents/"];
        [nombreLibro appendString:[value objectForKey:@"title"]];
        [nombreLibro appendString:@".jpg"];
        
        //Averiguar la URL a la carpeta Documents
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:nombreLibro];
        

        
        [bookImage writeToFile:jpgPath atomically:YES];
        
    }
    
}

-(void) configureForPadWithModel: (AGTLibrary *) library{
    
    //Creo los Controladores
    AGTLibraryTableViewController *libraryTable = [[AGTLibraryTableViewController alloc] initWithModel:library style:UITableViewStylePlain];
    
    AGTBooksViewController *bookController = [[AGTBooksViewController alloc] initWithModel:[self lastSelectedBookInModel:library]];
    
    
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
    NSNotificationCenter *ncFavorite = [NSNotificationCenter defaultCenter];
    
    [ncFavorite addObserver:libraryTable
                   selector:@selector(notifyThatFavoritesDidChange:)
                       name:@"favoriteChange"
                     object:nil];
    
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
    NSNotificationCenter *ncFavorite = [NSNotificationCenter defaultCenter];
    
    [ncFavorite addObserver:libraryTable
                   selector:@selector(notifyThatFavoritesDidChange:)
                       name:@"favoriteChange"
                     object:nil];
    
}

@end
