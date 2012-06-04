package DVD::DVDList;
use strict;
use warnings;
use Dancer::Plugin::Database;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    return $self;
}

sub get_dvd_list {
    my $name = database->quick_select('dvds', { id => 1 });
    return $name;
}


1;
