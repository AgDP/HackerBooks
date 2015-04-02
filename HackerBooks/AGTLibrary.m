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
@property (nonatomic, strong) NSArray *tagsBooks;
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
        
        //Llamamos al JSON
        [self didRecieveData];
        
        
        //Guardo el fichero para la proxima vez no tener que descargarlo
        
        
        
        /*
        //Creo un par de libros

        NSData *book1Image = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:@"http://hackershelf.com/media/cache/46/61/46613d24474140c53ea6b51386f888ff.jpg"]];
        UIImage *image1 = [UIImage imageWithData:book1Image];
        
        
        NSDictionary *book1Authores = @{@"author1" : @"Allen B. Downey"};
        NSDictionary *book1Tags = @{@"tag1" : @"c"};
        
        
        AGTBook *book1 = [[AGTBook alloc] initWithTitulo:@"IOS" autores:book1Authores tags:book1Tags image:image1 pdf:nil];
        
        NSData *book2Image = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"http://hackershelf.com/media/cache/f3/fe/f3fec7d794709480759e9b311fb7f2ec.jpg"]];
        NSDictionary *book2Authores = @{@"author2" : @"Sanjoy Mahajan"};
        NSDictionary *book2Tags = @{@"tag2" : @"python"};
        
        AGTBook *book2 = [[AGTBook alloc] initWithTitulo:@"Android" autores:book2Authores tags:book2Tags image:[UIImage imageWithData:book2Image] pdf:nil];

        //AGTBook *book3 = [[AGTBook alloc] initWithTitulo:@"Python" autores:nil tags:nil photo:nil pdf:nil];
        
        self.tagsBooks = @[book2,book1];
        self.favoritesBooks = @[book2,book1];
        */
    }
    
    return self;
    
}

//Devuelvo un bookFavorite en concreto
-(AGTBook *) bookFavoriteAtIndex:(NSUInteger) index{
    
    return [self.favoritesBooks objectAtIndex:index];
}

//Devuelvo un bookTag en concreto
-(AGTBook *) bookTagAtIndex:(NSUInteger) index{
    return [self.tagsBooks objectAtIndex:index];
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
                               NSLog(@"Async JSON: %@", json);
                               self.jsonDownloaded = json;
                               [self didChangeJSONToData];
                           }];
    
}

-(void) didChangeJSONToData {
    
NSMutableArray *arrat = [self.tagsBooks mutableCopy];
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
        
        NSData *book1Image = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[[value objectForKey:@"image_url"] description]]];
        UIImage *image1 = [UIImage imageWithData:book1Image];
        
        
        NSDictionary *book1Authores = @{@"author1" : @"Allen B. Downey"};
        NSDictionary *book1Tags = @{@"tag1" : @"c"};
        
        
        AGTBook *book1 = [[AGTBook alloc] initWithTitulo:@"IOS" autores:book1Authores tags:book1Tags image:image1 pdf:nil];
        
        
        [arrat addObject:book1];
        
        
        /*
         NSString *responseJSON =;
        Department *department = [[Department alloc] initWithString:responseJSON error:&err];
        if (!err)
        {
            for (Person *person in department.accounting) {
                
                NSLog(@"%@", person.firstName);
                NSLog(@"%@", person.lastName);
                NSLog(@"%@", person.age);
            }
            
            for (Person *person in department.sales) {
                
                NSLog(@"%@", person.firstName);
                NSLog(@"%@", person.lastName);
                NSLog(@"%@", person.age);
            }
        }*/
        
    }
    
    self.tagsBooks = arrat;
    //self.favoritesBooks = @[book1,book1];
    
    
}

@end
