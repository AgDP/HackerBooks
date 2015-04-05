//
//  AGTBook.h
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

@import UIKit;
@import Foundation;

@interface AGTBook : NSObject

@property (copy, nonatomic) NSString *titulo;
@property (strong, nonatomic) NSArray *autores;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *pdf;
@property (nonatomic) BOOL isFavorite;

//Designated
-(id) initWithTitulo: (NSString *)titulo
             autores: (NSArray *) autores
                tags: (NSArray *) tags
               image: (UIImage *) image
                 pdf: (NSURL *) pdf
          isFavorite: (BOOL) isFavorite;

-(NSString *) authorInString;
-(NSString *) tagsInString;

@end
