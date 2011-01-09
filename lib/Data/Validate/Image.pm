package Data::Validate::Image;
use strict;
use warnings;

use Image::Info;

sub new{
    my $incovant = shift;
    my $class = ref( $incovant ) || $incovant;

    my $self = {};
    bless( $self, $class );

    return $self;
}

sub validate{
    my ( $self, $file ) = @_;

    my $image_type = Image::Info::image_info($file);

    if ( !defined( $image_type->{'file_ext'} ) ){
        return undef;
    }

    my @frames = `convert -identify '${file}' /dev/null 2> /dev/null`;

    if ( $? ){
    # convert returns 0 on success - prolly a corrupt image
        return undef;
    }

    return {
        'width' => $image_type->{'width'},
        'height' => $image_type->{'height'},
        'size' => (-s $file) / 1024,
        'mime' => $image_type->{'file_media_type'},
        'file_ext' => $image_type->{'file_ext'},
        'frames' => scalar( @frames ),
        'animated' => ($#frames) ? 1 : 0,
    };
}

1;

=head1 NAME

Data::Validate::Image - Validates an image and returns basic info

=head1 SYNOPSIS

    use Data::Validate::Image;

    my $validator = Data::Validate::Image->new();
    my $image_info = $validator->validate( '/path/to/image' );

    if ( defined( $image_info ) ){
        #valid image, do things here
    } else {
        #invalid image
    }

=head1 DESCRIPTION

pretty simple image validator class. returns hash of image properties on success, 

undef for invalid images

hash properties are

    'width' => image width,
    'height' => image height,
    'size' => image filesize (KB),
    'mime' => image mime type,
    'file_ext' => *correct* file extenstion,
    'frames' => frame count,
    'animated' => 1 || 0,

=head1 METHODS

=head2 validate

    returns image info or undef for invalid image

=head1 SUPPORT

Bugs should always be submitted via the CPAN bug tracker

For other issues, contact the maintainer

=head1 AUTHORS

n0body E<lt>n0body@thisaintnews.comE<gt>

=head1 SEE ALSO

L<http://thisaintnews.com>, L<Image::Info>

=head1 LICENSE

Copyright (C) 2011 by n0body L<http://thisaintnews.com/>

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
