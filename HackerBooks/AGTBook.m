//
//  AGTBook.m
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import "AGTBook.h"

@implementation AGTBook


-(id) initWithTitulo: (NSString *)titulo
             autores: (NSDictionary *) autores
                tags: (NSDictionary *) tags
               photo: (UIImage *) image
                 pdf: (NSURL *) pdf{
    
    if (self = [super init]) {
        _titulo = titulo;
        _autores = autores;
        _tags = tags;
        _image = image;
        _pdf = pdf;
    }
    
    return self;
}

@end
