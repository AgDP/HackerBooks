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
             autores: (NSArray *) autores
                tags: (NSArray *) tags
               image: (UIImage *) image
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

-(NSString *) autores{
    
    NSMutableString *cadena = [[NSMutableString alloc] init];

    for (int i=0; i < _autores.count; i++) {
        if (i > 0) {
            [cadena appendString:@","];
        }
        [cadena appendString:_autores[i]];
            
    }
    
    
    return cadena;
}

@end
