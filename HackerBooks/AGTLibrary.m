//
//  AGTLibrary.m
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import "AGTLibrary.h"


@interface AGTLibrary ()

@property (nonatomic, strong) NSArray *favoritesBooks;

@property (nonatomic, strong) NSDictionary *jsonDownloaded;

@end

@implementation AGTLibrary

#pragma mark - Properties
-(NSUInteger) favoritesCount{
    return self.favoritesBooks.count;
}

-(NSUInteger) tagsCount{
    return self.tagsBooks.count;
}

-(id) init{
    
    if (self = [super init]) {
        
        
        
        
        //Guardo el fichero para la proxima vez no tener que descargarlo
        
        
        
        
        //Creo un par de libros

        
        
    }
    
    return self;
    
}

-(id) initWithArray{
    
    if (self = [super init]) {
        //Llamamos al JSON
        [self didRecieveData];
    }
    
    return self;
}

//Devuelvo un bookFavorite en concreto
-(NSArray *) bookFavoriteAtIndex:(NSUInteger) index{
    
    return [self.favoritesBooks objectAtIndex:index];
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

- (void) didRecieveData{
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"]];
    
    __block NSDictionary *json;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               json = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];
                               //NSLog(@"Async JSON: %@", json);
                               self.jsonDownloaded = json;
                               [self didChangeJSONToData];
                           }];
    
}

-(void) didChangeJSONToData {
    

    self.booksWithTags = [[NSMutableDictionary alloc] init];
//    NSDictionary *theValues = [NSDictionary dictionaryWithDictionary:[self.jsonDownloaded valueForKey:@"value"]];
    NSDictionary *dictobj = self.jsonDownloaded;
    for (id key in dictobj)
    {
    //    AGTBook *book11 = [[AGTBook alloc] init];
        NSDictionary *value = key;
        //[value ];
    //    [book11 setTitulo:[value objectForKey:@"title"]];
  //      [book11 setTitulo:[value objectForKey:@"pdf_url"]];
    //    [book11 setTitulo:[value objectForKey:@"authors"]];
  //    [book11 setTitulo:[value objectForKey:@"image_url"]];
    //    [book11 setTitulo:[value objectForKey:@"tags"]];
        
        NSData *bookImage = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[value objectForKey:@"image_url"] description]]];
        UIImage *image = [UIImage imageWithData:bookImage];
        
        NSArray *book1Authores = [[value objectForKey:@"authors"] componentsSeparatedByString:@","];
        NSArray *book1Tags = [[value objectForKey:@"tags"] componentsSeparatedByString:@", "];
        
        
        AGTBook *book = [[AGTBook alloc] initWithTitulo:[value objectForKey:@"title"] autores:book1Authores tags:book1Tags image:image pdf:nil];
        
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

@end
