//
//  AGTLibrary.m
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import "AGTLibrary.h"
#import "AGTBook.h"

@interface AGTLibrary ()

@property (nonatomic, strong) NSArray *favoritesBooks;
@property (nonatomic, strong) NSArray *tagsBooks;

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
        
        //Creo un par de libros
        NSData *book1Image = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"http://hackershelf.com/media/cache/46/61/46613d24474140c53ea6b51386f888ff.jpg"]];
        NSDictionary *book1Authores = @{@"author1" : @"Allen B. Downey"};
        NSDictionary *book1Tags = @{@"tag1" : @"c"};
        
        AGTBook *book1 = [[AGTBook alloc] initWithTitulo:@"IOS" autores:book1Authores tags:book1Tags photo:[UIImage imageWithData:book1Image] pdf:nil];
        
        NSData *book2Image = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"http://hackershelf.com/media/cache/f3/fe/f3fec7d794709480759e9b311fb7f2ec.jpg"]];
        NSDictionary *book2Authores = @{@"author2" : @"Sanjoy Mahajan"};
        NSDictionary *book2Tags = @{@"tag2" : @"python"};
        
        AGTBook *book2 = [[AGTBook alloc] initWithTitulo:@"Android" autores:book2Authores tags:book2Tags photo:[UIImage imageWithData:book2Image] pdf:nil];

        //AGTBook *book3 = [[AGTBook alloc] initWithTitulo:@"Python" autores:nil tags:nil photo:nil pdf:nil];
        
        self.tagsBooks = @[book1,book2];
        self.favoritesBooks = @[book2,book1];
        
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

@end
