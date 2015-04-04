//
//  AGTLibrary.m
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import "AGTLibrary.h"


@interface AGTLibrary ()

@property (nonatomic, strong) NSDictionary *jsonDownloaded;

@end

@implementation AGTLibrary

#pragma mark - Properties
-(NSUInteger) favoritesCount{
    return [[self.booksWithFavorites objectForKey:@"favorite"]count];
}

-(NSUInteger) tagsCount{
    return self.tagsBooks.count;
}

-(id) init{
    
    if (self = [super init]) {
        
        self.favoritesBooks = [[NSMutableArray alloc] init];
        self.booksWithFavorites = [[NSMutableDictionary alloc] init];
        
        //Llamamos al JSON
        //[self didRecieveData];
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


-(NSUInteger)	booksCount{
    
    return nil;
}

-(NSArray*)	tags{
    
    
    return nil;
}

-(NSUInteger) bookCountForTag:(NSString*) tag{
    
    
    return nil;
}

-(NSArray*)	booksForTag: (NSString *) tag{
    
    return nil;
}

-(AGTBook*)	bookForTag:(NSString*) tag atIndex:(NSUInteger) index{
    
    
    return nil;
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
        [nombreLibro appendString:@"Documents/"];
        [nombreLibro appendString:[value objectForKey:@"title"]];
        [nombreLibro appendString:@".jpg"];
        
        //Averiguar la URL a la carpeta Documents
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:nombreLibro];
        UIImage* image = [UIImage imageWithContentsOfFile:jpgPath];
        
        NSArray *book1Authores = [[value objectForKey:@"authors"] componentsSeparatedByString:@","];
        NSArray *book1Tags = [[value objectForKey:@"tags"] componentsSeparatedByString:@", "];
        
        NSURL *pdf = [NSURL URLWithString:[[value objectForKey:@"pdf_url"] description]];
        
        AGTBook *book = [[AGTBook alloc] initWithTitulo:[value objectForKey:@"title"] autores:book1Authores tags:book1Tags image:image pdf:pdf isFavorite: FALSE];
        
        //Voy guardando los tags y los libros primero buscando si ya existe un tag igual para organizar los libros
        for (id c in book1Tags) {
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
    
    //Ordeno los tags alfabeticamente
    NSMutableArray *tagsLibros = [[NSMutableArray alloc] init];
    for (id keyTags in self.booksWithTags) {
        [tagsLibros addObject:keyTags];
    }
    
    [tagsLibros sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    self.tagsBooks = tagsLibros;
    //self.favoritesBooks = @[book1,book1];
    
    // mandamos una notificacion
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    NSDictionary *dict = @{@"bookNotify" : @"change"};
    
    NSNotification *n = [NSNotification notificationWithName:@"dataChange" object:self userInfo:dict];
    
    [nc postNotification:n];
    
    
}


-(void) obtenerArrayDeJSONInDocuments{
    
    //Averiguar la URL a la carpeta Documents
    NSString  *jsonFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/JSON.txt"];
    NSError *error = nil;
    
    NSData *JSONData = [NSData dataWithContentsOfFile:jsonFile options:NSDataReadingMappedIfSafe error:&error];
    
    // Create an Objective-C object from JSON Data
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:JSONData
                                                   options:0
                                                     error:nil];
    
    self.jsonDownloaded = json;
}

@end
