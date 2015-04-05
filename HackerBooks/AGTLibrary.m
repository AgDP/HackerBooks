//
//  AGTLibrary.m
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import "AGTLibrary.h"
#import "Cons.h"


@interface AGTLibrary ()

@property (nonatomic, strong) NSDictionary *jsonDownloaded;

@end

@implementation AGTLibrary

#pragma mark - Properties
-(NSUInteger) favoritesCount{
    return [[self.booksWithFavorites objectForKey:FAVORITE_KEY_DICTIONARY]count];
}

-(NSUInteger) tagsCount{
    return self.tagsBooks.count;
}

-(id) init{
    
    if (self = [super init]) {
        
        self.favoritesBooks = [[NSMutableArray alloc] init];
        self.booksWithFavorites = [[NSMutableDictionary alloc] init];
        
        //Llamamos al JSON
        [self obtenerArrayDeJSONInDocuments];
        [self didChangeJSONToData];
        
        
    }
    
    return self;
    
}


//Devuelvo un bookFavorite en concreto
-(NSArray *) bookFavoriteAtIndex:(NSString *) index{
    return [self.booksWithFavorites objectForKey:index];
}

//Devuelvo un bookTag en concreto
-(NSArray *) bookTagAtIndex: (NSString *) index{
    return [self.booksWithTags objectForKey:index];
}


-(void) didChangeJSONToData {
    

    self.booksWithTags = [[NSMutableDictionary alloc] init];

    NSDictionary *dictobj = self.jsonDownloaded;
    for (id key in dictobj){
        NSDictionary *value = key;
  //      [book11 setTitulo:[value objectForKey:@"pdf_url"]];

        
        //NSData *bookImage = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[value objectForKey:@"image_url"] description]]];
        //UIImage *image = [UIImage imageWithData:bookImage];
        //Guardamos la imagen con el nombre del libro + jpg
        NSMutableString *nombreLibro = [[NSMutableString alloc] init];
        [nombreLibro appendString:PATH_DATA_PICTURES];
        [nombreLibro appendString:[value objectForKey:TITLE_JSON_KEY]];
        [nombreLibro appendString:@".jpg"];
        
        //Averiguar la URL a la carpeta Documents
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:nombreLibro];
        UIImage* image = [UIImage imageWithContentsOfFile:jpgPath];
        
        NSArray *bookAuthores = [[value objectForKey:AUTHOR_JSON_KEY] componentsSeparatedByString:SEPARETE_ARRAY_JSON];
        NSArray *bookTags = [[value objectForKey:TAGS_JSON_KEY] componentsSeparatedByString:SEPARETE_ARRAY_JSON_WITH_SPACE];
        
        NSURL *pdf = [NSURL URLWithString:[[value objectForKey:PDF_JSON_KEY] description]];
        
        AGTBook *book = [[AGTBook alloc] initWithTitulo:[value objectForKey:TITLE_JSON_KEY] autores:bookAuthores tags:bookTags image:image pdf:pdf isFavorite: FALSE];
        
        //Voy guardando los tags y los libros primero buscando si ya existe un tag igual para organizar los libros
        [self saveDataTags: bookTags andBook:book];
        
    }
    
    //Ordeno los tags alfabeticamente
    [self putAlphabetTags];
    
    //Compruebo si existe el fichero. si no existe lo descargo
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString  *jsonFile = [NSHomeDirectory() stringByAppendingPathComponent:PATH_FAV_DOCUMENT];
    
    if ([fileManager fileExistsAtPath:jsonFile]){
    
        [self obtenerArrayDeJSONFavoritesInDocuments];
    }
    
    // mandamos una notificacion
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    NSDictionary *dict = @{NOTIFICATION_DATA_IN_MODEL_KEY : NOTIFICATION_DATA_IN_MODEL_DATA};
    
    NSNotification *n = [NSNotification notificationWithName:NOTIFICATION_DATA_IN_MODEL_NAME object:self userInfo:dict];
    
    [nc postNotification:n];
    
    
}


-(void) obtenerArrayDeJSONInDocuments{
    
    //Averiguar la URL a la carpeta Documents
    NSString  *jsonFile = [NSHomeDirectory() stringByAppendingPathComponent:PATH_JSON_DOCUMENT];
    NSError *error = nil;
    
    NSData *JSONData = [NSData dataWithContentsOfFile:jsonFile options:NSDataReadingMappedIfSafe error:&error];
    
    // Create an Objective-C object from JSON Data
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:JSONData
                                                   options:0
                                                     error:nil];
    
    self.jsonDownloaded = json;
}

-(void) saveDataTags: (NSArray *) bookTag andBook:(AGTBook *) book{
    
    for (id c in bookTag) {
        if ([self.booksWithTags objectForKey:c]) {
            NSMutableArray *arrayDeLibrosGuardados = [self.booksWithTags objectForKey:c];
            [arrayDeLibrosGuardados addObject:book];
            [self.booksWithTags setValue:arrayDeLibrosGuardados forKey:c];
        }else{
            NSMutableArray *arrayDeLibrosGuardados = [[NSMutableArray alloc] init];
            [arrayDeLibrosGuardados addObject:book];
            [self.booksWithTags addEntriesFromDictionary:@{c:arrayDeLibrosGuardados}];
        }
    }
}

-(void) putAlphabetTags{
    
    NSMutableArray *tagsLibros = [[NSMutableArray alloc] init];
    for (id keyTags in self.booksWithTags) {
        [tagsLibros addObject:keyTags];
    }
    
    [tagsLibros sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    self.tagsBooks = tagsLibros;
}

-(void) obtenerArrayDeJSONFavoritesInDocuments{
    //Averiguar la URL a la carpeta Documents
    NSString  *jsonFile = [NSHomeDirectory() stringByAppendingPathComponent:PATH_FAV_DOCUMENT];
    NSError *error = nil;
    
    NSData *JSONData = [NSData dataWithContentsOfFile:jsonFile options:NSDataReadingMappedIfSafe error:&error];
    
    // Create an Objective-C object from JSON Data
    
    NSArray *json = [NSJSONSerialization JSONObjectWithData:JSONData
                                                         options:0
                                                           error:nil];
    NSMutableArray *arrayDeLibrosGuardados = [[NSMutableArray alloc] init];
    NSDictionary *bookWithTag = self.booksWithTags;
    NSArray *keys = [bookWithTag allKeys];
    
    for (NSString *tituloBook in json) {
        bool existe = false;
        //Saco los book dentro de los tag para comparar por titulo
        for (NSString *tags in keys) {
            NSArray *books = [bookWithTag objectForKey:tags];
            
            if (!existe) {
                
            for (AGTBook *book in books) {
            
                if ([book.titulo isEqualToString:tituloBook]) {
                    
                    book.isFavorite = true;
                    [arrayDeLibrosGuardados addObject:book];
                    existe = true;
                    break;
                }

            }
            }
        }
        

    }
    
    [self.booksWithFavorites setValue:arrayDeLibrosGuardados forKey:FAVORITE_KEY_DICTIONARY];
}

@end
